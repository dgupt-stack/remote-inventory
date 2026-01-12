import 'package:grpc/grpc.dart';
import '../generated/inventory_service.pbgrpc.dart';
import '../config/app_config.dart';

// Simple session info model
class SessionInfo {
  final String sessionId;
  final String providerId;
  final String providerName;
  final String? location;
  final DateTime createdAt;

  SessionInfo({
    required this.sessionId,
    required this.providerId,
    required this.providerName,
    this.location,
    required this.createdAt,
  });
}

class SessionService {
  late ClientChannel _channel;
  late InventoryServiceClient _client;

  SessionService() {
    _initializeClient();
  }

  void _initializeClient() {
    _channel = ClientChannel(
      AppConfig.backendHost,
      port: AppConfig.backendPort,
      options: ChannelOptions(
        credentials: AppConfig.useTLS
            ? ChannelCredentials.secure()
            : ChannelCredentials.insecure(),
      ),
    );
    _client = InventoryServiceClient(_channel);
  }

  // Reinitialize when backend config changes
  void reinitialize() {
    _channel.shutdown();
    _initializeClient();
  }

  Future<List<SessionInfo>> listSessions({String searchQuery = ''}) async {
    try {
      final request = ListSessionsRequest();
      final response = await _client.listSessions(request);

      final sessions = response.sessions.map((s) {
        return SessionInfo(
          sessionId: s.sessionId,
          providerId: s.sessionId,
          providerName: s.providerName,
          // Use geocoded address if available, fallback to location
          location: s.formattedAddress.isNotEmpty
              ? s.formattedAddress
              : (s.location.isNotEmpty ? s.location : 'Unknown'),
          createdAt: DateTime.fromMillisecondsSinceEpoch(s.createdAt.toInt() * 1000),
        );
      }).toList();

      // Filter by search query if provided
      if (searchQuery.isNotEmpty) {
        final query = searchQuery.toLowerCase();
        return sessions.where((s) {
          return s.providerName.toLowerCase().contains(query) ||
              (s.location?.toLowerCase().contains(query) ?? false);
        }).toList();
      }

      return sessions;
    } catch (e) {
      print('Error listing sessions: $e');
      return [];
    }
  }

  Future<SessionInfo> createSession({
    required String providerId,
    required String providerName,
    String? location,
    double? latitude,
    double? longitude,
  }) async {
    try {
      final request = CreateSessionRequest()
        ..providerId = providerId
        ..providerName = providerName;

      // Add location fields if available
      if (location != null && location.isNotEmpty) {
        request.location = location;
      }
      if (latitude != null && longitude != null) {
        request.latitude = latitude;
        request.longitude = longitude;
      }

      final response = await _client.createSession(request);

      return SessionInfo(
        sessionId: response.sessionId,
        providerId: providerId,
        providerName: providerName,
        location: location,
        createdAt: DateTime.now(),
      );
    } catch (e) {
      print('Error creating session: $e');
      rethrow;
    }
  }

  Future<bool> endSession(String sessionId) async {
    try {
      final request = EndSessionRequest()..sessionId = sessionId;
      await _client.endSession(request); // Await the call

      print('✅ Session ended: $sessionId');
      return true; // EndSessionResponse doesn't have success field, assume success if no error
    } catch (e) {
      print('Error ending session: $e');
      return false;
    }
  }

  void dispose() {
    _channel.shutdown();
  }
}
