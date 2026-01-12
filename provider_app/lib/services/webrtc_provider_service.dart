import 'dart:convert';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:grpc/grpc.dart';
import '../proto/inventory_service.pbgrpc.dart';

/// WebRTC service for Provider (camera device)
/// Manages camera, peer connection, and WebRTC signaling
class WebRTCProviderService {
  RTCPeerConnection? _peerConnection;
  MediaStream? _localStream;
  String? _sessionId;
  String? _deviceId;
  RemoteInventoryServiceClient? _stub;

  bool get isStreaming => _peerConnection != null && _localStream != null;
  MediaStream? get localStream => _localStream;

  /// Initialize camera and get local video stream
  Future<void> startCamera() async {
    try {
      // Request camera access
      final Map<String, dynamic> mediaConstraints = {
        'audio': false,
        'video': {
          'facingMode': 'environment', // Back camera
          'width': 1280,
          'height': 720,
        }
      };

      _localStream =
          await navigator.mediaDevices.getUserMedia(mediaConstraints);
      print('✅ Camera started');
    } catch (e) {
      print('❌ Camera error: $e');
      rethrow;
    }
  }

  /// Create WebRTC peer connection and generate offer
  Future<void> createOffer({
    required String sessionId,
    required String deviceId,
    required RemoteInventoryServiceClient stub,
  }) async {
    _sessionId = sessionId;
    _deviceId = deviceId;
    _stub = stub;

    try {
      // Create peer connection with Google STUN server
      final Map<String, dynamic> configuration = {
        'iceServers': [
          {'urls': 'stun:stun.l.google.com:19302'},
          {'urls': 'stun:stun1.l.google.com:19302'},
        ]
      };

      _peerConnection = await createPeerConnection(configuration);

      // Add local stream tracks to peer connection
      if (_localStream != null) {
        _localStream!.getTracks().forEach((track) {
          _peerConnection!.addTrack(track, _localStream!);
        });
      }

      // Handle ICE candidates
      _peerConnection!.onIceCandidate = (RTCIceCandidate candidate) {
        _sendIceCandidate(candidate);
      };

      // Create and set local description (offer)
      RTCSessionDescription offer = await _peerConnection!.createOffer();
      await _peerConnection!.setLocalDescription(offer);

      // Send offer to backend for relay to consumer
      await _sendOffer(offer);

      print('✅ WebRTC offer created and sent');
    } catch (e) {
      print('❌ Create offer error: $e');
      rethrow;
    }
  }

  /// Send SDP offer to backend
  Future<void> _sendOffer(RTCSessionDescription offer) async {
    final payload = jsonEncode({
      'type': offer.type,
      'sdp': offer.sdp,
    });

    final signal = WebRTCSignal()
      ..sessionId = _sessionId!
      ..fromDeviceId = _deviceId!
      ..toDeviceId =
          'consumer' // Will be replaced with actual consumer device ID
      ..type = WebRTCSignal_SignalType.OFFER
      ..payload = payload;

    await _stub!.sendWebRTCSignal(signal);
    print('📡 Sent offer to backend');
  }

  /// Send ICE candidate to backend
  Future<void> _sendIceCandidate(RTCIceCandidate candidate) async {
    final payload = jsonEncode({
      'candidate': candidate.candidate,
      'sdpMid': candidate.sdpMid,
      'sdpMLineIndex': candidate.sdpMLineIndex,
    });

    final signal = WebRTCSignal()
      ..sessionId = _sessionId!
      ..fromDeviceId = _deviceId!
      ..toDeviceId = 'consumer'
      ..type = WebRTCSignal_SignalType.ICE_CANDIDATE
      ..payload = payload;

    await _stub!.sendWebRTCSignal(signal);
    print('📡 Sent ICE candidate');
  }

  /// Watch for answer from consumer
  Future<void> watchForAnswer({required String consumerDeviceId}) async {
    try {
      final request = WatchSignalsRequest()
        ..sessionId = _sessionId!
        ..deviceId = _deviceId!;

      final stream = _stub!.watchWebRTCSignals(request);

      await for (final signal in stream) {
        if (signal.type == WebRTCSignal_SignalType.ANSWER) {
          await _handleAnswer(signal);
          break; // We only need one answer
        } else if (signal.type == WebRTCSignal_SignalType.ICE_CANDIDATE) {
          await _handleIceCandidate(signal);
        }
      }
    } catch (e) {
      print('❌ Watch for answer error: $e');
    }
  }

  /// Handle SDP answer from consumer
  Future<void> _handleAnswer(WebRTCSignal signal) async {
    try {
      final data = jsonDecode(signal.payload);
      final answer = RTCSessionDescription(data['sdp'], data['type']);

      await _peerConnection!.setRemoteDescription(answer);
      print('✅ Answer received and set');
    } catch (e) {
      print('❌ Handle answer error: $e');
    }
  }

  /// Handle ICE candidate from consumer
  Future<void> _handleIceCandidate(WebRTCSignal signal) async {
    try {
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

  /// Stop streaming and cleanup
  Future<void> stopStreaming() async {
    await _localStream?.dispose();
    await _peerConnection?.close();

    _localStream = null;
    _peerConnection = null;
    _sessionId = null;
    _deviceId = null;

    print('🛑 Streaming stopped');
  }
}
