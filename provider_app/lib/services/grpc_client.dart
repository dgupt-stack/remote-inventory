import 'package:grpc/grpc.dart';
import '../generated/inventory_service.pbgrpc.dart';
import 'dart:async';

class GrpcClientService {
  late ClientChannel _channel;
  late InventoryServiceClient _client;
  bool _isConnected = false;

  final String host;
  final int port;

  // Session info
  String? sessionId;
  String? token;

  GrpcClientService({
    this.host = 'remote-inventory-backend-mlwjajxybq-uc.a.run.app',
    this.port = 443,
  });

  /// Initialize the gRPC connection
  Future<void> connect() async {
    if (_isConnected) return;

    _channel = ClientChannel(
      host,
      port: port,
      options: const ChannelOptions(
        credentials: ChannelCredentials.secure(), // TLS for Cloud Run
      ),
    );

    _client = InventoryServiceClient(_channel);
    _isConnected = true;

    print('✅ Connected to gRPC server at $host:$port');
  }

  /// Create a new session (Provider side)
  Future<SessionResponse> createSession({
    required String providerId,
    required String providerName,
  }) async {
    if (!_isConnected) await connect();

    final request = CreateSessionRequest()
      ..providerId = providerId
      ..providerName = providerName;

    try {
      final response = await _client.createSession(request);

      if (response.success) {
        sessionId = response.sessionId;
        token = response.token;
        print('✅ Session created: $sessionId');
      }

      return response;
    } catch (e) {
      print('❌ Error creating session: $e');
      rethrow;
    }
  }

  /// Start bidirectional streaming for Provider
  Stream<ProviderCommand> startProviderStream(
    Stream<ProviderMessage> messageStream,
  ) async* {
    if (!_isConnected) await connect();

    try {
      final stream = _client.providerStream(messageStream);
      await for (final command in stream) {
        yield command;
      }
    } catch (e) {
      print('❌ Provider stream error: $e');
      rethrow;
    }
  }

  /// Send heartbeat to keep session alive
  Future<HeartbeatResponse> sendHeartbeat(String role) async {
    if (!_isConnected || sessionId == null || token == null) {
      throw Exception('Not connected or session not initialized');
    }

    final request = HeartbeatRequest()
      ..sessionId = sessionId!
      ..token = token!
      ..role = role;

    try {
      return await _client.heartbeat(request);
    } catch (e) {
      print('❌ Heartbeat error: $e');
      rethrow;
    }
  }

  /// End the session
  Future<EndSessionResponse> endSession() async {
    if (!_isConnected || sessionId == null || token == null) {
      throw Exception('Not connected or session not initialized');
    }

    final request = EndSessionRequest()
      ..sessionId = sessionId!
      ..token = token!;

    try {
      final response = await _client.endSession(request);

      if (response.success) {
        sessionId = null;
        token = null;
        print('✅ Session ended');
      }

      return response;
    } catch (e) {
      print('❌ Error ending session: $e');
      rethrow;
    }
  }

  /// Close the gRPC connection
  Future<void> disconnect() async {
    if (_isConnected) {
      await _channel.shutdown();
      _isConnected = false;
      print('✅ Disconnected from gRPC server');
    }
  }

  bool get isConnected => _isConnected;
}
