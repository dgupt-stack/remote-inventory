import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/version_service.dart';
import '../shared/theme/jarvis_theme.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  String _version = 'Loading...';
  String _buildDate = 'Loading...';
  String _installDate = 'Loading...';
  bool _isChecking = false;

  @override
  void initState() {
    super.initState();
    _loadVersionInfo();
  }

  Future<void> _loadVersionInfo() async {
    final version = await VersionService.getVersionString();
    final buildDate = VersionService.getFormattedBuildDate();
    final installDate = await VersionService.getFormattedInstallDate();

    setState(() {
      _version = version;
      _buildDate = buildDate;
      _installDate = installDate;
    });
  }

  Future<void> _checkForUpdates() async {
    setState(() => _isChecking = true);

    try {
      final hasUpdate = await VersionService.isUpdateAvailable();

      if (!mounted) return;

      if (hasUpdate) {
        _showUpdateDialog();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('You\'re on the latest version!'),
            backgroundColor: JarvisTheme.successGreen,
          ),
        );
      }
    } finally {
      setState(() => _isChecking = false);
    }
  }

  void _showUpdateDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: JarvisTheme.surfaceColor,
        title: const Text('Update Available',
            style: TextStyle(color: JarvisTheme.primaryCyan)),
        content: const Text(
          'A new version of the app is available. Please download the latest version from Firebase App Distribution.',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Later', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Open Firebase download link
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: JarvisTheme.primaryCyan,
            ),
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _copyVersionToClipboard() {
    Clipboard.setData(ClipboardData(
        text:
            'Version: $_version\nBuilt: $_buildDate\nInstalled: $_installDate'));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Version info copied to clipboard'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E27), // JarvisTheme backgroundColor
      appBar: AppBar(
        backgroundColor: JarvisTheme.surfaceColor,
        title: const Text('About',
            style: TextStyle(color: JarvisTheme.primaryCyan)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: JarvisTheme.primaryCyan),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),

            // App Icon/Logo
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: JarvisTheme.surfaceColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: JarvisTheme.primaryCyan.withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const Icon(Icons.inventory_2,
                  size: 60, color: JarvisTheme.primaryCyan),
            ),

            const SizedBox(height: 20),
            const Text(
              'Remote Inventory',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),

            const SizedBox(height: 40),

            // Version Info Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: JarvisTheme.surfaceColor,
                borderRadius: BorderRadius.circular(15),
                border:
                    Border.all(color: JarvisTheme.primaryCyan.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.info_outline,
                          color: JarvisTheme.primaryCyan, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Version Info',
                        style: TextStyle(
                          color: JarvisTheme.primaryCyan,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.copy,
                            color: Colors.grey, size: 18),
                        onPressed: _copyVersionToClipboard,
                        tooltip: 'Copy version info',
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  _buildInfoRow('Version', _version),
                  const SizedBox(height: 10),
                  _buildInfoRow('Built', _buildDate),
                  const SizedBox(height: 10),
                  _buildInfoRow('Installed', _installDate),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Check for Updates Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isChecking ? null : _checkForUpdates,
                icon: _isChecking
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      )
                    : const Icon(Icons.refresh),
                label: Text(_isChecking ? 'Checking...' : 'Check for Updates'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: JarvisTheme.primaryCyan,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Firebase Info
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: JarvisTheme.surfaceColor.withOpacity(0.5),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.withOpacity(0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Firebase App ID',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '1:344355586136:android:3b55fa2f1e2fa9316e8a2d',
                    style: TextStyle(
                        color: Colors.white70,
                        fontSize: 11,
                        fontFamily: 'monospace'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '$label:',
          style: const TextStyle(color: Colors.grey, fontSize: 14),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
