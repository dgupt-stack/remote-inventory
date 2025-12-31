import 'package:flutter_test/flutter_test.dart';
import 'package:provider_app/services/grpc_client.dart';

void main() {
  group('GrpcClientService', () {
    late GrpcClientService client;

    setUp(() {
      client = GrpcClientService(
        host: 'localhost',
        port: 8080,
      );
    });

    test('should initialize with correct host and port', () {
      expect(client.host, equals('localhost'));
      expect(client.port, equals(8080));
      expect(client.isConnected, isFalse);
    });

    test('should have null session initially', () {
      expect(client.sessionId, isNull);
      expect(client.token, isNull);
    });

    // Note: Integration tests requiring actual backend should be run separately
    // These are unit tests for the client structure
  });
}
