package privacy

import (
	"bytes"
	"errors"
	"image"
	"image/jpeg"
	"os"
	"strconv"

	"gocv.io/x/gocv"
)

var (
	ErrInvalidImage = errors.New("invalid image data")
)

// Config for privacy processing
type Config struct {
	// MinConfidence is the minimum confidence threshold for face/body detection
	// Below this threshold, we blur the entire frame
	MinConfidence float32

	// BlurKernelSize controls the strength of blur (must be odd)
	BlurKernelSize int

	// ExpandRegion expands the detected region by this percentage to ensure coverage
	ExpandRegion float32

	// Distance-based blur settings
	EnableDistanceBlur bool
	NearThreshold      float32 // Fraction of frame height (0.7 = bottom 70%)
	MediumThreshold    float32 // Fraction (0.5 = middle 50%)
	FarThreshold       float32 // Fraction (0.3 = top 30%)

	// Graduated blur kernel sizes
	LightBlurKernel  int
	MediumBlurKernel int
	HeavyBlurKernel  int
}

// DefaultConfig returns recommended privacy settings
func DefaultConfig() Config {
	config := Config{
		MinConfidence:  0.7,
		BlurKernelSize: 51,   // Strong blur
		ExpandRegion:   0.25, // Expand by 25%

		// Distance blur defaults (heuristic mode)
		EnableDistanceBlur: getEnvBool("ENABLE_DISTANCE_BLUR", true),
		NearThreshold:      0.7, // Bottom 70% is "near"
		MediumThreshold:    0.5, // Middle 50% is "medium distance"
		FarThreshold:       0.3, // Top 30% is "far"

		// Graduated blur kernels
		LightBlurKernel:  15,
		MediumBlurKernel: 31,
		HeavyBlurKernel:  51,
	}

	return config
}

func getEnvBool(key string, defaultVal bool) bool {
	val := os.Getenv(key)
	if val == "" {
		return defaultVal
	}
	b, err := strconv.ParseBool(val)
	if err != nil {
		return defaultVal
	}
	return b
}

// Processor handles privacy-preserving video frame processing
type Processor struct {
	config Config

	// OpenCV face detector using Haar Cascade
	faceClassifier gocv.CascadeClassifier

	// For body detection, we'll use a simplified approach:
	// Detect skin tones and blur those regions
	skinDetector *SkinDetector
}

// NewProcessor creates a new privacy processor
func NewProcessor(config Config) (*Processor, error) {
	// Load Haar Cascade for face detection
	classifier := gocv.NewCascadeClassifier()
	if !classifier.Load("haarcascade_frontalface_default.xml") {
		return nil, errors.New("failed to load face classifier")
	}

	return &Processor{
		config:         config,
		faceClassifier: classifier,
		skinDetector:   NewSkinDetector(),
	}, nil
}

// Config returns the processor configuration
func (p *Processor) Config() Config {
	return p.config
}

// ProcessFrame applies privacy filtering to a frame
// Returns the blurred frame and a boolean indicating if full-frame blur was applied
func (p *Processor) ProcessFrame(frameData []byte) ([]byte, bool, error) {
	// Decode JPEG
	img, err := jpeg.Decode(bytes.NewReader(frameData))
	if err != nil {
		return nil, false, ErrInvalidImage
	}

	// Convert to gocv Mat
	mat, err := gocv.ImageToMatRGB(img)
	if err != nil {
		return nil, false, err
	}
	defer mat.Close()

	// Apply distance-based blur as base layer if enabled
	if p.config.EnableDistanceBlur {
		mat = p.applyHeuristicDistanceBlur(mat)
	}

	// Detect faces
	faces := p.detectFaces(mat)

	// Detect body/skin regions
	bodyRegions := p.skinDetector.DetectSkinRegions(mat)

	// Check if we have low confidence - if so, blur entire frame
	fullFrameBlur := len(faces) == 0 && len(bodyRegions) > 10

	if fullFrameBlur {
		// Apply full frame blur as safety fallback
		blurred := gocv.NewMat()
		defer blurred.Close()
		gocv.GaussianBlur(mat, &blurred, image.Point{X: p.config.BlurKernelSize, Y: p.config.BlurKernelSize}, 0, 0, gocv.BorderDefault)

		return matToJPEG(blurred)
	}

	// Blur detected regions (on top of distance blur)
	blurred := mat.Clone()
	defer blurred.Close()

	// Blur faces with expanded regions
	for _, face := range faces {
		expanded := expandRect(face, p.config.ExpandRegion, mat.Cols(), mat.Rows())
		p.blurRegion(&blurred, expanded)
	}

	// Blur body/skin regions
	for _, region := range bodyRegions {
		expanded := expandRect(region, p.config.ExpandRegion, mat.Cols(), mat.Rows())
		p.blurRegion(&blurred, expanded)
	}

	return matToJPEG(blurred)
}

