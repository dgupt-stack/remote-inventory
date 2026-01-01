import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../shared/theme/jarvis_components.dart';

class ConnectionRequestDialog extends StatelessWidget {
  final String requestId;
  final String consumerName;
  final VoidCallback onApprove;
  final VoidCallback onDeny;

  const ConnectionRequestDialog({
    super.key,
    required this.requestId,
    required this.consumerName,
    required this.onApprove,
    required this.onDeny,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: JarvisColors.background,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: JarvisColors.primary,
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
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: JarvisColors.primary.withOpacity(0.2),
              ),
              child: Icon(
                Icons.person_add,
                size: 40,
                color: JarvisColors.primary,
              ),
            ),

            const SizedBox(height: 20),

            // Title
            Text(
              'Connection Request',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: JarvisColors.primary,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 16),

            // Consumer name
            Text(
              consumerName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 8),

            Text(
              'wants to connect to your session',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 32),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      HapticFeedback.mediumImpact();
                      Navigator.pop(context);
                      onDeny();
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: JarvisColors.borderCyan),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Deny',
                      style: TextStyle(
                        color: JarvisColors.borderCyan,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      HapticFeedback.mediumImpact();
                      Navigator.pop(context);
                      onApprove();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: JarvisColors.primary,
                      foregroundColor: JarvisColors.background,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Approve',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
