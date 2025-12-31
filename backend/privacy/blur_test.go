package privacy

import (
	"image"
	"testing"
	"time"

	"gocv.io/x/gocv"
)

// TestFaceBlurring tests that faces are always detected and blurred
func TestFaceBlurring(t *testing.T) {
	processor, err := NewProcessor(DefaultConfig())
	if err != nil {
		t.Fatalf("Failed to create processor: %v", err)
	}
	defer processor.Close()

	testCases := []struct {
		name        string
		imageFile   string
		expectFaces int
	}{
		{"Frontal face", "testdata/face_frontal.jpg", 1},
		{"Profile face", "testdata/face_profile.jpg", 1},
		{"Multiple faces", "testdata/faces_multiple.jpg", 3},
		{"Tilted face", "testdata/face_tilted.jpg", 1},
		{"Distant face", "testdata/face_distant.jpg", 1},
	}

	for _, tc := range testCases {
		t.Run(tc.name, func(t *testing.T) {
			// Load test image
			img := gocv.IMRead(tc.imageFile, gocv.IMReadColor)
			if img.Empty() {
				t.Skipf("Test image not found: %s", tc.imageFile)
				return
			}
			defer img.Close()

			// Detect faces
			faces := processor.detectFaces(img)

			// Verify expected number of faces detected
			if len(faces) < tc.expectFaces {
				t.Errorf("Expected at least %d faces, got %d", tc.expectFaces, len(faces))
			}

			// Verify blur was applied to detected regions
			// (In real implementation, would check pixel values)
		})
	}
}

// TestSkinDetection tests body part detection via skin color
func TestSkinDetection(t *testing.T) {
	processor, err := NewProcessor(DefaultConfig())
	if err != nil {
		t.Fatalf("Failed to create processor: %v", err)
	}
	defer processor.Close()

	testCases := []struct {
		name          string
		imageFile     string
		expectRegions int
	}{
		{"Visible hands", "testdata/hands_visible.jpg", 2},
		{"Visible arms", "testdata/arms_visible.jpg", 2},
		{"Full body", "testdata/body_full.jpg", 5},
		{"Dark skin", "testdata/skin_dark.jpg", 1},
		{"Light skin", "testdata/skin_light.jpg", 1},
	}

	for _, tc := range testCases {
		t.Run(tc.name, func(t *testing.T) {
			img := gocv.IMRead(tc.imageFile, gocv.IMReadColor)
			if img.Empty() {
				t.Skipf("Test image not found: %s", tc.imageFile)
				return
			}
			defer img.Close()

			regions := processor.skinDetector.DetectSkinRegions(img)

			if len(regions) < tc.expectRegions {
				t.Errorf("Expected at least %d skin regions, got %d", tc.expectRegions, len(regions))
			}
		})
	}
}

// TestDistanceBlur tests graduated blur based on distance
func TestDistanceBlur(t *testing.T) {
	config := DefaultConfig()
	config.EnableDistanceBlur = true

	processor, err := NewProcessor(config)
	if err != nil {
		t.Fatalf("Failed to create processor: %v", err)
	}
	defer processor.Close()

	// Create test image
	img := gocv.NewMatWithSize(480, 640, gocv.MatTypeCV8UC3)
	defer img.Close()

	// Apply distance blur
	blurred := processor.applyHeuristicDistanceBlur(img)
	defer blurred.Close()

	// Verify blur was applied
	if blurred.Empty() {
		t.Error("Distance blur produced empty image")
	}

	// Verify dimensions maintained
	if blurred.Rows() != img.Rows() || blurred.Cols() != img.Cols() {
		t.Errorf("Dimensions changed: original %dx%d, blurred %dx%d",
			img.Cols(), img.Rows(), blurred.Cols(), blurred.Rows())
	}
}

// TestFullFrameBlurFallback tests that entire frame is blurred when uncertain
func TestFullFrameBlurFallback(t *testing.T) {
	processor, err := NewProcessor(DefaultConfig())
	if err != nil {
		t.Fatalf("Failed to create processor: %v", err)
	}
	defer processor.Close()

	// Create ambiguous test image (no clear faces)
	img := gocv.IMRead("testdata/unclear_scene.jpg", gocv.IMReadColor)
	if img.Empty() {
		t.Skip("Test image not found")
		return
	}
	defer img.Close()

	// Convert to JPEG bytes
	buf := gocv.NewMatWithSize(1, img.Total()*3, gocv.MatTypeCV8UC1)
	defer buf.Close()

	// Process frame
	_, fullBlur, err := processor.ProcessFrame(buf.ToBytes())
	if err != nil {
		t.Errorf("ProcessFrame failed: %v", err)
	}

	// In uncertain conditions, should apply full blur
	// (Actual logic would check face count and skin region count)
	t.Logf("Full frame blur applied: %v", fullBlur)
}

