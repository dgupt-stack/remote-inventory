import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import '../services/webrtc_consumer_service.dart';
import '../services/grpc_service.dart';
import '../utils/device_manager.dart';

/// Consumer viewing screen - displays Provider's live video stream
class ConsumerViewingScreen extends StatefulWidget {
  final String sessionId;
  final String providerName;

  const ConsumerViewingScreen({
    Key? key,
    required this.sessionId,
    required this.providerName,
  }) : super(key: key);

  @override
  State<ConsumerViewingScreen> createState() => _ConsumerViewingScreenState();
}

class _ConsumerViewingScreenState extends State<ConsumerViewingScreen> {
  final WebRTCConsumerService _webrtcService = WebRTCConsumerService();
  final RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();

  bool _isConnecting = true;
  bool _isConnected = false;
  String _status = 'Connecting to provider...';
  String? _error;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      // Initialize video renderer
      await _remoteRenderer.initialize();

      // Add listener for remote stream
      _webrtcService.addRemoteStreamListener((stream) {
        setState(() {
          _remoteRenderer.srcObject = stream;
          _isConnected = true;
          _isConnecting = false;
          _status = 'Connected! Viewing live stream...';
        });
      });

      // Get device ID
      final deviceId = await DeviceManager.getDeviceId();

      // Initialize gRPC
      final grpcService = GrpcService();
      await grpcService.initialize();

      // Start watching for Provider's offer
      setState(() => _status = 'Waiting for provider stream...');

      // Watch in background
      _webrtcService
          .watchForOffer(
        sessionId: widget.sessionId,
        deviceId: deviceId,
        stub: grpcService.stub,
      )
          .catchError((e) {
        if (mounted) {
          setState(() {
            _error = e.toString();
            _isConnecting = false;
          });
        }
      });

      // Timeout after 30 seconds
      Future.delayed(const Duration(seconds: 30), () {
        if (mounted && !_isConnected) {
          setState(() {
            _status = 'Provider not streaming yet';
            _isConnecting = false;
          });
        }
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isConnecting = false;
      });
      print('❌ Initialization error: $e');
    }
  }

  @override
  void dispose() {
    _remoteRenderer.dispose();
    _webrtcService.stopViewing();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E27),
      body: SafeArea(
        child: _error != null
            ? _buildError()
            : _isConnecting
                ? _buildConnecting()
                : _isConnected
                    ? _buildViewing()
                    : _buildNotStreaming(),
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 80, color: Color(0xFFFF6B6B)),
            const SizedBox(height: 24),
            const Text(
              'Connection Error',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _error ?? 'Unknown error',
              style: const TextStyle(color: Colors.white70, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00D4FF),
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              child:
                  const Text('Go Back', style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConnecting() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(Color(0xFF00D4FF)),
          ),
          const SizedBox(height: 24),
          Text(
            _status,
            style: const TextStyle(color: Colors.white70, fontSize: 18),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'Provider: ${widget.providerName}',
            style: const TextStyle(color: Colors.white54, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildNotStreaming() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.videocam_off, size: 80, color: Colors.white54),
          const SizedBox(height: 24),
          Text(
            _status,
            style: const TextStyle(color: Colors.white70, fontSize: 18),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00D4FF),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
            child: const Text('Go Back', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }

  Widget _buildViewing() {
    return Stack(
      children: [
        // Remote video (full screen)
        Positioned.fill(
          child: RTCVideoView(
            _remoteRenderer,
            objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
          ),
        ),

        // Top bar with provider info
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.all(20),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF0000),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.circle, color: Colors.white, size: 8),
                          SizedBox(width: 6),
                          Text(
                            'LIVE',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        widget.providerName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        // Bottom controls
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black.withOpacity(0.8),
                  Colors.transparent,
                ],
              ),
            ),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () async {
                  await _webrtcService.stopViewing();
                  if (mounted) Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF6B6B),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.close, size: 28),
                    SizedBox(width: 12),
                    Text(
                      'Stop Viewing',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
