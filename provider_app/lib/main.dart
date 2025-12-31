import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as state_provider;
import 'package:camera/camera.dart';
import 'screens/camera_screen.dart';
import '../shared/theme/jarvis_theme.dart';

List<CameraDescription> cameras = [];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Get available cameras
  try {
    cameras = await availableCameras();
  } catch (e) {
    print('Error initializing cameras: $e');
  }

  runApp(const ProviderApp());
}

class ProviderApp extends StatelessWidget {
  const ProviderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JARVIS Provider',
      theme: JarvisTheme.theme,
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _glowController;
  final _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _glowController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _startSession() {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter your name')));
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CameraScreen(
          camera: cameras.first,
          providerName: _nameController.text,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              JarvisTheme.darkBackground,
              JarvisTheme.surfaceColor,
              JarvisTheme.darkBackground,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // JARVIS Logo with glow animation
                  AnimatedBuilder(
                    animation: _glowController,
                    builder: (context, child) {
                      return Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: JarvisTheme.neonGlow(
                            color: JarvisTheme.primaryCyan.withOpacity(
                              0.3 + (_glowController.value * 0.4),
                            ),
                          ),
                        ),
                        child: Icon(
                          Icons.visibility,
                          size: 80,
                          color: JarvisTheme.primaryCyan,
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 32),

                  // Title
                  Text(
                    'JARVIS PROVIDER',
                    style: Theme.of(context).textTheme.displayLarge,
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'Remote Inventory View',
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 48),

                  // Name input
                  Container(
                    decoration: JarvisTheme.glassEffect(),
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        TextField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: 'Provider Name',
                            hintText: 'Enter your name',
                            prefixIcon: Icon(Icons.person),
                          ),
                          textInputAction: TextInputAction.done,
                          onSubmitted: (_) => _startSession(),
                        ),

                        const SizedBox(height: 24),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _startSession,
                            icon: const Icon(Icons.videocam),
                            label: const Text('START SESSION'),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Privacy notice
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: JarvisTheme.warningRed.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: JarvisTheme.warningRed.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.security, color: JarvisTheme.primaryCyan),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'All faces and body parts will be blurred for privacy',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
