import 'package:flutter/material.dart';
import '../shared/theme/jarvis_theme.dart';
import '../config/app_config.dart';
import 'about_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E27), // JarvisTheme backgroundColor
      appBar: AppBar(
        backgroundColor: JarvisTheme.surfaceColor,
        title: const Text('Settings',
            style: TextStyle(color: JarvisTheme.primaryCyan)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: JarvisTheme.primaryCyan),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Developer Settings Section
          _buildSectionHeader('Developer Settings'),
          _buildSettingsTile(
            context,
            icon: Icons.code,
            title: 'Backend Configuration',
            subtitle: AppConfig.isLocalBackend ? 'Local (localhost)' : 'Cloud',
            onTap: () {
              // Toggle backend
              AppConfig.isLocalBackend = !AppConfig.isLocalBackend;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      'Backend: ${AppConfig.isLocalBackend ? "Local" : "Cloud"}'),
                  backgroundColor: JarvisTheme.successGreen,
                ),
              );
            },
          ),
          _buildSettingsTile(
            context,
            icon: Icons.network_check,
            title: 'Backend URL',
            subtitle: AppConfig.getGrpcHost(),
            onTap: null,
          ),

          const SizedBox(height: 20),

          // About Section
          _buildSectionHeader('About'),
          _buildSettingsTile(
            context,
            icon: Icons.info_outline,
            title: 'App Info',
            subtitle: 'Version, build date, and more',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 10),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: JarvisTheme.primaryCyan,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _buildSettingsTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: JarvisTheme.surfaceColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: JarvisTheme.primaryCyan.withOpacity(0.2)),
      ),
      child: ListTile(
        leading: Icon(icon, color: JarvisTheme.primaryCyan),
        title: Text(
          title,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
        trailing: onTap != null
            ? const Icon(Icons.chevron_right, color: Colors.grey)
            : null,
        onTap: onTap,
      ),
    );
  }
}
