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
          createdAt:
              DateTime.fromMillisecondsSinceEpoch(s.createdAt.toInt() * 1000),
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
      await _client.endSession(request);

      print('✅ Session ended: $sessionId');
      return true;
    } catch (e) {
      print('Error ending session: $e');
      return false;
    }
  }

  // Connection Request Methods (v1.3.0)

  /// Send connection request from consumer to provider
  Future<String> requestConnection({
    required String sessionId,
    required String consumerId,
    required String consumerName,
  }) async {
    try {
      final request = RequestConnectionRequest()
        ..sessionId = sessionId
        ..consumerId = consumerId
        ..consumerName = consumerName;

      final response = await _client.requestConnection(request);
      print('✅ Connection request sent: ${response.requestId}');
      return response.requestId;
    } catch (e) {
      print('❌ Error requesting connection: $e');
      rethrow;
    }
  }

  /// Provider approves a connection request
  Future<void> approveConnection(String requestId) async {
    try {
      final request = ApproveConnectionRequest()..requestId = requestId;
      await _client.approveConnection(request);
      print('✅ Connection approved: $requestId');
    } catch (e) {
      print('❌ Error approving connection: $e');
      rethrow;
    }
  }

  /// Provider denies a connection request
  Future<void> denyConnection(String requestId, {String? reason}) async {
    try {
      final request = DenyConnectionRequest()
        ..requestId = requestId
        ..reason = reason ?? 'Provider declined';
      await _client.denyConnection(request);
      print('✅ Connection denied: $requestId');
    } catch (e) {
      print('❌ Error denying connection: $e');
      rethrow;
    }
  }

  /// Provider watches for incoming connection requests (streaming)
  Stream<ConnectionRequestInfo> watchConnectionRequests(String sessionId) {
    try {
      final request = WatchConnectionRequestsRequest()..sessionId = sessionId;
      final stream = _client.watchConnectionRequests(request);

      return stream.map((notification) {
        return ConnectionRequestInfo(
          requestId: notification.requestId,
          consumerId: notification.consumerId,
          consumerName: notification.consumerName,
          timestamp: DateTime.fromMillisecondsSinceEpoch(
            notification.timestamp.toInt() * 1000,
          ),
        );
      });
    } catch (e) {
      print('❌ Error watching connection requests: $e');
      return Stream.error(e);
    }
  }

  /// Consumer watches for approval status (streaming)
  Stream<ApprovalStatusModel> watchApprovalStatus(String requestId) {
    try {
      final request = WatchApprovalStatusRequest()..requestId = requestId;
      final stream = _client.watchApprovalStatus(request);

      return stream.map((update) {
        return ApprovalStatusModel(
          approved: update.status == ApprovalStatus.APPROVED,
          denied: update.status == ApprovalStatus.DENIED,
          message: update.message,
        );
      });
    } catch (e) {
      print('❌ Error watching approval status: $e');
      return Stream.error(e);
    }
  }

  void dispose() {
    _channel.shutdown();
  }
}

// Helper models for connection requests (v1.3.0)

class ConnectionRequestInfo {
  final String requestId;
  final String consumerId;
  final String consumerName;
  final DateTime timestamp;

  ConnectionRequestInfo({
    required this.requestId,
    required this.consumerId,
    required this.consumerName,
    required this.timestamp,
  });
}

class ApprovalStatusModel {
  final bool approved;
  final bool denied;
  final String message;

  ApprovalStatusModel({
    required this.approved,
    required this.denied,
    required this.message,
  });

  bool get isPending => !approved && !denied;
}
