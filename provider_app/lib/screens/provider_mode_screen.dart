import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'dart:ui' as ui;
import '../widgets/guidance_overlay.dart';
import '../shared/theme/jarvis_components.dart';
import '../services/session_service.dart';
import '../services/privacy_service.dart';

class ProviderModeScreen extends StatefulWidget {
  final CameraDescription camera;
  final String providerName;
  final String sessionId; // NEW: Session was created in registration

  const ProviderModeScreen({
    super.key,
    required this.camera,
    required this.providerName,
    required this.sessionId, // NEW
  });

  @override
  State<ProviderModeScreen> createState() => _ProviderModeScreenState();
}

class _ProviderModeScreenState extends State<ProviderModeScreen> {
  late CameraController _cameraController;
  late Future<void> _initializeControllerFuture;
  late Timer _timeTimer;

  bool _isStreaming = false;
  String _sessionId = '';
  String _currentTime = '';
  double _zoom = 1.0;

  // Guidance state
  NavigationDirection _currentDirection = NavigationDirection.none;
  bool _laserActive = false;
  Offset _laserPosition = Offset.zero;
  bool _stopRequested = false;

  // Privacy state
  late PrivacyService _privacyService;
  ui.Image? _processedFrame;
  int _facesDetected = 0;
  int _processingTimeMs = 0;
  bool _privacyEnabled = true; // Always enabled for privacy
  int _frameCount = 0; // For frame skipping optimization

  @override
  void initState() {
    super.initState();
    _privacyService = PrivacyService();
    _initializeCamera();
    _createSession();

    // Update time every second
    _updateTime();
    _timeTimer =
        Timer.periodic(const Duration(seconds: 1), (_) => _updateTime());
  }

  Future<void> _initializeCamera() async {
    _cameraController = CameraController(
      widget.camera,
      ResolutionPreset
          .medium, // Medium for better performance with privacy processing
      enableAudio: false,
    );

    await _cameraController.initialize();

    if (mounted) {
      // Start privacy processing
      _startPrivacyProcessing();
    }
  }

  void _startPrivacyProcessing() {
    _cameraController.startImageStream((CameraImage image) async {
      _frameCount++;

      // Skip frames for performance (process every 3rd frame)
      if (_frameCount % 3 != 0 || !_privacyEnabled) {
        return;
      }

      final result = await _privacyService.processFrame(image);

      if (mounted) {
        setState(() {
          _processedFrame = result.blurredImage;
          _facesDetected = result.facesDetected;
          _processingTimeMs = result.processingTimeMs;
        });
      }
    });
  }

  void _updateTime() {
    if (mounted) {
      setState(() {
        _currentTime =
            DateFormat('h:mm:ss a').format(DateTime.now()).toUpperCase();
      });
    }
  }

  @override
  void dispose() {
    _timeTimer.cancel();

    // Stop image stream before disposing camera
    try {
      _cameraController.stopImageStream();
    } catch (e) {
      // Image stream might not be running
    }

    _cameraController.dispose();
    _privacyService.dispose();

    // End backend session if created
    if (_sessionId != null && _sessionId != 'DEMO-SESSION') {
      SessionService().endSession(_sessionId!).then((success) {
        print(success ? '✅ Session ended' : '⚠️  Failed to end session');
      });
    }

    super.dispose();
  }

