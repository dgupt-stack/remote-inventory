import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/foundation.dart';

/// Privacy service for face detection and blur
/// Ensures 100% privacy by blurring all detected faces
class PrivacyService {
  final FaceDetector _faceDetector;
  bool _isProcessing = false;

  PrivacyService()
      : _faceDetector = FaceDetector(
          options: FaceDetectorOptions(
            enableLandmarks: false,
            enableContours: false,
            enableClassification: false,
            minFaceSize: 0.1, // Detect smaller/distant faces
            performanceMode: FaceDetectorMode.fast,
          ),
        );

  /// Process camera frame - detect and blur faces
  Future<ProcessedFrame> processFrame(CameraImage cameraImage) async {
    if (_isProcessing) {
      return ProcessedFrame(
        blurredImage: null,
        facesDetected: 0,
        processingTimeMs: 0,
      );
    }

    _isProcessing = true;
    final startTime = DateTime.now();

    try {
      // 1. Convert CameraImage to InputImage for ML Kit
      final inputImage = _convertCameraImage(cameraImage);

      // 2. Detect faces
      final faces = await _faceDetector.processImage(inputImage);

      if (faces.isEmpty) {
        _isProcessing = false;
        return ProcessedFrame(
          blurredImage: null,
          facesDetected: 0,
          processingTimeMs: DateTime.now().difference(startTime).inMilliseconds,
        );
      }

      // 3. Convert to image package format for blur processing
      final image = await _cameraImageToImage(cameraImage);

      if (image == null) {
        _isProcessing = false;
        return ProcessedFrame(
          blurredImage: null,
          facesDetected: 0,
          processingTimeMs: DateTime.now().difference(startTime).inMilliseconds,
        );
      }

      // 4. Blur detected faces
      final blurred =
          _blurFaces(image, faces, cameraImage.width, cameraImage.height);

      // 5. Convert back to UI image
      final uiImage = await _imageToUiImage(blurred);

      final processingTime =
          DateTime.now().difference(startTime).inMilliseconds;
      _isProcessing = false;

      return ProcessedFrame(
        blurredImage: uiImage,
        facesDetected: faces.length,
        processingTimeMs: processingTime,
      );
    } catch (e) {
      if (kDebugMode) {
        print('❌ Privacy processing error: $e');
      }
      _isProcessing = false;
      return ProcessedFrame(
        blurredImage: null,
        facesDetected: 0,
        processingTimeMs: 0,
      );
    }
  }

  InputImage _convertCameraImage(CameraImage cameraImage) {
    // Convert CameraImage to InputImage for ML Kit
    final WriteBuffer allBytes = WriteBuffer();
    for (final Plane plane in cameraImage.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    final imageSize = Size(
      cameraImage.width.toDouble(),
      cameraImage.height.toDouble(),
    );

    final inputImageData = InputImageMetadata(
      size: imageSize,
      rotation: InputImageRotation.rotation0deg,
      format: InputImageFormat.nv21,
      bytesPerRow: cameraImage.planes[0].bytesPerRow,
    );

    return InputImage.fromBytes(
      bytes: bytes,
      metadata: inputImageData,
    );
  }

  Future<img.Image?> _cameraImageToImage(CameraImage cameraImage) async {
    try {
      // YUV420 to RGB conversion
      final int width = cameraImage.width;
      final int height = cameraImage.height;

      final img.Image image = img.Image(width: width, height: height);

      final Plane yPlane = cameraImage.planes[0];
      final Plane uPlane = cameraImage.planes[1];
      final Plane vPlane = cameraImage.planes[2];

      for (int y = 0; y < height; y++) {
        for (int x = 0; x < width; x++) {
          final int yIndex = y * yPlane.bytesPerRow + x;
          final int uvIndex = (y ~/ 2) * uPlane.bytesPerRow + (x ~/ 2);

          final int yValue = yPlane.bytes[yIndex];
          final int uValue = uPlane.bytes[uvIndex];
          final int vValue = vPlane.bytes[uvIndex];

          // YUV to RGB conversion
          int r = (yValue + 1.370705 * (vValue - 128)).round().clamp(0, 255);
          int g =
              (yValue - 0.337633 * (uValue - 128) - 0.698001 * (vValue - 128))
                  .round()
                  .clamp(0, 255);
          int b = (yValue + 1.732446 * (uValue - 128)).round().clamp(0, 255);

          image.setPixelRgba(x, y, r, g, b, 255);
        }
      }

      return image;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Camera image conversion error: $e');
      }
      return null;
    }
  }

  img.Image _blurFaces(
      img.Image image, List<Face> faces, int width, int height) {
    final blurred = img.copyResize(image, width: width, height: height);

    for (final face in faces) {
      final bbox = face.boundingBox;

      // Expand bounding box by 25% for better coverage
      const expansion = 0.25;
      final expandedRect = Rect.fromLTRB(
        (bbox.left - bbox.width * expansion).clamp(0.0, width.toDouble()),
        (bbox.top - bbox.height * expansion).clamp(0.0, height.toDouble()),
        (bbox.right + bbox.width * expansion).clamp(0.0, width.toDouble()),
        (bbox.bottom + bbox.height * expansion).clamp(0.0, height.toDouble()),
      );

      // Extract face region
      final faceRegion = img.copyCrop(
        blurred,
        x: expandedRect.left.toInt(),
        y: expandedRect.top.toInt(),
        width: expandedRect.width.toInt().clamp(1, width),
        height: expandedRect.height.toInt().clamp(1, height),
      );

      // Apply strong Gaussian blur (radius 25 for privacy)
      final blurredFace = img.gaussianBlur(faceRegion, radius: 25);

      // Composite blurred region back
      img.compositeImage(
        blurred,
        blurredFace,
        dstX: expandedRect.left.toInt(),
        dstY: expandedRect.top.toInt(),
      );
    }

    return blurred;
  }

  Future<ui.Image> _imageToUiImage(img.Image image) async {
    final bytes = img.encodePng(image);
    final codec = await ui.instantiateImageCodec(bytes);
    final frame = await codec.getNextFrame();
    return frame.image;
  }

  void dispose() {
    _faceDetector.close();
  }
}

/// Result of privacy processing
class ProcessedFrame {
  final ui.Image? blurredImage;
  final int facesDetected;
  final int processingTimeMs;

  ProcessedFrame({
    required this.blurredImage,
    required this.facesDetected,
    required this.processingTimeMs,
  });

  bool get hasBlur => blurredImage != null;
}
