import 'package:grpc/grpc.dart';
import '../generated/inventory_service.pbgrpc.dart';

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
    _channel = ClientChannel(
      'remote-inventory-backend-mlwjajxybq-uc.a.run.app',
      port: 443,
      options: const ChannelOptions(
        credentials: ChannelCredentials.secure(), // TLS for Cloud Run
      ),
    );
    _client = InventoryServiceClient(_channel);
  }

  // For now, return mock data until backend supports ListSessions
  Future<List<SessionInfo>> listSessions({String searchQuery = ''}) async {
    try {
      // TODO: Backend doesn't have ListSessions yet, using mock data
      // Once backend is updated with the new proto, replace this with:
      // final request = ListSessionsRequest()..searchQuery = searchQuery;
      // final response = await _client.listSessions(request);

      // Mock data for testing
      await Future.delayed(
          Duration(milliseconds: 500)); // Simulate network delay

      final mockSessions = [
        SessionInfo(
          sessionId: 'session_123',
          providerId: 'provider_1',
          providerName: 'Test Provider 1',
          location: '123 Main Street, San Francisco, CA',
          createdAt: DateTime.now().subtract(Duration(minutes: 5)),
        ),
        SessionInfo(
          sessionId: 'session_456',
          providerId: 'provider_2',
          providerName: 'Test Provider 2',
          location: '456 Oak Avenue, Palo Alto, CA',
          createdAt: DateTime.now().subtract(Duration(minutes: 10)),
        ),
      ];

      // Filter by search query if provided
      if (searchQuery.isNotEmpty) {
        return mockSessions.where((s) {
          final query = searchQuery.toLowerCase();
          return (s.providerName.toLowerCase().contains(query)) ||
              (s.location?.toLowerCase().contains(query) ?? false);
        }).toList();
      }

      return mockSessions;
    } catch (e) {
      print('Error listing sessions: $e');
      return [];
    }
  }

  Future<SessionInfo> createSession({
    required String providerId,
    required String providerName,
    String? location,
  }) async {
    try {
      final request = CreateSessionRequest()
        ..providerId = providerId
        ..providerName = providerName;
      // Note: location not supported in current proto, will be added later

      final response = await _client.createSession(request);

      // Assuming the new proto doesn't have a 'success' field for CreateSessionResponse
      // and that a successful response implies creation.

      return SessionInfo(
        sessionId: response.sessionId,
        providerId: providerId,
        providerName: providerName,
        location: location, // Store locally, not sent to backend yet
        createdAt: DateTime
            .now(), // Assuming createdAt is not returned by the proto yet
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
