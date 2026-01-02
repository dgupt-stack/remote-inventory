import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:camera/camera.dart';
import '../shared/theme/jarvis_theme.dart';
import 'session_list_screen.dart';
import 'provider_mode_screen.dart';

class ModeSelectorScreen extends StatelessWidget {
  const ModeSelectorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final displayName = user?.displayName ?? user?.phoneNumber ?? 'User';

    return Scaffold(
      backgroundColor: JarvisTheme.darkBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const SizedBox(height: 40),

              // Welcome Header
              Column(
                children: [
                  Icon(
                    Icons.auto_awesome,
                    size: 80,
                    color: JarvisTheme.primaryCyan,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Welcome to',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'J.A.R.V.I.S',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: JarvisTheme.primaryCyan,
                      shadows: [
                        Shadow(
                          color: JarvisTheme.primaryCyan.withOpacity(0.5),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    displayName,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 60),

              // Mode Selection Title
              Text(
                'Select Mode',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 32),

              // Consumer Mode Card
              _buildModeCard(
                context: context,
                title: 'Consumer Mode',
                subtitle: 'View and control provider sessions',
                icon: Icons.visibility,
                gradient: LinearGradient(
                  colors: [
                    JarvisTheme.primaryCyan.withOpacity(0.2),
                    JarvisTheme.accentBlue.withOpacity(0.2),
                  ],
                ),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SessionListScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),

              // Provider Mode Card
              _buildModeCard(
                context: context,
                title: 'Provider Mode',
                subtitle: 'Share your camera and receive commands',
                icon: Icons.videocam,
                gradient: LinearGradient(
                  colors: [
                    JarvisTheme.primaryCyan.withOpacity(0.2),
                    JarvisTheme.accentBlue.withOpacity(0.2),
                  ],
                ),
                onTap: () async {
                  // Get available cameras
                  final cameras = await availableCameras();
                  if (cameras.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('No cameras available')),
                    );
                    return;
                  }

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProviderModeScreen(
                        camera: cameras.first,
                        providerName: displayName,
                      ),
                    ),
                  );
                },
              ),

              Spacer(),

              // Sign Out Button
              TextButton.icon(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                },
                icon: Icon(Icons.logout, color: Colors.white.withOpacity(0.5)),
                label: Text(
                  'Sign Out',
                  style: TextStyle(color: Colors.white.withOpacity(0.5)),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModeCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Gradient gradient,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: JarvisTheme.primaryCyan.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: JarvisTheme.primaryCyan.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 32,
                color: JarvisTheme.primaryCyan,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: JarvisTheme.primaryCyan,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
