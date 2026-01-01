import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import '../widgets/guidance_overlay.dart';
import '../shared/theme/jarvis_components.dart';

class ProviderModeScreen extends StatefulWidget {
  final CameraDescription camera;
  final String providerName;

  const ProviderModeScreen({
    super.key,
    required this.camera,
    required this.providerName,
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

  @override
  void initState() {
    super.initState();
    _cameraController = CameraController(
      widget.camera,
      ResolutionPreset.high,
      enableAudio: false,
    );
    _initializeControllerFuture = _cameraController.initialize();
    _createSession();

    // Update time every second
    _updateTime();
    _timeTimer =
        Timer.periodic(const Duration(seconds: 1), (_) => _updateTime());
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
    _cameraController.dispose();
    super.dispose();
  }

  Future<void> _createSession() async {
    setState(() {
      _sessionId = 'DEMO-SESSION';
    });

    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _isStreaming = true;
    });
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
                            // Camera preview
                            SizedBox.expand(
                              child: CameraPreview(_cameraController),
                            ),

                            // Guidance overlay
                            GuidanceOverlay(
                              direction: _currentDirection,
                              laserActive: _laserActive,
                              laserPosition: _laserPosition,
                              stopRequested: _stopRequested,
                            ),

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
}
