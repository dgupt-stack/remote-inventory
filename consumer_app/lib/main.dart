import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'screens/session_list_screen.dart';
import 'screens/auth/phone_auth_screen.dart';
import '../shared/theme/jarvis_theme.dart';

// TODO: Replace with your Firebase configuration
// Run: flutterfire configure --project=remote-vision-6f76a
// This will generate firebase_options.dart
// For now, using placeholder initialization

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
      // options: DefaultFirebaseOptions.currentPlatform,
      );

  runApp(const ConsumerApp());
}

class ConsumerApp extends StatelessWidget {
  const ConsumerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JARVIS Consumer',
      theme: JarvisTheme.theme,
      home: const AuthWrapper(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// Auth wrapper to check authentication state
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Show loading while checking auth state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: JarvisTheme.darkBackground,
            body: Center(
              child: CircularProgressIndicator(
                color: JarvisTheme.primaryCyan,
              ),
            ),
          );
        }

        // User is signed in
        if (snapshot.hasData && snapshot.data != null) {
          return const SessionListScreen();
        }

        // User is not signed in
        return const PhoneAuthScreen();
      },
    );
  }
}
