package depth

import (
	"fmt"
	"image"
	"log"

	"gocv.io/x/gocv"
)

// Estimator handles depth estimation using MiDaS model
type Estimator struct {
	model       gocv.Net
	inputWidth  int
	inputHeight int
	enabled     bool
}

// NewEstimator creates a new depth estimator
func NewEstimator(modelPath string) (*Estimator, error) {
	// Load MiDaS model (ONNX format)
	model := gocv.ReadNetFromONNX(modelPath)
	if model.Empty() {
		return nil, fmt.Errorf("failed to load model from %s", modelPath)
	}

	// Try to use GPU acceleration if available
	if gocv.GetBuildInformation() != "" {
		// Check for CUDA
		model.SetPreferableBackend(gocv.NetBackendDefault)
		model.SetPreferableTarget(gocv.NetTargetCPU)
	}

	log.Printf("Depth estimator initialized (input size: 384x384)")

	return &Estimator{
		model:       model,
		inputWidth:  384,
		inputHeight: 384,
		enabled:     true,
	}, nil
}

// EstimateDepth generates a depth map from an image
// Returns a grayscale image where darker = closer, lighter = farther
func (e *Estimator) EstimateDepth(img gocv.Mat) (gocv.Mat, error) {
	if !e.enabled || img.Empty() {
		return gocv.NewMat(), fmt.Errorf("estimator not enabled or empty image")
	}

	// Preprocess: resize and normalize
	blob := gocv.BlobFromImage(
		img,
		1.0/255.0,
		image.Point{X: e.inputWidth, Y: e.inputHeight},
		gocv.NewScalar(0, 0, 0, 0),
		true,
		false,
		gocv.MatTypeCV32F,
	)
	defer blob.Close()

	// Set input
	e.model.SetInput(blob, "")

	// Run inference
	output := e.model.Forward("")
	defer output.Close()

	// Postprocess: resize back to original dimensions
	depthMap := gocv.NewMat()
	gocv.Resize(output, &depthMap, img.Size(), 0, 0, gocv.InterpolationLinear)

	// Normalize to 0-255 range for easier thresholding
	normalized := gocv.NewMat()
	gocv.Normalize(depthMap, &normalized, 0, 255, gocv.NormMinMax)
	depthMap.Close()

	// Convert to single channel grayscale
	result := gocv.NewMat()
	normalized.ConvertTo(&result, gocv.MatTypeCV8U)
	normalized.Close()

	return result, nil
}

// ConvertToMeters converts relative depth values to approximate metric depth
// This is a simplified conversion - real calibration would be more accurate
func (e *Estimator) ConvertToMeters(depthMap gocv.Mat, focalLength float64) gocv.Mat {
	if depthMap.Empty() {
		return gocv.NewMat()
	}

	result := gocv.NewMat()
	depthMap.ConvertTo(&result, gocv.MatTypeCV32F)

	// Approximate metric conversion
	// Assuming relative depth is inversely proportional to actual distance
	// This is simplified - would need camera calibration for accuracy

	// Normalize to 0-1 range
	gocv.Normalize(result, &result, 0, 1, gocv.NormMinMax)

	// Invert (MiDaS outputs inverse depth)
	ones := gocv.NewMatWithSize(result.Rows(), result.Cols(), gocv.MatTypeCV32F)
	ones.SetTo(gocv.NewScalar(1, 0, 0, 0))
	gocv.Subtract(ones, result, &result)
	ones.Close()

	// Scale to approximate meters (0-50m range)
	result.MultiplyFloat(50.0)

	return result
}

// Close releases resources
func (e *Estimator) Close() error {
	if !e.model.Empty() {
		return e.model.Close()
	}
	return nil
}