  Future<void> _createSession() async {
    try {
      // Call backend to create session
      final response = await SessionService().createSession(
        providerName: widget.providerName,
        providerId: 'provider-${DateTime.now().millisecondsSinceEpoch}',
        location: 'Unknown', // TODO: Get actual location
      );

      setState(() {
        _sessionId = response.sessionId;
      });

      print('✅ Provider session created: $_sessionId');

      // Wait a moment then show as streaming
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        _isStreaming = true;
      });
    } catch (e) {
      print('❌ Failed to create backend session: $e');
      // Fall back to demo mode
      setState(() {
        _sessionId = 'DEMO-SESSION';
      });

      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        _isStreaming = true;
      });
    }
  }

  void _handleZoomChanged(double value) {
    setState(() {
      _zoom = value;
    });
    _cameraController.setZoomLevel(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: JarvisColors.background,
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Column(
              children: [
                // Header
                _buildHeader(),

                // Main camera view with border
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: JarvisColors.borderCyan,
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: JarvisColors.primaryGlow,
                            blurRadius: 20,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Stack(
                          children: [
                            // Camera preview with privacy processing
                            SizedBox.expand(
                              child: _buildCameraPreview(),
                            ),

                            // Guidance overlay
                            GuidanceOverlay(
                              direction: _currentDirection,
                              laserActive: _laserActive,
                              laserPosition: _laserPosition,
                              stopRequested: _stopRequested,
                            ),

                            // Privacy indicator (top-right)
                            if (_privacyEnabled && _facesDetected > 0)
                              _buildPrivacyIndicator(),

                            // Status badges overlay
                            _buildStatusOverlay(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // Bottom navigation
                _buildBottomNav(),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: JarvisColors.background,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            // Badge icon (communication)
            Stack(
              children: [
                Icon(
                  Icons.forum_outlined,
                  color: JarvisColors.primary,
                  size: 28,
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: JarvisColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '4',
                      style: TextStyle(
                        color: JarvisColors.background,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const Spacer(),

            // J.A.R.V.I.S title
            Row(
              children: [
                Icon(
                  Icons.auto_awesome,
                  color: JarvisColors.primary,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  'J.A.R.V.I.S',
                  style: JarvisTextStyles.header.copyWith(fontSize: 20),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.auto_awesome,
                  color: JarvisColors.primary,
                  size: 18,
                ),
              ],
            ),

            const Spacer(),

            // Action icons
            JarvisIconButton(
              icon: Icons.open_in_full,
              onPressed: () {},
            ),
            const SizedBox(width: 8),
            JarvisIconButton(
              icon: Icons.settings,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusOverlay() {
    return Positioned.fill(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row: SYS:ONLINE and TIME
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GlassBadge(
                  text: 'SYS:ONLINE',
                  leading: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: JarvisColors.success,
                      boxShadow: [
                        BoxShadow(
                          color: JarvisColors.success,
                          blurRadius: 8,
                        ),
                      ],
                    ),
                  ),
                ),
                GlassBadge(
                  text: _currentTime,
                ),
              ],
            ),

            const Spacer(),

            // Bottom row: LIVE and ZOOM
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                GlassBadge(
                  text: 'LIVE',
                  textColor: JarvisColors.success,
                  leading: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: JarvisColors.success,
                      boxShadow: [
                        BoxShadow(
                          color: JarvisColors.success,
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),
                ),
                ZoomIndicator(
                  zoom: _zoom,
                  onZoomChanged: _handleZoomChanged,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      color: JarvisColors.background,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Connection badge
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: JarvisColors.primary.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.wifi,
                    color: JarvisColors.primary,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '4',
                    style: TextStyle(
                      color: JarvisColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Navigation icons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNavIcon(Icons.visibility_off),
                _buildNavIcon(Icons.search),
                _buildNavIcon(Icons.videocam, isCenter: true),
                _buildNavIcon(Icons.zoom_in),
                _buildNavIcon(Icons.info_outline),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavIcon(IconData icon, {bool isCenter = false}) {
    return IconButton(
      icon: Icon(
        icon,
        color: JarvisColors.primary,
        size: isCenter ? 32 : 24,
      ),
      onPressed: () {},
      splashRadius: 24,
    );
  }

  Widget _buildCameraPreview() {
    if (_processedFrame != null && _privacyEnabled) {
      // Show privacy-processed frame with blurred faces
      return RawImage(
        image: _processedFrame,
        fit: BoxFit.cover,
      );
    } else {
      // Fallback to camera preview (when no faces detected)
      return CameraPreview(_cameraController);
    }
  }

  Widget _buildPrivacyIndicator() {
    return Positioned(
      top: 100,
      right: 16,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.redAccent.withOpacity(0.9),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.visibility_off, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text(
              '$_facesDetected face${_facesDetected > 1 ? 's' : ''} blurred',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
