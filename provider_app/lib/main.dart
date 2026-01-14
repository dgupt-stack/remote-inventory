import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_auth/firebase_auth.dart'; // Disabled for now
import 'package:camera/camera.dart';
import 'firebase_options.dart';
import 'screens/search_landing_screen.dart';
import 'services/version_service.dart';
import 'shared/theme/jarvis_theme.dart';
// import 'screens/auth/phone_auth_screen.dart'; // Disabled for now

late List<CameraDescription> cameras;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize cameras
  cameras = await availableCameras();

  // Track install date
  await VersionService.getInstallDate();

  runApp(const ProviderApp());
}

class ProviderApp extends StatefulWidget {
  const ProviderApp({super.key});

  @override
  State<ProviderApp> createState() => _ProviderAppState();
}

class _ProviderAppState extends State<ProviderApp> {
  @override
  void initState() {
    super.initState();
    _checkForUpdates();
  }

  Future<void> _checkForUpdates() async {
    // Wait a bit for app to fully load
    await Future.delayed(const Duration(seconds: 2));

    final hasUpdate = await VersionService.isUpdateAvailable();
    if (hasUpdate && mounted) {
      _showUpdateDialog();
    }
  }

  void _showUpdateDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: JarvisTheme.surfaceColor,
        title: const Text('Update Available',
            style: TextStyle(color: JarvisTheme.primaryCyan)),
        content: const Text(
          'A new version is available. Update to get the latest features and improvements.',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Later', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // User can go to Settings > About > Check for Updates
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: JarvisTheme.primaryCyan),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JARVIS Provider',
      theme: ThemeData.dark(),
      // Start with search/consumer screen
      home: SearchLandingScreen(cameras: cameras),
      debugShowCheckedModeBanner: false,
    );
  }
}

// Auth wrapper disabled for now - focus on features first
/*
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Show loading while checking auth state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Color(0xFF0A192F),
            body: Center(
              child: CircularProgressIndicator(
                color: Color(0xFF00D9FF),
              ),
            ),
          );
        }

        // User is signed in
        if (snapshot.hasData && snapshot.data != null) {
          return CameraScreen(
            camera: cameras.first,
            providerName: snapshot.data!.displayName ??
                snapshot.data!.phoneNumber ??
                'Provider',
          );
        }

        // User is not signed in
        return const PhoneAuthScreen();
      },
    );
  }
}
*/
