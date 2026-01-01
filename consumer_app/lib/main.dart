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

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _glowController;
  final _sessionIdController = TextEditingController();
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
    _sessionIdController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _joinSession() {
    if (_sessionIdController.text.isEmpty || _nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ControllerScreen(
          sessionId: _sessionIdController.text,
          consumerName: _nameController.text,
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
              child: SingleChildScrollView(
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
                            Icons.gamepad,
                            size: 80,
                            color: JarvisTheme.primaryCyan,
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 32),

                    // Title
                    Text(
                      'JARVIS CONSUMER',
                      style: Theme.of(context).textTheme.displayLarge,
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 8),

                    Text(
                      'Remote Control Interface',
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 48),

                    // Join session form
                    Container(
                      decoration: JarvisTheme.glassEffect(),
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          TextField(
                            controller: _nameController,
                            decoration: const InputDecoration(
                              labelText: 'Your Name',
                              hintText: 'Enter your name',
                              prefixIcon: Icon(Icons.person),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: _sessionIdController,
                            decoration: const InputDecoration(
                              labelText: 'Session ID',
                              hintText: 'Enter session ID from provider',
                              prefixIcon: Icon(Icons.key),
                            ),
                            textInputAction: TextInputAction.done,
                            onSubmitted: (_) => _joinSession(),
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: _joinSession,
                              icon: const Icon(Icons.link),
                              label: const Text('JOIN SESSION'),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Control methods info
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: JarvisTheme.accentBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: JarvisTheme.accentBlue.withOpacity(0.3),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.touch_app,
                                color: JarvisTheme.primaryCyan,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Control Methods',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _buildControlInfo('Swipe', 'Navigate directions'),
                          _buildControlInfo('Pinch', 'Zoom in/out'),
                          _buildControlInfo(
                              'Long Press', 'Activate laser pointer'),
                          _buildControlInfo('Double Tap', 'Emergency stop'),
                          _buildControlInfo('Voice', 'Speak commands'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildControlInfo(String gesture, String action) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: JarvisTheme.primaryCyan,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '$gesture: ',
            style: TextStyle(
              color: JarvisTheme.primaryCyan,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          Text(
            action,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
