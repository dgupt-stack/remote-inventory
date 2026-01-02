import 'package:flutter/material.dart';
import 'shared/theme/jarvis_theme.dart';
import 'screens/mode_selector_screen.dart';

void main() {
  runApp(const JarvisApp());
}

class JarvisApp extends StatelessWidget {
  const JarvisApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JARVIS Remote Inventory',
      theme: JarvisTheme.theme,
      home: const ModeSelectorScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
