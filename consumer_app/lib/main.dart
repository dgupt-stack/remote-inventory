import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'shared/theme/jarvis_theme.dart';
import 'screens/provider_mode_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  runApp(JarvisApp(cameras: cameras));
}

class JarvisApp extends StatelessWidget {
  final List<CameraDescription> cameras;

  const JarvisApp({super.key, required this.cameras});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JARVIS Remote Inventory',
      theme: JarvisTheme.theme,
      home: cameras.isNotEmpty
          ? ProviderModeScreen(
              camera: cameras.first,
              providerName: 'Demo Provider',
              sessionId: 'DEMO-SESSION',
            )
          : const Scaffold(
              body: Center(child: Text('No camera available')),
            ),
      debugShowCheckedModeBanner: false,
    );
  }
}