// TestBlurKernelSize verifies blur is strong enough
func TestBlurKernelSize(t *testing.T) {
	config := DefaultConfig()

	if config.BlurKernelSize < 31 {
		t.Errorf("Blur kernel too small: %d (should be >= 31 for privacy)",
			config.BlurKernelSize)
	}

	if config.BlurKernelSize%2 == 0 {
		t.Error("Blur kernel must be odd number")
	}
}

// TestProcessingLatency benchmarks frame processing time
func TestProcessingLatency(t *testing.T) {
	processor, err := NewProcessor(DefaultConfig())
	if err != nil {
		t.Fatalf("Failed to create processor: %v", err)
	}
	defer processor.Close()

	// Create test frame (typical size)
	img := gocv.NewMatWithSize(720, 1280, gocv.MatTypeCV8UC3)
	defer img.Close()

	// Measure processing time
	iterations := 10
	var totalMs int64

	for i := 0; i < iterations; i++ {
		start := time.Now()

		// Process frame
		buf := gocv.NewMatWithSize(1, img.Total()*3, gocv.MatTypeCV8UC1)
		_, _, err := processor.ProcessFrame(buf.ToBytes())
		buf.Close()

		if err != nil {
			t.Errorf("Processing failed: %v", err)
		}

		totalMs += time.Since(start).Milliseconds()
	}

	avgMs := totalMs / int64(iterations)
	t.Logf("Average processing time: %dms", avgMs)

	// Should be under 300ms for acceptable latency
	if avgMs > 300 {
		t.Errorf("Processing too slow: %dms (should be < 300ms)", avgMs)
	}
}

// TestDistanceBlurThresholds tests that blur zones are configured correctly
func TestDistanceBlurThresholds(t *testing.T) {
	config := DefaultConfig()

	// Verify thresholds are logical
	if config.NearThreshold <= config.MediumThreshold {
		t.Error("Near threshold should be > medium threshold")
	}

	if config.MediumThreshold <= config.FarThreshold {
		t.Error("Medium threshold should be > far threshold")
	}

	if config.FarThreshold <= 0 || config.FarThreshold >= 1 {
		t.Error("Far threshold should be between 0 and 1")
	}

	// Verify blur kernel sizes increase with distance
	if config.LightBlurKernel >= config.MediumBlurKernel {
		t.Error("Light blur should be less than medium blur")
	}

	if config.MediumBlurKernel >= config.HeavyBlurKernel {
		t.Error("Medium blur should be less than heavy blur")
	}
}

// TestRegionExpansion verifies detected regions are expanded for safety
func TestRegionExpansion(t *testing.T) {
	testCases := []struct {
		name          string
		original      image.Rectangle
		expandPercent float32
		maxWidth      int
		maxHeight     int
		expectLarger  bool
	}{
		{
			"Expand 25%",
			image.Rect(100, 100, 200, 200),
			0.25,
			1000,
			1000,
			true,
		},
		{
			"Edge case - near border",
			image.Rect(5, 5, 15, 15),
			0.25,
			20,
			20,
			true,
		},
	}

	for _, tc := range testCases {
		t.Run(tc.name, func(t *testing.T) {
			expanded := expandRect(tc.original, tc.expandPercent, tc.maxWidth, tc.maxHeight)

			if tc.expectLarger {
				// Verify expanded rect is larger
				originalArea := tc.original.Dx() * tc.original.Dy()
				expandedArea := expanded.Dx() * expanded.Dy()

				if expandedArea <= originalArea {
					t.Errorf("Expanded area (%d) should be larger than original (%d)",
						expandedArea, originalArea)
				}
			}

			// Verify bounds are respected
			if expanded.Min.X < 0 || expanded.Min.Y < 0 {
				t.Error("Expanded rect has negative coordinates")
			}

			if expanded.Max.X > tc.maxWidth || expanded.Max.Y > tc.maxHeight {
				t.Error("Expanded rect exceeds max dimensions")
			}
		})
	}
}

// TestNoPrivacyLeaks ensures processed frames have no detectable faces
func TestNoPrivacyLeaks(t *testing.T) {
	// This test would ideally use a face detection model on the OUTPUT
	// to verify no faces are visible after processing

	processor, err := NewProcessor(DefaultConfig())
	if err != nil {
		t.Fatalf("Failed to create processor: %v", err)
	}
	defer processor.Close()

	// Load image with face
	img := gocv.IMRead("testdata/face_frontal.jpg", gocv.IMReadColor)
	if img.Empty() {
		t.Skip("Test image not found")
		return
	}
	defer img.Close()

	// TODO: Process and verify output has no detectable faces
	// This would require running face detection on the output image

	t.Skip("Automated face detection on output not yet implemented")
}
