import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../services/session_service.dart';
import 'provider_mode_screen.dart';
import 'dart:async';

class ProviderWaitingScreen extends StatefulWidget {
  final String sessionId;
  final String providerName;
  final String location;

  const ProviderWaitingScreen({
    super.key,
    required this.sessionId,
    required this.providerName,
    required this.location,
  });

  @override
  State<ProviderWaitingScreen> createState() => _ProviderWaitingScreenState();
}

class _ProviderWaitingScreenState extends State<ProviderWaitingScreen> {
  int _requestCount = 0;
  StreamSubscription<ConnectionRequestNotification>? _requestSubscription;

  @override
  void initState() {
    super.initState();
    _listenForRequests();
  }

  @override
  void dispose() {
    _requestSubscription?.cancel();
    // End session when leaving
    SessionService().endSession(widget.sessionId);
    super.dispose();
  }

  void _listenForRequests() {
    print(
        '👂 Listening for connection requests on session: ${widget.sessionId}');

    _requestSubscription =
        SessionService().watchConnectionRequests(widget.sessionId).listen(
      (notification) {
        print('🔔 Request received: ${notification.consumerName}');
        setState(() {
          _requestCount++;
        });

        // Show approval dialog
        _showRequestDialog(
          notification.consumerName,
          notification.requestId,
        );
      },
      onError: (error) {
        print('❌ Error listening for requests: $error');
      },
    );
  }

  Future<void> _showRequestDialog(String consumerName, String requestId) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Text(
          'Connection Request',
          style: TextStyle(color: Color(0xFF00D4FF)),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$consumerName wants to connect',
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 8),
            const Text(
              'Camera will activate after approval',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(
              'Reject',
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00D4FF),
              foregroundColor: Colors.black,
            ),
            child: const Text('Accept'),
          ),
        ],
      ),
    );

    if (result == true) {
      await _handleApproval(requestId);
    } else if (result == false) {
      await _handleRejection(requestId);
    }
  }

  Future<void> _handleApproval(String requestId) async {
    // TODO: Call ApproveConnection RPC
    print('✅ Approved connection: $requestId');

    // Get camera and navigate to provider mode
    final cameras = await availableCameras();
    if (cameras.isNotEmpty && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ProviderModeScreen(
            camera: cameras.first,
            providerName: widget.providerName,
            sessionId: widget.sessionId,
          ),
        ),
      );
    }
  }

  Future<void> _handleRejection(String requestId) async {
    // TODO: Call DenyConnection RPC
    print('❌ Rejected connection: $requestId');

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Connection request rejected'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Provider Online'),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Status Indicator
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.greenAccent, width: 3),
                ),
                child: const Icon(
                  Icons.wifi_tethering,
                  color: Colors.greenAccent,
                  size: 50,
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                'ONLINE',
                style: TextStyle(
                  color: Colors.greenAccent,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),

              const SizedBox(height: 16),

              Text(
                widget.providerName,
                style: const TextStyle(
                  color: Color(0xFF00D4FF),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 8),

              Text(
                widget.location,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 48),

              const Text(
                'Waiting for connection requests...',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 16),

              Text(
                'Requests received: $_requestCount',
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 14,
                ),
              ),

              const Spacer(),

              // Go Offline Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.redAccent),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Go Offline',
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
