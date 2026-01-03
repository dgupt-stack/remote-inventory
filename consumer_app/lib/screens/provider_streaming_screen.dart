import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import '../services/webrtc_provider_service.dart';
import '../services/grpc_service.dart';

/// Provider streaming screen - shows camera preview and connection status
class ProviderStreamingScreen extends StatefulWidget {
  final String sessionId;
  final String deviceName;

  const ProviderStreamingScreen({
    Key? key,
    required this.sessionId,
    required this.deviceName,
  }) : super(key: key);

  @override
  State<ProviderStreamingScreen> createState() =>
      _ProviderStreamingScreenState();
}

class _ProviderStreamingScreenState extends State<ProviderStreamingScreen> {
  final WebRTCProviderService _webrtcService = WebRTCProviderService();
  final RTCVideoRenderer _localRenderer = RTCVideoRenderer();

  bool _isInitializing = true;
  bool _isConnected = false;
  String _status = 'Starting camera...';
  String? _error;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      // Initialize video renderer
      await _localRenderer.initialize();

      // Start camera
      setState(() => _status = 'Accessing camera...');
      await _webrtcService.startCamera();

      // Set local stream to renderer
      _localRenderer.srcObject = _webrtcService.localStream;

      // Create WebRTC offer
      setState(() => _status = 'Creating connection...');
      final grpcService = GrpcService();
      await grpcService.initialize();

      await _webrtcService.createOffer(
        sessionId: widget.sessionId,
        deviceId: widget.deviceName, // Using device name as ID for now
        stub: grpcService.stub,
      );

      // Watch for answer from consumer
      setState(() {
        _status = 'Waiting for consumer to connect...';
        _isInitializing = false;
      });

      _webrtcService.watchForAnswer(consumerDeviceId: 'consumer');

      // Simulate connection for demo (in real flow, this would be triggered by answer)
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _isConnected = true;
            _status = 'Connected! Streaming video...';
          });
        }
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isInitializing = false;
      });
      print('❌ Initialization error: $e');
    }
  }

  @override
  void dispose() {
    _localRenderer.dispose();
    _webrtcService.stopStreaming();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E27),
      body: SafeArea(
        child: _error != null
            ? _buildError()
            : _isInitializing
                ? _buildLoading()
                : _buildStreaming(),
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
              'Camera Error',
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

  Widget _buildLoading() {
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
          ),
        ],
      ),
    );
  }

  Widget _buildStreaming() {
    return Stack(
      children: [
        // Camera preview (full screen)
        Positioned.fill(
          child: RTCVideoView(
            _localRenderer,
            mirror: false, // Don't mirror back camera
            objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
          ),
        ),

        // Top bar with status
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
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: _isConnected
                            ? const Color(0xFF4CAF50)
                            : const Color(0xFFFF9800),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _status,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  widget.deviceName,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_isConnected)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4CAF50).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFF4CAF50)),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.videocam,
                            color: Color(0xFF4CAF50), size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Live Streaming',
                          style: TextStyle(
                            color: Color(0xFF4CAF50),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () async {
                      await _webrtcService.stopStreaming();
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
                        Icon(Icons.stop_circle, size: 28),
                        SizedBox(width: 12),
                        Text(
                          'Stop Streaming',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