// applyHeuristicDistanceBlur applies graduated blur based on vertical position
// Objects higher in frame = farther away = more blur
func (p *Processor) applyHeuristicDistanceBlur(img gocv.Mat) gocv.Mat {
	height := img.Rows()
	width := img.Cols()

	// Calculate threshold Y coordinates
	nearY := int(float32(height) * p.config.NearThreshold)     // e.g., 70% from top
	mediumY := int(float32(height) * p.config.MediumThreshold) // e.g., 50% from top
	farY := int(float32(height) * p.config.FarThreshold)       // e.g., 30% from top

	result := img.Clone()

	// Apply blur to different zones
	// Very far zone (top 10-30%)
	if farY > 0 {
		veryFarRegion := result.Region(image.Rect(0, 0, width, farY))
		veryFarBlurred := gocv.NewMat()
		gocv.GaussianBlur(veryFarRegion, &veryFarBlurred,
			image.Point{X: p.config.HeavyBlurKernel, Y: p.config.HeavyBlurKernel},
			0, 0, gocv.BorderDefault)
		veryFarBlurred.CopyTo(&veryFarRegion)
		veryFarBlurred.Close()
		veryFarRegion.Close()
	}

	// Far zone (30-50%)
	if mediumY > farY {
		farRegion := result.Region(image.Rect(0, farY, width, mediumY))
		farBlurred := gocv.NewMat()
		gocv.GaussianBlur(farRegion, &farBlurred,
			image.Point{X: p.config.MediumBlurKernel, Y: p.config.MediumBlurKernel},
			0, 0, gocv.BorderDefault)
		farBlurred.CopyTo(&farRegion)
		farBlurred.Close()
		farRegion.Close()
	}

	// Medium zone (50-70%)
	if nearY > mediumY {
		mediumRegion := result.Region(image.Rect(0, mediumY, width, nearY))
		mediumBlurred := gocv.NewMat()
		gocv.GaussianBlur(mediumRegion, &mediumBlurred,
			image.Point{X: p.config.LightBlurKernel, Y: p.config.LightBlurKernel},
			0, 0, gocv.BorderDefault)
		mediumBlurred.CopyTo(&mediumRegion)
		mediumBlurred.Close()
		mediumRegion.Close()
	}

	// Near zone (bottom 70%) - no distance blur, only face/body detection

	return result
}

// detectFaces detects faces in the frame
func (p *Processor) detectFaces(mat gocv.Mat) []image.Rectangle {
	gray := gocv.NewMat()
	defer gray.Close()
	gocv.CvtColor(mat, &gray, gocv.ColorBGRToGray)

	rects := p.faceClassifier.DetectMultiScale(gray)
	return rects
}

// blurRegion applies strong Gaussian blur to a specific region
func (p *Processor) blurRegion(mat *gocv.Mat, rect image.Rectangle) {
	// Extract region
	region := mat.Region(rect)
	defer region.Close()

	// Apply Gaussian blur
	blurred := gocv.NewMat()
	defer blurred.Close()
	gocv.GaussianBlur(region, &blurred, image.Point{X: p.config.BlurKernelSize, Y: p.config.BlurKernelSize}, 0, 0, gocv.BorderDefault)

	// Copy back to original
	blurred.CopyTo(mat.Region(rect))
}

// expandRect expands a rectangle by a percentage
func expandRect(rect image.Rectangle, percent float32, maxWidth, maxHeight int) image.Rectangle {
	width := rect.Dx()
	height := rect.Dy()

	expandX := int(float32(width) * percent / 2)
	expandY := int(float32(height) * percent / 2)

	newRect := image.Rectangle{
		Min: image.Point{
			X: max(0, rect.Min.X-expandX),
			Y: max(0, rect.Min.Y-expandY),
		},
		Max: image.Point{
			X: min(maxWidth, rect.Max.X+expandX),
			Y: min(maxHeight, rect.Max.Y+expandY),
		},
	}

	return newRect
}

// matToJPEG converts a gocv.Mat to JPEG bytes
func matToJPEG(mat gocv.Mat) ([]byte, bool, error) {
	img, err := mat.ToImage()
	if err != nil {
		return nil, false, err
	}

	var buf bytes.Buffer
	err = jpeg.Encode(&buf, img, &jpeg.Options{Quality: 85})
	if err != nil {
		return nil, false, err
	}

	return buf.Bytes(), false, nil
}

func max(a, b int) int {
	if a > b {
		return a
	}
	return b
}

func min(a, b int) int {
	if a < b {
		return a
	}
	return b
}

// Close releases resources
func (p *Processor) Close() {
	p.faceClassifier.Close()
}
