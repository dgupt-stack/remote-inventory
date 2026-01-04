import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/session_service.dart';
import '../services/location_service.dart';
import '../shared/theme/jarvis_theme.dart';
import 'camera_screen.dart';
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

      // Get location
      final address = await _locationService.getCurrentAddress();

      if (address == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Unable to get location. Please enable GPS.'),
            backgroundColor: JarvisTheme.warningRed,
          ),
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // Create session
      try {
        final session = await _sessionService.createSession(
          providerId: 'provider_${DateTime.now().millisecondsSinceEpoch}',
          providerName: 'Test Provider',
          location: address,
        );

        setState(() {
          _isProviderMode = true;
          _providerAddress = address;
          _sessionId = session.sessionId;
          _isLoading = false;
        });

        HapticFeedback.mediumImpact();

        // Navigate to camera screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CameraScreen(
              camera: widget.cameras.first,
              providerName: 'Test Provider',
            ),
          ),
        ).then((_) {
          // When returning from camera, disable provider mode
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
                  shadows: JarvisTheme.neonGlow(color: JarvisTheme.primaryCyan),
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
    // TODO: Implement connection logic
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Connecting to ${provider.providerName}...'),
        backgroundColor: JarvisTheme.primaryCyan,
      ),
    );
  }
}
