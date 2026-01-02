import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'screens/mode_selector_screen.dart';
import 'screens/auth/phone_auth_screen.dart';
import '../shared/theme/jarvis_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const JarvisApp());
}

class JarvisApp extends StatelessWidget {
  const JarvisApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JARVIS Remote Inventory',
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

        // User is signed in → Mode Selector
        if (snapshot.hasData && snapshot.data != null) {
          return const ModeSelectorScreen();
        }

        // User is not signed in → Phone Auth
        return const PhoneAuthScreen();
      },
    );
  }
}
