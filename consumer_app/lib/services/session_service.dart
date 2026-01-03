import 'package:grpc/grpc.dart';
import 'package:consumer_app/proto/inventory_service.pbgrpc.dart';
import '../config/backend_config.dart';

class SessionService {
  late ClientChannel _channel;
  late RemoteInventoryServiceClient _client;

  SessionService() {
    // Use backend configuration instead of hardcoded values
    final backendHost = BackendConfig.host;
    final backendPort = BackendConfig.port;
    final useTLS = BackendConfig.useTLS;

    _channel = ClientChannel(
      backendHost,
      port: backendPort,
      options: ChannelOptions(
        credentials: useTLS
            ? ChannelCredentials.secure()
            : ChannelCredentials.insecure(),
      ),
    );
    _client = RemoteInventoryServiceClient(_channel);
  }

  Future<List<SessionInfo>> listSessions({String searchQuery = ''}) async {
    try {
      final request = ListSessionsRequest()..searchQuery = searchQuery;
      final response = await _client.listSessions(request);

      return response.sessions
          .map((s) => SessionInfo(
                sessionId: s.sessionId,
                providerName: s.providerName,
                providerLocation: s.providerLocation,
              ))
          .toList();
    } catch (e) {
      throw Exception('Failed to list sessions: $e');
    }
  }

  Future<String> requestConnection({
    required String sessionId,
    required String consumerId,
    required String consumerName,
  }) async {
    try {
      final request = ConnectionRequest()
        ..sessionId = sessionId
        ..consumerId = consumerId
        ..consumerName = consumerName;

      final response = await _client.requestConnection(request);
      if (!response.success) {
        throw Exception(response.message);
      }

      return response.requestId;
    } catch (e) {
      throw Exception('Failed to request connection: $e');
    }
  }

  Stream<ApprovalStatus> watchApprovalStatus(String requestId) async* {
    try {
      final request = WatchApprovalRequest()..requestId = requestId;
      final stream = _client.watchApprovalStatus(request);

      await for (final update in stream) {
        yield ApprovalStatus(
          status: _mapStatus(update.status),
          sessionId: update.sessionId,
          token: update.token,
          message: update.message,
        );
      }
    } catch (e) {
      throw Exception('Failed to watch approval status: $e');
    }
  }

  /// Create a new provider session
  /// Used by Provider mode to register with backend
  Future<SessionResponse> createSession({
    required String providerName,
    String? providerId,
    String? location,
  }) async {
    try {
      final request = CreateSessionRequest()..providerName = providerName;

      if (providerId != null) {
        request.providerId = providerId;
      }

      if (location != null) {
        request.location = location;
      }

      final response = await _client.createSession(request);

      if (!response.success) {
        throw Exception(response.message);
      }

      print('✅ Session created: ${response.sessionId}');

      return SessionResponse(
        sessionId: response.sessionId,
        token: response.token,
        success: response.success,
        message: response.message,
      );
    } catch (e) {
      print('❌ Failed to create session: $e');
      throw Exception('Failed to create session: $e');
    }
  }

  /// End a provider session
  /// Called when Provider mode exits
  Future<bool> endSession(String sessionId) async {
    try {
      final request = EndSessionRequest()..sessionId = sessionId;
      final response = await _client.endSession(request);

      if (response.success) {
        print('✅ Session ended: $sessionId');
      } else {
        print('⚠️  Session end returned false: $sessionId');
      }

      return response.success;
    } catch (e) {
      print('❌ Failed to end session: $e');
      return false;
    }
  }

  /// Approve a connection request (Provider side)
  Future<bool> approveConnection(String requestId) async {
    try {
      final request = ApproveRequest()..requestId = requestId;
      final response = await _client.approveConnection(request);

      if (response.success) {
        print('✅ Connection approved: $requestId');
      } else {
        print('⚠️  Approve failed: $requestId');
      }

      return response.success;
    } catch (e) {
      print('❌ Failed to approve connection: $e');
      return false;
    }
  }

  /// Deny a connection request (Provider side)
  Future<bool> denyConnection(String requestId) async {
    try {
      final request = DenyRequest()
        ..requestId = requestId
        ..reason = ''; // Optional reason
      final response = await _client.denyConnection(request);

      if (response.success) {
        print('✅ Connection denied: $requestId');
      } else {
        print('⚠️  Deny failed: $requestId');
      }

      return response.success;
    } catch (e) {
      print('❌ Failed to deny connection: $e');
      return false;
    }
  }

  /// Watch for incoming connection requests (Provider side)
  Stream<ConnectionRequestNotification> watchConnectionRequests(
      String sessionId) async* {
    try {
      final request = WatchRequestsRequest()..sessionId = sessionId;
      final stream = _client.watchConnectionRequests(request);

      await for (final notification in stream) {
        print(
            '🔔 Received connection request from ${notification.consumerName}');
        yield notification;
      }
    } catch (e) {
      print('❌ Error watching connection requests: $e');
      rethrow;
    }
  }

  ApprovalStatusEnum _mapStatus(ApprovalStatusUpdate_Status status) {
    switch (status) {
      case ApprovalStatusUpdate_Status.PENDING:
        return ApprovalStatusEnum.pending;
      case ApprovalStatusUpdate_Status.APPROVED:
        return ApprovalStatusEnum.approved;
      case ApprovalStatusUpdate_Status.DENIED:
        return ApprovalStatusEnum.denied;
      default:
        return ApprovalStatusEnum.pending;
    }
  }

  void dispose() {
    _channel.shutdown();
  }
}

/// Response from createSession
class SessionResponse {
  final String sessionId;
  final String token;
  final bool success;
  final String message;

  SessionResponse({
    required this.sessionId,
    required this.token,
    required this.success,
    required this.message,
  });
}

class SessionInfo {
  final String sessionId;
  final String providerName;
  final String providerLocation;

  SessionInfo({
    required this.sessionId,
    required this.providerName,
    required this.providerLocation,
  });
}

class ApprovalStatus {
  final ApprovalStatusEnum status;
  final String sessionId;
  final String token;
  final String message;

  ApprovalStatus({
    required this.status,
    required this.sessionId,
    required this.token,
    required this.message,
  });
}

enum ApprovalStatusEnum {
  pending,
  approved,
  denied,
}
