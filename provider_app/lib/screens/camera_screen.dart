import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:async';
import '../widgets/guidance_overlay.dart';
import '../shared/theme/jarvis_theme.dart';

class CameraScreen extends StatefulWidget {
  final CameraDescription camera;
  final String providerName;

  const CameraScreen({
    super.key,
    required this.camera,
    required this.providerName,
  });

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _cameraController;
  late Future<void> _initializeControllerFuture;
  bool _isStreaming = false;
  String _sessionId = '';
  String _connectionStatus = 'Initializing...';

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
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  Future<void> _createSession() async {
    // TODO: Connect to gRPC backend and create session
    setState(() {
      //_sessionId = 'SESSION-${DateTime.now().millisecondsSinceEpoch}';
      _sessionId = 'DEMO-SESSION';
      _connectionStatus = 'Waiting for Consumer...';
    });

    // Simulate connection (in prod, this comes from gRPC)
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _connectionStatus = 'Connected';
      _isStreaming = true;
    });

    // Start streaming frames
    _startFrameStreaming();
  }

  void _startFrameStreaming() {
    // In production, this would capture frames and send via gRPC
    // For now, we'll simulate the streaming
    Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (!_isStreaming || !mounted) {
        timer.cancel();
        return;
      }

      // Capture and send frame
      // TODO: Implement actual frame capture and gRPC streaming
    });
  }

  void _handleCommand(String command) {
    setState(() {
      switch (command) {
        case 'left':
          _currentDirection = NavigationDirection.left;
          break;
        case 'right':
          _currentDirection = NavigationDirection.right;
          break;
        case 'up':
          _currentDirection = NavigationDirection.up;
          break;
        case 'down':
          _currentDirection = NavigationDirection.down;
          break;
        case 'stop':
          _stopRequested = true;
          _currentDirection = NavigationDirection.none;
          break;
        default:
          _currentDirection = NavigationDirection.none;
      }
    });

    // Auto-clear direction after animation
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _currentDirection = NavigationDirection.none;
          if (_stopRequested) _stopRequested = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
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

                // Top status bar
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.7),
                          Colors.transparent,
                        ],
                      ),
                    ),
                    child: SafeArea(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _isStreaming
                                      ? JarvisTheme.successGreen
                                      : JarvisTheme.warningRed,
                                  boxShadow: JarvisTheme.neonGlow(
                                    color: _isStreaming
                                        ? JarvisTheme.successGreen
                                        : JarvisTheme.warningRed,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _connectionStatus,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Spacer(),
                              IconButton(
                                icon: const Icon(Icons.close),
                                color: Colors.white,
                                onPressed: () => Navigator.pop(context),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Session: $_sessionId',
                            style: TextStyle(
                              color: JarvisTheme.primaryCyan,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: JarvisTheme.warningRed.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: JarvisTheme.warningRed,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.lock,
                                  size: 12,
                                  color: JarvisTheme.primaryCyan,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Privacy Protected',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Debug controls (simulate consumer commands)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(0.7),
                          Colors.transparent,
                        ],
                      ),
                    ),
                    child: SafeArea(
                      child: Column(
                        children: [
                          Text(
                            'Debug Controls (Simulating Consumer)',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildDebugButton(
                                  '←', () => _handleCommand('left')),
                              _buildDebugButton(
                                  '↑', () => _handleCommand('up')),
                              _buildDebugButton(
                                  '↓', () => _handleCommand('down')),
                              _buildDebugButton(
                                  '→', () => _handleCommand('right')),
                              _buildDebugButton(
                                  '⏹', () => _handleCommand('stop'),
                                  color: JarvisTheme.warningRed),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: JarvisTheme.primaryCyan,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Initializing camera...',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildDebugButton(String label, VoidCallback onPressed,
      {Color? color}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? JarvisTheme.primaryCyan,
        shape: CircleBorder(),
        padding: EdgeInsets.all(16),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
