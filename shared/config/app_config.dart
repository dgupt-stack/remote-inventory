/// Application configuration
class AppConfig {
  // Backend configuration
  static const String backendHost = String.fromEnvironment(
    'BACKEND_HOST',
    defaultValue: 'localhost',
  );

  static const int backendPort = int.fromEnvironment(
    'BACKEND_PORT',
    defaultValue: 8080,
  );

  // Session configuration
  static const Duration sessionTimeout = Duration(minutes: 5);
  static const Duration heartbeatInterval = Duration(seconds: 30);

  // Camera configuration
  static const int targetFrameRate = 30;
  static const int maxVideoWidth = 1280;
  static const int maxVideoHeight = 720;

  // Privacy configuration
  static const bool enablePrivacyMode = true;
  static const int privacyProcessingDelayMs = 150;

  // UI configuration
  static const bool enableHapticFeedback = true;
  static const bool enableSoundEffects = false;

  // Debug configuration
  static const bool enableDebugLogs = true;
  static const bool enableDebugControls = true;

  static String get backendUrl => '$backendHost:$backendPort';

  static void printConfig() {
    print('🔧 App Configuration:');
    print('   Backend: $backendUrl');
    print('   Frame Rate: $targetFrameRate fps');
    print('   Max Resolution: ${maxVideoWidth}x$maxVideoHeight');
    print('   Privacy Mode: $enablePrivacyMode');
    print('   Haptic Feedback: $enableHapticFeedback');
  }
}
