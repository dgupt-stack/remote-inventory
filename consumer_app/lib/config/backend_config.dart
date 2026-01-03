enum BackendEnvironment {
  local,
  cloudRun,
}

class BackendConfig {
  // Local development backend
  static const String localHost = '192.168.86.89';
  static const int localPort = 8080;

  // Cloud Run backend (will be updated after deployment)
  static const String cloudRunUrl =
      'jarvis-backend-uc.a.run.app'; // Placeholder
  static const int cloudRunPort = 443; // HTTPS

  // Current environment (defaults to local)
  static BackendEnvironment _currentEnvironment = BackendEnvironment.local;

  // Getters
  static BackendEnvironment get environment => _currentEnvironment;

  // Setters
  static set environment(BackendEnvironment env) {
    _currentEnvironment = env;
    // TODO: Persist to SharedPreferences
  }

  // Helper methods
  static String get host {
    switch (_currentEnvironment) {
      case BackendEnvironment.local:
        return localHost;
      case BackendEnvironment.cloudRun:
        return cloudRunUrl;
    }
  }

  static int get port {
    switch (_currentEnvironment) {
      case BackendEnvironment.local:
        return localPort;
      case BackendEnvironment.cloudRun:
        return cloudRunPort;
    }
  }

  static bool get useTLS => _currentEnvironment == BackendEnvironment.cloudRun;

  static String get displayUrl => '$host:$port';

  static String get environmentName {
    switch (_currentEnvironment) {
      case BackendEnvironment.local:
        return 'Local Development';
      case BackendEnvironment.cloudRun:
        return 'Cloud Run (Production)';
    }
  }
}
