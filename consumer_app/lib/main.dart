import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as state_provider;
import 'screens/session_list_screen.dart';
import '../shared/theme/jarvis_theme.dart';

void main() {
  runApp(const ConsumerApp());
}

class ConsumerApp extends StatelessWidget {
  const ConsumerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JARVIS Consumer',
      theme: JarvisTheme.theme,
      home:
          const SessionListScreen(), // Changed from HomeScreen to SessionListScreen
      debugShowCheckedModeBanner: false,
    );
  }
}
