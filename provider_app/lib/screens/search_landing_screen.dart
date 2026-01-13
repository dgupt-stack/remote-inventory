import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/session_service.dart';
import '../services/location_service.dart';
import '../shared/theme/jarvis_theme.dart';
import '../config/app_config.dart';
import 'camera_screen.dart';
import 'provider_waiting_screen.dart';
import 'package:camera/camera.dart';

class SearchLandingScreen extends StatefulWidget {
  final List<CameraDescription> cameras;

  const SearchLandingScreen({
    super.key,
    required this.cameras,
  });

  @override
  State<SearchLandingScreen> createState() => _SearchLandingScreenState();
}

class _SearchLandingScreenState extends State<SearchLandingScreen> {
  final _searchController = TextEditingController();
  final _sessionService = SessionService();
  final _locationService = LocationService();

  bool _isProviderMode = false;
  bool _isLoading = false;
  String? _providerAddress;
  String? _sessionId;
  List<SessionInfo> _availableProviders = [];

  @override
  void initState() {
    super.initState();
    _loadProviders();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadProviders() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final providers = await _sessionService.listSessions(
        searchQuery: _searchController.text,
      );

      setState(() {
        _availableProviders = providers;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading providers: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _toggleProviderMode(bool enabled) async {
    if (enabled) {
      // Enable provider mode
      setState(() {
        _isLoading = true;
      });

      // Get GPS position
      final position = await _locationService.getCurrentPosition();
      if (position == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Unable to get location',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  'Please enable GPS and grant location permission',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
            backgroundColor: JarvisTheme.warningRed,
            duration: Duration(seconds: 5),
          ),
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // Get address for display
      final address = await _locationService.getCurrentAddress();

      // Create session with GPS coordinates
      try {
        final session = await _sessionService.createSession(
          providerId: 'provider_${DateTime.now().millisecondsSinceEpoch}',
          providerName: 'JARVIS Provider',
          location: address ?? 'Unknown location',
          latitude: position.latitude,
          longitude: position.longitude,
        );

        setState(() {
          _isProviderMode = true;
          _providerAddress = address;
          _sessionId = session.sessionId;
          _isLoading = false;
        });

        HapticFeedback.mediumImpact();

        // Navigate to WAITING screen (not camera!)
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProviderWaitingScreen(
              sessionId: session.sessionId,
              providerName: 'JARVIS Provider',
              location: address ?? 'Unknown location',
            ),
          ),
        ).then((_) {
          // When returning from waiting, disable provider mode
          setState(() {
            _isProviderMode = false;
            _providerAddress = null;
            _sessionId = null;
          });
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to start provider mode: $e'),
            backgroundColor: JarvisTheme.warningRed,
          ),
        );
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      // Disable provider mode
      if (_sessionId != null) {
        await _sessionService.endSession(_sessionId!);
      }

      setState(() {
        _isProviderMode = false;
        _providerAddress = null;
        _sessionId = null;
      });

      HapticFeedback.lightImpact();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              JarvisTheme.darkBackground,
              JarvisTheme.surfaceColor,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              _buildHeader(),

              // Search Bar
              _buildSearchBar(),

              const SizedBox(height: 24),

              // Provider List
              Expanded(
                child: _buildProviderList(),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: _buildProviderToggle(),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Settings/Debug icon
              IconButton(
                icon: Icon(
                  Icons.settings,
                  color: JarvisTheme.primaryCyan.withOpacity(0.7),
                  size: 24,
                ),
                onPressed: () {
                  _showDebugMenu();
                },
              ),

              // Center JARVIS logo
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.auto_awesome,
                      color: JarvisTheme.primaryCyan,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'J.A.R.V.I.S',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: JarvisTheme.primaryCyan,
                        letterSpacing: 4,
                        shadows: JarvisTheme.neonGlow(
                            color: JarvisTheme.primaryCyan),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Icon(
                      Icons.auto_awesome,
                      color: JarvisTheme.primaryCyan,
                      size: 24,
                    ),
                  ],
                ),
              ),

              // Spacer to balance settings icon
              SizedBox(width: 48),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Remote Inventory Viewer',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.6),
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Container(
        decoration: BoxDecoration(
          color: JarvisTheme.surfaceColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: JarvisTheme.primaryCyan.withOpacity(0.3),
            width: 1,
          ),
          boxShadow: JarvisTheme.neonGlow(
              color: JarvisTheme.primaryCyan.withOpacity(0.2)),
        ),
        child: TextField(
          controller: _searchController,
          style: TextStyle(color: Colors.white, fontSize: 16),
          decoration: InputDecoration(
            hintText: 'Search for providers...',
            hintStyle: TextStyle(
              color: Colors.white.withOpacity(0.4),
              fontSize: 16,
            ),
            prefixIcon: Icon(
              Icons.search,
              color: JarvisTheme.primaryCyan,
            ),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon:
                        Icon(Icons.clear, color: Colors.white.withOpacity(0.6)),
                    onPressed: () {
                      _searchController.clear();
                      _loadProviders();
                    },
                  )
                : null,
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
          onChanged: (value) {
            setState(() {});
            _loadProviders();
          },
        ),
      ),
    );
  }

  Widget _buildProviderList() {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(
          color: JarvisTheme.primaryCyan,
        ),
      );
    }

    if (_availableProviders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Colors.white.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'No providers available',
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try searching for a different location',
              style: TextStyle(
                color: Colors.white.withOpacity(0.4),
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 24),
      itemCount: _availableProviders.length,
      itemBuilder: (context, index) {
        final provider = _availableProviders[index];
        return _buildProviderCard(provider);
      },
    );
  }

  Widget _buildProviderCard(SessionInfo provider) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: JarvisTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: JarvisTheme.primaryCyan.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          // Location Icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: JarvisTheme.primaryCyan.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.location_on,
              color: JarvisTheme.primaryCyan,
            ),
          ),

          const SizedBox(width: 16),

          // Provider Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  provider.providerName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  provider.location ?? 'Unknown location',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // Connect Button
          ElevatedButton(
            onPressed: () {
              _connectToProvider(provider);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: JarvisTheme.primaryCyan,
              foregroundColor: JarvisTheme.darkBackground,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text('Connect'),
          ),
        ],
      ),
    );
  }

  Widget _buildProviderToggle() {
    return FloatingActionButton.extended(
      onPressed: _isLoading
          ? null
          : () {
              _toggleProviderMode(!_isProviderMode);
            },
      backgroundColor:
          _isProviderMode ? JarvisTheme.successGreen : JarvisTheme.primaryCyan,
      icon: Icon(
        _isProviderMode ? Icons.videocam : Icons.videocam_off,
        color: JarvisTheme.darkBackground,
      ),
      label: Text(
        _isProviderMode ? 'Provider ON' : 'Become Provider',
        style: TextStyle(
          color: JarvisTheme.darkBackground,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Future<void> _connectToProvider(SessionInfo provider) async {
    try {
      // Generate consumer ID
      final consumerId = 'consumer_${DateTime.now().millisecondsSinceEpoch}';

      // Send connection request
      print('📞 Sending connection request to ${provider.providerName}');
      final requestId = await _sessionService.requestConnection(
        sessionId: provider.sessionId,
        consumerId: consumerId,
        consumerName: 'JARVIS Consumer',
      );

      if (!mounted) return;

      // Show waiting dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          backgroundColor: JarvisTheme.surfaceColor,
          title: Row(
            children: const [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              SizedBox(width: 12),
              Text('Waiting for approval...'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Provider: ${provider.providerName}'),
              Text('Location: ${provider.location ?? "Unknown"}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        ),
      );

      // Watch for approval
      _sessionService.watchApprovalStatus(requestId).listen(
        (status) {
          if (!mounted) return;

          Navigator.pop(context); // Close waiting dialog

          if (status.approved) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('✅ Connected to ${provider.providerName}'),
                backgroundColor: JarvisTheme.successGreen,
              ),
            );
            // TODO: Navigate to video viewer
          } else if (status.denied) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('❌ ${status.message}'),
                backgroundColor: JarvisTheme.warningRed,
              ),
            );
          }
        },
        onError: (error) {
          if (!mounted) return;
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Connection error: $error'),
              backgroundColor: JarvisTheme.warningRed,
            ),
          );
        },
      );
    } catch (e) {
      print('❌ Error connecting: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to connect: $e'),
            backgroundColor: JarvisTheme.warningRed,
          ),
        );
      }
    }
  }

  void _showDebugMenu() {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: JarvisTheme.surfaceColor,
          title: Row(
            children: [
              Icon(Icons.settings, color: JarvisTheme.primaryCyan, size: 20),
              SizedBox(width: 8),
              Text(
                'Developer Settings',
                style: TextStyle(color: JarvisTheme.primaryCyan),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // App Info Section
                _buildSettingsSection(
                  'App Information',
                  [
                    _buildSettingsRow('Version', AppConfig.appVersion),
                    _buildSettingsRow('Name', AppConfig.appName),
                  ],
                ),

                Divider(color: JarvisTheme.primaryCyan.withOpacity(0.3)),

                // Backend Environment Toggle
                _buildSettingsSection(
                  'Backend Environment',
                  [
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppConfig.environment ==
                                        BackendEnvironment.local
                                    ? '🏠 Local'
                                    : '☁️ Cloud Run',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                AppConfig.backendUrl,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.6),
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                          Switch(
                            value: AppConfig.environment ==
                                BackendEnvironment.cloudRun,
                            onChanged: (value) {
                              setState(() {
                                AppConfig.toggleEnvironment();
                              });
                            },
                            activeColor: JarvisTheme.primaryCyan,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                Divider(color: JarvisTheme.primaryCyan.withOpacity(0.3)),

                // Backend Details
                _buildSettingsSection(
                  'Backend Configuration',
                  [
                    _buildSettingsRow('Host', AppConfig.backendHost),
                    _buildSettingsRow('Port', '${AppConfig.backendPort}'),
                    _buildSettingsRow(
                        'TLS', AppConfig.useTLS ? 'Enabled' : 'Disabled'),
                  ],
                ),

                Divider(color: JarvisTheme.primaryCyan.withOpacity(0.3)),

                // API Status
                _buildSettingsSection(
                  'API Implementation',
                  [
                    _buildStatusRow('CreateSession', true),
                    _buildStatusRow('ListSessions', false, note: 'Coming soon'),
                    _buildStatusRow('RequestConnection', true),
                    _buildStatusRow('WatchRequests', true),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                // Reload providers list with new backend
                _loadProviders();
              },
              child: Text(
                'Apply & Close',
                style: TextStyle(color: JarvisTheme.primaryCyan),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: JarvisTheme.primaryCyan,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        ...children,
      ],
    );
  }

  Widget _buildSettingsRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 12,
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 12,
              ),
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusRow(String api, bool implemented, {String? note}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            implemented ? Icons.check_circle : Icons.pending,
            color: implemented ? JarvisTheme.successGreen : Colors.orange,
            size: 14,
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              api,
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 12,
              ),
            ),
          ),
          if (note != null)
            Text(
              note,
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 10,
                fontStyle: FontStyle.italic,
              ),
            ),
        ],
      ),
    );
  }
}
