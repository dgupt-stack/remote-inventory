import 'dart:convert';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:grpc/grpc.dart';
import '../proto/inventory_service.pbgrpc.dart';

/// WebRTC service for Consumer (viewer device)
/// Receives video stream from Provider via WebRTC P2P connection
class WebRTCConsumerService {
  RTCPeerConnection? _peerConnection;
  MediaStream? _remoteStream;
  String? _sessionId;
  String? _deviceId;
  RemoteInventoryServiceClient? _stub;

  // Stream controller for remote video
  final List<Function(MediaStream)> _remoteStreamListeners = [];

  bool get isConnected => _peerConnection != null && _remoteStream != null;
  MediaStream? get remoteStream => _remoteStream;

  /// Add listener for remote stream updates
  void addRemoteStreamListener(Function(MediaStream) listener) {
    _remoteStreamListeners.add(listener);
  }

  /// Start watching for Provider's offer
  Future<void> watchForOffer({
    required String sessionId,
    required String deviceId,
    required RemoteInventoryServiceClient stub,
  }) async {
    _sessionId = sessionId;
    _deviceId = deviceId;
    _stub = stub;

    try {
      final request = WatchSignalsRequest()
        ..sessionId = sessionId
        ..deviceId = deviceId;

      final stream = stub.watchWebRTCSignals(request);

      await for (final signal in stream) {
        if (signal.type == WebRTCSignal_SignalType.OFFER) {
          await _handleOffer(signal);
        } else if (signal.type == WebRTCSignal_SignalType.ICE_CANDIDATE) {
          await _handleIceCandidate(signal);
        }
      }
    } catch (e) {
      print('❌ Watch for offer error: $e');
      rethrow;
    }
  }

  /// Handle SDP offer from Provider
  Future<void> _handleOffer(WebRTCSignal signal) async {
    try {
      print('📥 Received offer from Provider');

      // Create peer connection
      final Map<String, dynamic> configuration = {
        'iceServers': [
          {'urls': 'stun:stun.l.google.com:19302'},
          {'urls': 'stun:stun1.l.google.com:19302'},
        ]
      };

      _peerConnection = await createPeerConnection(configuration);

      // Handle remote stream
      _peerConnection!.onTrack = (RTCTrackEvent event) {
        print('✅ Received remote track');
        if (event.streams.isNotEmpty) {
          _remoteStream = event.streams[0];
          // Notify listeners
          for (var listener in _remoteStreamListeners) {
            listener(_remoteStream!);
          }
        }
      };

      // Handle ICE candidates
      _peerConnection!.onIceCandidate = (RTCIceCandidate candidate) {
        _sendIceCandidate(candidate);
      };

      // Set remote description (offer)
      final data = jsonDecode(signal.payload);
      final offer = RTCSessionDescription(data['sdp'], data['type']);
      await _peerConnection!.setRemoteDescription(offer);

      // Create and send answer
      RTCSessionDescription answer = await _peerConnection!.createAnswer();
      await _peerConnection!.setLocalDescription(answer);
      await _sendAnswer(answer, signal.fromDeviceId);

      print('✅ Answer sent to Provider');
    } catch (e) {
      print('❌ Handle offer error: $e');
      rethrow;
    }
  }

  /// Send SDP answer to Provider
  Future<void> _sendAnswer(
      RTCSessionDescription answer, String providerDeviceId) async {
    final payload = jsonEncode({
      'type': answer.type,
      'sdp': answer.sdp,
    });

    final signal = WebRTCSignal()
      ..sessionId = _sessionId!
      ..fromDeviceId = _deviceId!
      ..toDeviceId = providerDeviceId
      ..type = WebRTCSignal_SignalType.ANSWER
      ..payload = payload;

    await _stub!.sendWebRTCSignal(signal);
    print('📡 Answer sent to backend');
  }

  /// Send ICE candidate to Provider
  Future<void> _sendIceCandidate(RTCIceCandidate candidate) async {
    final payload = jsonEncode({
      'candidate': candidate.candidate,
      'sdpMid': candidate.sdpMid,
      'sdpMLineIndex': candidate.sdpMLineIndex,
    });

    final signal = WebRTCSignal()
      ..sessionId = _sessionId!
      ..fromDeviceId = _deviceId!
      ..toDeviceId =
          'provider' // Will be replaced with actual provider device ID
      ..type = WebRTCSignal_SignalType.ICE_CANDIDATE
      ..payload = payload;

    await _stub!.sendWebRTCSignal(signal);
    print('📡 ICE candidate sent');
  }

  /// Handle ICE candidate from Provider
  Future<void> _handleIceCandidate(WebRTCSignal signal) async {
    try {
      if (_peerConnection == null) {
        print('⚠️  Received ICE candidate before peer connection ready');
        return;
      }

      final data = jsonDecode(signal.payload);
      final candidate = RTCIceCandidate(
        data['candidate'],
        data['sdpMid'],
        data['sdpMLineIndex'],
      );

      await _peerConnection!.addCandidate(candidate);
      print('✅ ICE candidate added');
    } catch (e) {
      print('❌ Handle ICE error: $e');
    }
  }

  /// Stop viewing and cleanup
  Future<void> stopViewing() async {
    await _remoteStream?.dispose();
    await _peerConnection?.close();

    _remoteStream = null;
    _peerConnection = null;
    _sessionId = null;
    _deviceId = null;
    _remoteStreamListeners.clear();

    print('🛑 Viewing stopped');
  }
}
