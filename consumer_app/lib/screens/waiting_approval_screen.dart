import 'package:flutter/material.dart';
import '../services/session_service.dart';
import '../shared/theme/jarvis_theme.dart';
import 'controller_screen.dart';

class WaitingApprovalScreen extends StatefulWidget {
  final String requestId;
  final String providerName;
  final String sessionId;

  const WaitingApprovalScreen({
    super.key,
    required this.requestId,
    required this.providerName,
    required this.sessionId,
  });

  @override
  State<WaitingApprovalScreen> createState() => _WaitingApprovalScreenState();
}

class _WaitingApprovalScreenState extends State<WaitingApprovalScreen>
    with SingleTickerProviderStateMixin {
  final SessionService _sessionService = SessionService();
  late AnimationController _animationController;
  bool _cancelled = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _watchApprovalStatus();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _sessionService.dispose();
    super.dispose();
  }

  Future<void> _watchApprovalStatus() async {
    try {
      await for (final status
          in _sessionService.watchApprovalStatus(widget.requestId)) {
        if (_cancelled) break;

        if (status.status == ApprovalStatusEnum.approved) {
          // Navigate to controller screen
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ControllerScreen(
                  sessionId: status.sessionId,
                  consumerName: 'Mobile Consumer',
                ),
              ),
            );
          }
          break;
        } else if (status.status == ApprovalStatusEnum.denied) {
          // Show denied message
          if (mounted) {
            _showDeniedDialog(status.message);
          }
          break;
        }
      }
    } catch (e) {
      if (mounted && !_cancelled) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Connection error: $e')),
        );
        Navigator.pop(context);
      }
    }
  }

  void _showDeniedDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: JarvisTheme.surfaceColor,
        title: Text(
          'Request Denied',
          style: TextStyle(color: JarvisTheme.warningRed),
        ),
        content: Text(
          message.isNotEmpty ? message : 'The provider denied your request',
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back to session list
            },
            child: Text(
              'OK',
              style: TextStyle(color: JarvisTheme.primaryCyan),
            ),
          ),
        ],
      ),
    );
  }

  void _cancelRequest() {
    setState(() {
      _cancelled = true;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: JarvisTheme.darkBackground,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    color: JarvisTheme.primaryCyan,
                    onPressed: _cancelRequest,
                  ),
                  Expanded(
                    child: Text(
                      'Requesting Connection',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: JarvisTheme.primaryCyan,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 48), // Balance for back button
                ],
              ),
            ),

            // Main content
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Animated loading indicator
                    RotationTransition(
                      turns: _animationController,
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: JarvisTheme.primaryCyan,
                            width: 3,
                          ),
                        ),
                        child: Icon(
                          Icons.sync,
                          color: JarvisTheme.primaryCyan,
                          size: 50,
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    Text(
                      'Waiting for approval from',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      widget.providerName,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: JarvisTheme.primaryCyan,
                        shadows: [
                          Shadow(
                            color: JarvisTheme.primaryCyan.withOpacity(0.5),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: JarvisTheme.surfaceColor.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: JarvisTheme.primaryCyan.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: JarvisTheme.primaryCyan,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'They can approve or deny your request',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Cancel button
            Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: _cancelRequest,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: JarvisTheme.warningRed),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Cancel Request',
                    style: TextStyle(
                      color: JarvisTheme.warningRed,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
