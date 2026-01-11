/// Demo mode configuration
/// Set to true to run app without backend
class DemoConfig {
  static const bool isDemoMode = true; // Toggle for offline testing

  static const String demoMessage = '''
🎮 DEMO MODE ENABLED

This app is running in offline demo mode.
- No backend server required
- Mock data is being used
- Provider: Camera will work locally
- Consumer: Will show mock sessions
- WebRTC: Local camera only (no P2P)

Perfect for testing UI flows!
''';
}
