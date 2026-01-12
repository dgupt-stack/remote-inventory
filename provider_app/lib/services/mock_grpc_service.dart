import 'package:grpc/grpc.dart';
import '../proto/inventory_service.pbgrpc.dart';

/// Mock gRPC service for offline testing
/// Simulates backend responses without actual server connection
class MockGrpcService {
  bool _isDemoMode = true;

  // Mock sessions for demo
  final List<SessionInfo> _mockSessions = [
    SessionInfo()
      ..sessionId = 'demo-session-1'
      ..providerName = 'Demo Camera 1'
      ..providerLocation = 'Living Room'
      ..createdAt = DateTime.now().millisecondsSinceEpoch
      ..acceptingConnections = true,
    SessionInfo()
      ..sessionId = 'demo-session-2'
      ..providerName = 'Demo Camera 2'
      ..providerLocation = 'Kitchen'
      ..createdAt = DateTime.now().millisecondsSinceEpoch
      ..acceptingConnections = true,
    SessionInfo()
      ..sessionId = 'demo-session-3'
      ..providerName = 'Demo Camera 3'
      ..providerLocation = 'Garage'
      ..createdAt = DateTime.now().millisecondsSinceEpoch
      ..acceptingConnections = true,
  ];

  /// List mock sessions
  Future<ListSessionsResponse> listSessions() async {
    await Future.delayed(
        const Duration(milliseconds: 500)); // Simulate network delay

    final response = ListSessionsResponse();
    response.sessions.addAll(_mockSessions);
    return response;
  }

  /// Create mock session for Provider
  Future<SessionResponse> createSession({
    required String providerName,
    required String providerId,
    required String location,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final sessionId = 'mock-session-${DateTime.now().millisecondsSinceEpoch}';

    return SessionResponse()
      ..sessionId = sessionId
      ..success = true
      ..message = 'Demo session created';
  }

  /// Mock connection request
  Future<ConnectionResponse> requestConnection({
    required String sessionId,
    required String consumerId,
    required String consumerName,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));

    return ConnectionResponse()
      ..requestId = 'mock-request-${DateTime.now().millisecondsSinceEpoch}'
      ..success = true
      ..message = 'Demo connection requested';
  }

  /// Mock approval status stream
  Stream<ApprovalStatusUpdate> watchApprovalStatus(String requestId) async* {
    await Future.delayed(const Duration(seconds: 1));

    // Simulate pending
    yield ApprovalStatusUpdate()
      ..status = ApprovalStatusUpdate_Status.PENDING
      ..message = 'Waiting for approval...';

    await Future.delayed(const Duration(seconds: 2));

    // Auto-approve for demo
    yield ApprovalStatusUpdate()
      ..status = ApprovalStatusUpdate_Status.APPROVED
      ..sessionId = 'demo-session'
      ..token = 'demo-token'
      ..message = 'Demo approved!';
  }

  /// Mock WebRTC signal sending
  Future<SignalResponse> sendWebRTCSignal(WebRTCSignal signal) async {
    await Future.delayed(const Duration(milliseconds: 100));
    print('📡 [DEMO] Sending signal: ${signal.type}');

    return SignalResponse()
      ..success = true
      ..message = 'Demo signal sent';
  }

  /// Mock WebRTC signal stream
  Stream<WebRTCSignal> watchWebRTCSignals({
    required String sessionId,
    required String deviceId,
  }) async* {
    print('👀 [DEMO] Watching signals for device: $deviceId');

    // In demo mode, we don't actually exchange signals
    // The camera will work locally without P2P connection
    await Future.delayed(const Duration(seconds: 30));
  }

  /// End session
  Future<EndSessionResponse> endSession(String sessionId) async {
    await Future.delayed(const Duration(milliseconds: 200));

    return EndSessionResponse()
      ..success = true
      ..message = 'Demo session ended';
  }
}
