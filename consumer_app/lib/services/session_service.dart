import 'package:grpc/grpc.dart';
import 'package:consumer_app/proto/inventory_service.pbgrpc.dart';

class SessionService {
  late ClientChannel _channel;
  late RemoteInventoryServiceClient _client;

  SessionService() {
    _channel = ClientChannel(
      'localhost', // TODO: Replace with actual backend URL
      port: 8080,
      options: const ChannelOptions(
        credentials: ChannelCredentials.insecure(),
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
