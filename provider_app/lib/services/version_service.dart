import 'package:shared_preferences/shared_preferences.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../config/build_config.dart';

class VersionService {
  static const String _installDateKey = 'install_date';
  static const String _lastVersionKey = 'last_version';

  /// Get current app version info
  static Future<PackageInfo> getPackageInfo() async {
    return await PackageInfo.fromPlatform();
  }

  /// Get or set install date (first time app is opened)
  static Future<DateTime> getInstallDate() async {
    final prefs = await SharedPreferences.getInstance();
    final installDateStr = prefs.getString(_installDateKey);

    if (installDateStr == null) {
      // First install
      final now = DateTime.now();
      await prefs.setString(_installDateKey, now.toIso8601String());
      return now;
    }

    return DateTime.parse(installDateStr);
  }

  /// Get build date from compile-time constant
  static DateTime getBuildDate() {
    return DateTime.parse(buildTimestamp);
  }

  /// Check if update is available
  /// Returns true if current installed version is older than build version
  static Future<bool> isUpdateAvailable() async {
    final prefs = await SharedPreferences.getInstance();
    final packageInfo = await getPackageInfo();

    final currentVersion = packageInfo.version;
    final currentBuild = int.parse(packageInfo.buildNumber);

    // Compare with build config (represents latest build)
    if (buildVersion != currentVersion) {
      return true;
    }

    if (buildNumber > currentBuild) {
      return true;
    }

    return false;
  }

  /// Save current version as "last seen version"
  static Future<void> saveCurrentVersion() async {
    final prefs = await SharedPreferences.getInstance();
    final packageInfo = await getPackageInfo();
    await prefs.setString(
        _lastVersionKey, '${packageInfo.version}+${packageInfo.buildNumber}');
  }

  /// Get version display string (e.g., "1.3.0 (5)")
  static Future<String> getVersionString() async {
    final packageInfo = await getPackageInfo();
    return '${packageInfo.version} (build ${packageInfo.buildNumber})';
  }

  /// Get formatted build date
  static String getFormattedBuildDate() {
    final date = getBuildDate();
    return '${date.month}/${date.day}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  /// Get formatted install date
  static Future<String> getFormattedInstallDate() async {
    final date = await getInstallDate();
    return '${date.month}/${date.day}/${date.year}';
  }
}
