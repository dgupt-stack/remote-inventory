import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import '../widgets/touch_controller.dart';
// import '../services/voice_service.dart'; // Temporarily disabled
import '../shared/theme/jarvis_theme.dart';

class ConsumerModeScreen extends StatefulWidget {
  final String sessionId;
  final String consumerName;

  const ConsumerModeScreen({
    super.key,
    required this.sessionId,
    required this.consumerName,
  });

  @override
  State<ConsumerModeScreen> createState() => _ConsumerModeScreenState();
}

class _ConsumerModeScreenState extends State<ConsumerModeScreen> {
  bool _isConnected = false;
  bool _voiceActive = false;
  double _currentZoom = 1.0;
  List<String> _commandHistory = [];
  final _textController = TextEditingController();
  // late VoiceService _voiceService; // Temporarily disabled

  @override
  void initState() {
    super.initState();
    // _voiceService = VoiceService(); // Temporarily disabled
    _connectToSession();
  }

  @override
  void dispose() {
    _textController.dispose();
    // _voiceService.dispose(); // Temporarily disabled
    super.dispose();
  }

  Future<void> _connectToSession() async {
    // TODO: Connect to gRPC backend
    setState(() {
      _isConnected = false;
    });

    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isConnected = true;
    });

    HapticFeedback.mediumImpact();
  }

  void _sendCommand(String command, {Map<String, dynamic>? params}) {
    setState(() {
      _commandHistory.insert(0, command);
      if (_commandHistory.length > 5) {
        _commandHistory.removeLast();
      }
    });

    // TODO: Send command via gRPC
    print('Sending command: $command with params: $params');
    HapticFeedback.lightImpact();
  }

  void _handleNavigationCommand(String direction) {
    _sendCommand('navigate', params: {'direction': direction});
  }

  void _handleZoomCommand(double delta) {
    setState(() {
      _currentZoom = (_currentZoom + delta).clamp(0.5, 5.0);
    });
    _sendCommand('zoom', params: {'level': _currentZoom});
  }

  void _handleLaserCommand(bool active, Offset? position) {
    _sendCommand('laser', params: {
      'active': active,
      'x': position?.dx ?? 0,
      'y': position?.dy ?? 0,
    });
  }

  void _handleStopCommand() {
    _sendCommand('stop', params: {'emergency': true});
    HapticFeedback.heavyImpact();
  }

  Future<void> _toggleVoice() async {
    setState(() {
      _voiceActive = !_voiceActive;
    });

    if (_voiceActive) {
      // Voice service temporarily disabled
      // final result = await _voiceService.startListening();
      // if (result != null) {
      //   _sendCommand('voice', params: {'text': result});
      //   setState(() {
      //     _voiceActive = false;
      //   });
      // }
    } else {
      // _voiceService.stopListening();
    }
  }

  void _sendTextCommand() {
    if (_textController.text.isNotEmpty) {
      _sendCommand('text', params: {'text': _textController.text});
      _textController.clear();
      FocusScope.of(context).unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              JarvisTheme.darkBackground,
              JarvisTheme.surfaceColor,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              _buildHeader(),

              // Video feed
              Expanded(
                flex: 3,
                child: TouchController(
                  onNavigate: _handleNavigationCommand,
                  onZoom: _handleZoomCommand,
                  onLaserActive: _handleLaserCommand,
                  onStop: _handleStopCommand,
                  child: _buildVideoFeed(),
                ),
              ),

              // Controls panel
              Expanded(
                flex: 2,
                child: _buildControlPanel(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: JarvisTheme.surfaceColor.withOpacity(0.8),
        boxShadow: [
          BoxShadow(
            color: JarvisTheme.primaryCyan.withOpacity(0.1),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _isConnected
                  ? JarvisTheme.successGreen
                  : JarvisTheme.warningRed,
              boxShadow: JarvisTheme.neonGlow(
                color: _isConnected
                    ? JarvisTheme.successGreen
                    : JarvisTheme.warningRed,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.sessionId,
                  style: TextStyle(
                    color: JarvisTheme.primaryCyan,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  _isConnected ? 'Connected' : 'Connecting...',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            color: Colors.white,
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoFeed() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: JarvisTheme.glassEffect(),
      child: Stack(
        children: [
          // Placeholder for video feed
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.videocam,
                  size: 64,
                  color: JarvisTheme.primaryCyan.withOpacity(0.5),
                ),
                const SizedBox(height: 16),
                Text(
                  'Privacy-Protected Video Feed',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: JarvisTheme.successGreen.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: JarvisTheme.successGreen,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.lock,
                        size: 14,
                        color: JarvisTheme.successGreen,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'All body parts blurred',
                        style: TextStyle(
                          color: JarvisTheme.successGreen,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Zoom indicator
          Positioned(
            top: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: JarvisTheme.darkBackground.withOpacity(0.7),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: JarvisTheme.primaryCyan.withOpacity(0.3),
                ),
              ),
              child: Text(
                '${_currentZoom.toStringAsFixed(1)}x',
                style: TextStyle(
                  color: JarvisTheme.primaryCyan,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // Touch gesture hints
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: JarvisTheme.darkBackground.withOpacity(0.7),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Swipe: Navigate • Pinch: Zoom • Long Press: Laser • Double Tap: Stop',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 11,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlPanel() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: JarvisTheme.surfaceColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: JarvisTheme.primaryCyan.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Command history
          Container(
            height: 40,
            child: _commandHistory.isEmpty
                ? Center(
                    child: Text(
                      'No commands sent yet',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.3),
                        fontSize: 12,
                      ),
                    ),
                  )
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _commandHistory.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: JarvisTheme.primaryCyan.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: JarvisTheme.primaryCyan.withOpacity(0.3),
                          ),
                        ),
                        child: Text(
                          _commandHistory[index],
                          style: TextStyle(
                            color: JarvisTheme.primaryCyan,
                            fontSize: 12,
                          ),
                        ),
                      );
                    },
                  ),
          ),

          const SizedBox(height: 16),

          // Control buttons
          Row(
            children: [
              Expanded(
                child: _buildControlButton(
                  icon: _voiceActive ? Icons.mic : Icons.mic_none,
                  label: 'Voice',
                  onPressed: _toggleVoice,
                  active: _voiceActive,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: TextField(
                  controller: _textController,
                  decoration: InputDecoration(
                    hintText: 'Type command...',
                    suffixIcon: IconButton(
                      icon: Icon(Icons.send),
                      onPressed: _sendTextCommand,
                    ),
                  ),
                  onSubmitted: (_) => _sendTextCommand(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    bool active = false,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor:
            active ? JarvisTheme.primaryCyan : JarvisTheme.surfaceColor,
        foregroundColor:
            active ? JarvisTheme.darkBackground : JarvisTheme.primaryCyan,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: JarvisTheme.primaryCyan.withOpacity(0.5),
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 24),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
