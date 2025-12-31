package privacy

import (
	"image"

	"gocv.io/x/gocv"
)

// SkinDetector detects skin-tone regions which likely contain body parts
type SkinDetector struct {
	lowerBound gocv.Mat
	upperBound gocv.Mat
}

// NewSkinDetector creates a new skin detector
func NewSkinDetector() *SkinDetector {
	// HSV color range for skin tones (calibrated for various skin tones)
	lower := gocv.NewMatFromScalar(gocv.NewScalar(0, 20, 70, 0), gocv.MatTypeCV8UC3)
	upper := gocv.NewMatFromScalar(gocv.NewScalar(20, 255, 255, 0), gocv.MatTypeCV8UC3)

	return &SkinDetector{
		lowerBound: lower,
		upperBound: upper,
	}
}

// DetectSkinRegions detects regions with skin tones
func (sd *SkinDetector) DetectSkinRegions(mat gocv.Mat) []image.Rectangle {
	// Convert to HSV color space
	hsv := gocv.NewMat()
	defer hsv.Close()
	gocv.CvtColor(mat, &hsv, gocv.ColorBGRToHSV)

	// Create mask for skin tones
	mask := gocv.NewMat()
	defer mask.Close()
	gocv.InRange(hsv, sd.lowerBound, sd.upperBound, &mask)

	// Morphological operations to remove noise
	kernel := gocv.GetStructuringElement(gocv.MorphEllipse, image.Point{X: 5, Y: 5})
	defer kernel.Close()

	gocv.Erode(mask, &mask, kernel)
	gocv.Dilate(mask, &mask, kernel)

	// Find contours
	contours := gocv.FindContours(mask, gocv.RetrievalExternal, gocv.ChainApproxSimple)
	defer contours.Close()

	// Convert contours to bounding rectangles
	var regions []image.Rectangle
	for i := 0; i < contours.Size(); i++ {
		contour := contours.At(i)
		area := gocv.ContourArea(contour)

		// Only consider regions larger than 500 pixels
		if area > 500 {
			rect := gocv.BoundingRect(contour)
			regions = append(regions, rect)
		}
	}

	return regions
}

// Close releases resources
func (sd *SkinDetector) Close() {
	sd.lowerBound.Close()
	sd.upperBound.Close()
}
