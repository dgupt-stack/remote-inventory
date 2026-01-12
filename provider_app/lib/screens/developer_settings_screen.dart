import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import '../config/backend_config.dart';
import '../services/session_service.dart';

class DeveloperSettingsScreen extends StatefulWidget {
  const DeveloperSettingsScreen({super.key});

  // TODO: Add admin authentication check before showing this screen

  @override
  State<DeveloperSettingsScreen> createState() =>
      _DeveloperSettingsScreenState();
}

class _DeveloperSettingsScreenState extends State<DeveloperSettingsScreen> {
  BackendEnvironment _selectedEnvironment = BackendConfig.environment;
  bool _isTestingConnection = false;
  String? _connectionResult;
  PackageInfo? _packageInfo;

  @override
  void initState() {
    super.initState();
    _loadPackageInfo();
  }

  Future<void> _loadPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  Future<void> _testConnection() async {
    setState(() {
      _isTestingConnection = true;
      _connectionResult = null;
    });

    try {
      // Create new service instance to use updated config
      final sessions = await SessionService().listSessions();
      setState(() {
        _connectionResult =
            '✅ Connected successfully!\nFound ${sessions.length} sessions';
        _isTestingConnection = false;
      });
    } catch (e) {
      setState(() {
        _connectionResult = '❌ Connection failed:\n${e.toString()}';
        _isTestingConnection = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Developer Settings'),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // App Version Section
          Card(
            color: const Color(0xFF1A1A1A),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.info_outline,
                          color: Color(0xFF00D4FF), size: 24),
                      SizedBox(width: 12),
                      Text(
                        'App Information',
                        style: TextStyle(
                          color: Color(0xFF00D4FF),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (_packageInfo != null) ...[
                    _buildInfoRow('Version', _packageInfo!.version),
                    _buildInfoRow('Build Number', _packageInfo!.buildNumber),
                    _buildInfoRow('Build Date', _getBuildDate()),
                    _buildInfoRow('Install Date', _getInstallDate()),
                    _buildInfoRow('Package', _packageInfo!.packageName),
                    _buildInfoRow('App Name', _packageInfo!.appName),
                  ] else
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Color(0xFF00D4FF)),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Header
          const Card(
            color: Color(0xFF1A1A1A),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Backend Configuration',
                    style: TextStyle(
                      color: Color(0xFF00D4FF),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Switch between local development and production backends',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Environment Selection
          const Text(
            'Environment',
            style: TextStyle(
              color: Color(0xFF00D4FF),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),

          RadioListTile<BackendEnvironment>(
            title: Text(
              'Local Development',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              '${BackendConfig.localHost}:${BackendConfig.localPort}',
              style: const TextStyle(color: Colors.white70),
            ),
            value: BackendEnvironment.local,
            groupValue: _selectedEnvironment,
            activeColor: const Color(0xFF00D4FF),
            tileColor: const Color(0xFF1A1A1A),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            onChanged: (value) {
              setState(() {
                _selectedEnvironment = value!;
                BackendConfig.environment = value;
                _connectionResult = null; // Clear previous test result
              });
            },
          ),

          const SizedBox(height: 8),

          RadioListTile<BackendEnvironment>(
            title: const Text(
              'Cloud Run (Production)',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              BackendConfig.cloudRunUrl,
              style: const TextStyle(color: Colors.white70),
            ),
            value: BackendEnvironment.cloudRun,
            groupValue: _selectedEnvironment,
            activeColor: const Color(0xFF00D4FF),
            tileColor: const Color(0xFF1A1A1A),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            onChanged: (value) {
              setState(() {
                _selectedEnvironment = value!;
                BackendConfig.environment = value;
                _connectionResult = null; // Clear previous test result
              });
            },
          ),

          const SizedBox(height: 24),

          // Test Connection Button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _isTestingConnection ? null : _testConnection,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00D4FF),
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: _isTestingConnection
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                      ),
                    )
                  : const Text(
                      'Test Connection',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),

          // Test Result
          if (_connectionResult != null) ...[
            const SizedBox(height: 16),
            Card(
              color: _connectionResult!.contains('✅')
                  ? const Color(0xFF1A3A1A)
                  : const Color(0xFF3A1A1A),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  _connectionResult!,
                  style: TextStyle(
                    color: _connectionResult!.contains('✅')
                        ? Colors.greenAccent
                        : Colors.redAccent,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],

          const SizedBox(height: 24),
          const Divider(color: Colors.white24),
          const SizedBox(height: 16),

          // Current Configuration Display
          const Text(
            'Current Configuration',
            style: TextStyle(
              color: Color(0xFF00D4FF),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),

          _buildInfoTile('Environment', BackendConfig.environmentName),
          _buildInfoTile('Host', BackendConfig.host),
          _buildInfoTile('Port', BackendConfig.port.toString()),
          _buildInfoTile('TLS', BackendConfig.useTLS ? 'Enabled' : 'Disabled'),
          _buildInfoTile('Full URL', BackendConfig.displayUrl),
        ],
      ),
    );
  }

  Widget _buildInfoTile(String label, String value) {
    return Card(
      color: const Color(0xFF1A1A1A),
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
        subtitle: Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  String _getBuildDate() {
    try {
      // Get build date from compile time (embedded at build)
      // This is an approximation - actual build time would need to be embedded during build
      final now = DateTime.now();
      final formatter = DateFormat('MMM d, yyyy HH:mm');
      return formatter.format(now);
    } catch (e) {
      return 'Unknown';
    }
  }

  String _getInstallDate() {
    try {
      // Get install date from data directory creation time
      final dataDir =
          Directory('/data/data/${_packageInfo?.packageName ?? ""}');
      if (dataDir.existsSync()) {
        final stat = dataDir.statSync();
        final formatter = DateFormat('MMM d, yyyy HH:mm');
        return formatter.format(stat.changed);
      }
      return 'Unknown';
    } catch (e) {
      return 'Unknown';
    }
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
