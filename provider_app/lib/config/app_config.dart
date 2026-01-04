enum BackendEnvironment {
  local,
  cloudRun,
}

class AppConfig {
  static BackendEnvironment _environment = BackendEnvironment.cloudRun;

  // Backend URLs
  static const String localHost = 'localhost';
  static const int localPort = 8080;
  static const String cloudRunHost =
      'remote-inventory-backend-mlwjajxybq-uc.a.run.app';
  static const int cloudRunPort = 443;

  // App info
  static const String appVersion = '1.0.0+1';
  static const String appName = 'JARVIS Remote Inventory';

  // Getters
  static BackendEnvironment get environment => _environment;

  static String get backendHost {
    switch (_environment) {
      case BackendEnvironment.local:
        return localHost;
      case BackendEnvironment.cloudRun:
        return cloudRunHost;
    }
  }

  static int get backendPort {
    switch (_environment) {
      case BackendEnvironment.local:
        return localPort;
      case BackendEnvironment.cloudRun:
        return cloudRunPort;
    }
  }

  static bool get useTLS {
    return _environment == BackendEnvironment.cloudRun;
  }

  static String get backendUrl {
    return '$backendHost:$backendPort';
  }

  // Setters
  static void setEnvironment(BackendEnvironment env) {
    _environment = env;
  }

  static void toggleEnvironment() {
    _environment = _environment == BackendEnvironment.local
        ? BackendEnvironment.cloudRun
        : BackendEnvironment.local;
  }
}
