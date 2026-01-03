import 'package:flutter/material.dart';
import '../services/grpc_service.dart';
import '../proto/inventory_service.pbgrpc.dart';
import 'consumer_viewing_screen.dart';
import '../shared/theme/jarvis_theme.dart';
import 'waiting_approval_screen.dart';
import 'controller_screen.dart';

class SessionListScreen extends StatefulWidget {
  const SessionListScreen({super.key});

  @override
  State<SessionListScreen> createState() => _SessionListScreenState();
}

class _SessionListScreenState extends State<SessionListScreen> {
  final SessionService _sessionService = SessionService();
  List<SessionInfo> _sessions = [];
  bool _loading = false;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _loadSessions();
  }

  Future<void> _loadSessions() async {
    setState(() {
      _loading = true;
      _error = '';
    });

    try {
      final sessions = await _sessionService.listSessions();
      setState(() {
        _sessions = sessions;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load sessions: $e';
        _loading = false;
      });
    }
  }

  Future<void> _requestConnection(SessionInfo session) async {
    try {
      final requestId = await _sessionService.requestConnection(
        sessionId: session.sessionId,
        consumerId: 'consumer-${DateTime.now().millisecondsSinceEpoch}',
        consumerName: 'Mobile Consumer',
      );

      // Navigate to waiting screen
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WaitingApprovalScreen(
              requestId: requestId,
              providerName: session.providerName,
              sessionId: session.sessionId,
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to request connection: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: JarvisTheme.darkBackground,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: _buildSessionList(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _loadSessions,
        backgroundColor: JarvisTheme.primaryCyan,
        foregroundColor: JarvisTheme.darkBackground,
        child: const Icon(Icons.refresh),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
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
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: JarvisTheme.primaryCyan,
                  shadows: [
                    Shadow(
                      color: JarvisTheme.primaryCyan.withOpacity(0.5),
                      blurRadius: 10,
                    ),
                  ],
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
            'Available Providers',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionList() {
    if (_loading) {
      return Center(
        child: CircularProgressIndicator(
          color: JarvisTheme.primaryCyan,
        ),
      );
    }

    if (_error.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              color: JarvisTheme.warningRed,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              _error,
              style: TextStyle(color: JarvisTheme.warningRed),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadSessions,
              style: ElevatedButton.styleFrom(
                backgroundColor: JarvisTheme.primaryCyan,
                foregroundColor: JarvisTheme.darkBackground,
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_sessions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              color: Colors.white.withOpacity(0.3),
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              'No active providers',
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Pull down to refresh',
              style: TextStyle(
                color: Colors.white.withOpacity(0.3),
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadSessions,
      color: JarvisTheme.primaryCyan,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _sessions.length,
        itemBuilder: (context, index) {
          return _buildSessionCard(_sessions[index]);
        },
      ),
    );
  }

  Widget _buildSessionCard(SessionInfo session) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: JarvisTheme.surfaceColor.withOpacity(0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: JarvisTheme.primaryCyan.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: JarvisTheme.primaryCyan.withOpacity(0.1),
            blurRadius: 10,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Navigate directly to viewing screen
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ConsumerViewingScreen(
                  sessionId: session.sessionId,
                  providerName: session.providerName,
                ),
              ),
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: JarvisTheme.primaryCyan.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.videocam,
                    color: JarvisTheme.primaryCyan,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        session.providerName,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        session.providerLocation,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.6),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: JarvisTheme.successGreen,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Online',
                            style: TextStyle(
                              fontSize: 12,
                              color: JarvisTheme.successGreen,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: JarvisTheme.primaryCyan,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
