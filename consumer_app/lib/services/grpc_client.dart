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

  /// Join an existing session (Consumer side)
  Future<SessionResponse> joinSession({
    required String sessionId,
    required String consumerId,
    required String consumerName,
  }) async {
    if (!_isConnected) await connect();

    final request = JoinSessionRequest()
      ..sessionId = sessionId
      ..consumerId = consumerId
      ..consumerName = consumerName;

    try {
      final response = await _client.joinSession(request);

      if (response.success) {
        this.sessionId = response.sessionId;
        token = response.token;
        print('✅ Joined session: ${response.sessionId}');
      }

      return response;
    } catch (e) {
      print('❌ Error joining session: $e');
      rethrow;
    }
  }

  /// Start bidirectional streaming for Consumer
  Stream<VideoFrame> startConsumerStream(
    Stream<ConsumerCommand> commandStream,
  ) async* {
    if (!_isConnected) await connect();

    try {
      final stream = _client.consumerStream(commandStream);
      await for (final frame in stream) {
        yield frame;
      }
    } catch (e) {
      print('❌ Consumer stream error: $e');
      rethrow;
    }
  }

  /// Send a navigation command
  Future<void> sendNavigationCommand(
    NavigationCommand_Direction direction, {
    double intensity = 0.5,
  }) async {
    // This will be added to the command stream
    print('📤 Sending navigation command: $direction');
  }

  /// Send a laser command
  Future<void> sendLaserCommand({
    required bool active,
    double x = 0.5,
    double y = 0.5,
  }) async {
    print('📤 Sending laser command: active=$active, x=$x, y=$y');
  }

  /// Send a stop command
  Future<void> sendStopCommand({bool emergency = false}) async {
    print('📤 Sending stop command: emergency=$emergency');
  }

  /// Send a zoom command
  Future<void> sendZoomCommand(
    ZoomCommand_ZoomType type, {
    double level = 1.0,
  }) async {
    print('📤 Sending zoom command: $type, level=$level');
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
