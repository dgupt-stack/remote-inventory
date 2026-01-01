import 'dart:async';
import 'package:grpc/grpc.dart';
import 'package:provider_app/proto/inventory_service.pbgrpc.dart';

class RequestWatcherService {
  late ClientChannel _channel;
  late RemoteInventoryServiceClient _client;
  StreamSubscription? _requestSubscription;

  RequestWatcherService() {
    _channel = ClientChannel(
      'localhost', // TODO: Replace with actual backend URL
      port: 8080,
      options: const ChannelOptions(
        credentials: ChannelCredentials.insecure(),
      ),
    );
    _client = RemoteInventoryServiceClient(_channel);
  }

  // Start watching for connection requests
  void watchRequests({
    required String sessionId,
    required Function(ConnectionRequestInfo) onRequest,
    required Function(Object) onError,
  }) {
    try {
      final request = WatchRequestsRequest()..sessionId = sessionId;
      final stream = _client.watchConnectionRequests(request);

      _requestSubscription = stream.listen(
        (notification) {
          onRequest(ConnectionRequestInfo(
            requestId: notification.requestId,
            consumerId: notification.consumerId,
            consumerName: notification.consumerName,
            requestedAt: DateTime.fromMillisecondsSinceEpoch(
              notification.requestedAt.toInt() * 1000,
            ),
          ));
        },
        onError: onError,
      );
    } catch (e) {
      onError(e);
    }
  }

  // Approve a connection request
  Future<void> approveRequest(String requestId) async {
    try {
      final request = ApproveRequest()..requestId = requestId;
      final response = await _client.approveConnection(request);

      if (!response.success) {
        throw Exception('Failed to approve request');
      }
    } catch (e) {
      throw Exception('Failed to approve connection: $e');
    }
  }

  // Deny a connection request
  Future<void> denyRequest(String requestId, {String reason = ''}) async {
    try {
      final request = DenyRequest()
        ..requestId = requestId
        ..reason = reason;

      final response = await _client.denyConnection(request);

      if (!response.success) {
        throw Exception('Failed to deny request');
      }
    } catch (e) {
      throw Exception('Failed to deny connection: $e');
    }
  }

  // Create a session
  Future<String> createSession({
    required String providerId,
    required String providerName,
  }) async {
    try {
      final request = CreateSessionRequest()
        ..providerId = providerId
        ..providerName = providerName;

      final response = await _client.createSession(request);

      if (!response.success) {
        throw Exception(response.message);
      }

      return response.sessionId;
    } catch (e) {
      throw Exception('Failed to create session: $e');
    }
  }

  // Stop watching and cleanup
  void dispose() {
    _requestSubscription?.cancel();
    _channel.shutdown();
  }
}

class ConnectionRequestInfo {
  final String requestId;
  final String consumerId;
  final String consumerName;
  final DateTime requestedAt;

  ConnectionRequestInfo({
    required this.requestId,
    required this.consumerId,
    required this.consumerName,
    required this.requestedAt,
  });
}
