//
//  Generated code. Do not modify.
//  source: inventory_service.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'package:protobuf/protobuf.dart' as $pb;

import 'inventory_service.pb.dart' as $0;

export 'inventory_service.pb.dart';

@$pb.GrpcServiceName('inventory.InventoryService')
class InventoryServiceClient extends $grpc.Client {
  static final _$createSession = $grpc.ClientMethod<$0.CreateSessionRequest, $0.SessionResponse>(
      '/inventory.InventoryService/CreateSession',
      ($0.CreateSessionRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.SessionResponse.fromBuffer(value));
  static final _$listSessions = $grpc.ClientMethod<$0.ListSessionsRequest, $0.ListSessionsResponse>(
      '/inventory.InventoryService/ListSessions',
      ($0.ListSessionsRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.ListSessionsResponse.fromBuffer(value));
  static final _$endSession = $grpc.ClientMethod<$0.EndSessionRequest, $0.EndSessionResponse>(
      '/inventory.InventoryService/EndSession',
      ($0.EndSessionRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.EndSessionResponse.fromBuffer(value));
  static final _$sendWebRTCSignal = $grpc.ClientMethod<$0.WebRTCSignal, $0.SignalResponse>(
      '/inventory.InventoryService/SendWebRTCSignal',
      ($0.WebRTCSignal value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.SignalResponse.fromBuffer(value));
  static final _$watchWebRTCSignals = $grpc.ClientMethod<$0.WatchSignalsRequest, $0.WebRTCSignal>(
      '/inventory.InventoryService/WatchWebRTCSignals',
      ($0.WatchSignalsRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.WebRTCSignal.fromBuffer(value));
  static final _$providerStream = $grpc.ClientMethod<$0.ProviderMessage, $0.ProviderCommand>(
      '/inventory.InventoryService/ProviderStream',
      ($0.ProviderMessage value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.ProviderCommand.fromBuffer(value));
  static final _$consumerStream = $grpc.ClientMethod<$0.ConsumerCommand, $0.VideoFrame>(
      '/inventory.InventoryService/ConsumerStream',
      ($0.ConsumerCommand value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.VideoFrame.fromBuffer(value));
  static final _$heartbeat = $grpc.ClientMethod<$0.HeartbeatRequest, $0.HeartbeatResponse>(
      '/inventory.InventoryService/Heartbeat',
      ($0.HeartbeatRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.HeartbeatResponse.fromBuffer(value));
  static final _$requestConnection = $grpc.ClientMethod<$0.RequestConnectionRequest, $0.RequestConnectionResponse>(
      '/inventory.InventoryService/RequestConnection',
      ($0.RequestConnectionRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.RequestConnectionResponse.fromBuffer(value));
  static final _$approveConnection = $grpc.ClientMethod<$0.ApproveConnectionRequest, $0.ApproveConnectionResponse>(
      '/inventory.InventoryService/ApproveConnection',
      ($0.ApproveConnectionRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.ApproveConnectionResponse.fromBuffer(value));
  static final _$denyConnection = $grpc.ClientMethod<$0.DenyConnectionRequest, $0.DenyConnectionResponse>(
      '/inventory.InventoryService/DenyConnection',
      ($0.DenyConnectionRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.DenyConnectionResponse.fromBuffer(value));
  static final _$watchConnectionRequests = $grpc.ClientMethod<$0.WatchConnectionRequestsRequest, $0.ConnectionRequestNotification>(
      '/inventory.InventoryService/WatchConnectionRequests',
      ($0.WatchConnectionRequestsRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.ConnectionRequestNotification.fromBuffer(value));
  static final _$watchApprovalStatus = $grpc.ClientMethod<$0.WatchApprovalStatusRequest, $0.ApprovalStatusUpdate>(
      '/inventory.InventoryService/WatchApprovalStatus',
      ($0.WatchApprovalStatusRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.ApprovalStatusUpdate.fromBuffer(value));

  InventoryServiceClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options,
        interceptors: interceptors);

  $grpc.ResponseFuture<$0.SessionResponse> createSession($0.CreateSessionRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$createSession, request, options: options);
  }

  $grpc.ResponseFuture<$0.ListSessionsResponse> listSessions($0.ListSessionsRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$listSessions, request, options: options);
  }

  $grpc.ResponseFuture<$0.EndSessionResponse> endSession($0.EndSessionRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$endSession, request, options: options);
  }

  $grpc.ResponseFuture<$0.SignalResponse> sendWebRTCSignal($0.WebRTCSignal request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$sendWebRTCSignal, request, options: options);
  }

  $grpc.ResponseStream<$0.WebRTCSignal> watchWebRTCSignals($0.WatchSignalsRequest request, {$grpc.CallOptions? options}) {
    return $createStreamingCall(_$watchWebRTCSignals, $async.Stream.fromIterable([request]), options: options);
  }

  $grpc.ResponseStream<$0.ProviderCommand> providerStream($async.Stream<$0.ProviderMessage> request, {$grpc.CallOptions? options}) {
    return $createStreamingCall(_$providerStream, request, options: options);
  }

  $grpc.ResponseStream<$0.VideoFrame> consumerStream($async.Stream<$0.ConsumerCommand> request, {$grpc.CallOptions? options}) {
    return $createStreamingCall(_$consumerStream, request, options: options);
  }

  $grpc.ResponseFuture<$0.HeartbeatResponse> heartbeat($0.HeartbeatRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$heartbeat, request, options: options);
  }

  $grpc.ResponseFuture<$0.RequestConnectionResponse> requestConnection($0.RequestConnectionRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$requestConnection, request, options: options);
  }

  $grpc.ResponseFuture<$0.ApproveConnectionResponse> approveConnection($0.ApproveConnectionRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$approveConnection, request, options: options);
  }

  $grpc.ResponseFuture<$0.DenyConnectionResponse> denyConnection($0.DenyConnectionRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$denyConnection, request, options: options);
  }

  $grpc.ResponseStream<$0.ConnectionRequestNotification> watchConnectionRequests($0.WatchConnectionRequestsRequest request, {$grpc.CallOptions? options}) {
    return $createStreamingCall(_$watchConnectionRequests, $async.Stream.fromIterable([request]), options: options);
  }

  $grpc.ResponseStream<$0.ApprovalStatusUpdate> watchApprovalStatus($0.WatchApprovalStatusRequest request, {$grpc.CallOptions? options}) {
    return $createStreamingCall(_$watchApprovalStatus, $async.Stream.fromIterable([request]), options: options);
  }
}

@$pb.GrpcServiceName('inventory.InventoryService')
abstract class InventoryServiceBase extends $grpc.Service {
  $core.String get $name => 'inventory.InventoryService';

  InventoryServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.CreateSessionRequest, $0.SessionResponse>(
        'CreateSession',
        createSession_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.CreateSessionRequest.fromBuffer(value),
        ($0.SessionResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ListSessionsRequest, $0.ListSessionsResponse>(
        'ListSessions',
        listSessions_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.ListSessionsRequest.fromBuffer(value),
        ($0.ListSessionsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.EndSessionRequest, $0.EndSessionResponse>(
        'EndSession',
        endSession_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.EndSessionRequest.fromBuffer(value),
        ($0.EndSessionResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.WebRTCSignal, $0.SignalResponse>(
        'SendWebRTCSignal',
        sendWebRTCSignal_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.WebRTCSignal.fromBuffer(value),
        ($0.SignalResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.WatchSignalsRequest, $0.WebRTCSignal>(
        'WatchWebRTCSignals',
        watchWebRTCSignals_Pre,
        false,
        true,
        ($core.List<$core.int> value) => $0.WatchSignalsRequest.fromBuffer(value),
        ($0.WebRTCSignal value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ProviderMessage, $0.ProviderCommand>(
        'ProviderStream',
        providerStream,
        true,
        true,
        ($core.List<$core.int> value) => $0.ProviderMessage.fromBuffer(value),
        ($0.ProviderCommand value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ConsumerCommand, $0.VideoFrame>(
        'ConsumerStream',
        consumerStream,
        true,
        true,
        ($core.List<$core.int> value) => $0.ConsumerCommand.fromBuffer(value),
        ($0.VideoFrame value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.HeartbeatRequest, $0.HeartbeatResponse>(
        'Heartbeat',
        heartbeat_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.HeartbeatRequest.fromBuffer(value),
        ($0.HeartbeatResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.RequestConnectionRequest, $0.RequestConnectionResponse>(
        'RequestConnection',
        requestConnection_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.RequestConnectionRequest.fromBuffer(value),
        ($0.RequestConnectionResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ApproveConnectionRequest, $0.ApproveConnectionResponse>(
        'ApproveConnection',
        approveConnection_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.ApproveConnectionRequest.fromBuffer(value),
        ($0.ApproveConnectionResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.DenyConnectionRequest, $0.DenyConnectionResponse>(
        'DenyConnection',
        denyConnection_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.DenyConnectionRequest.fromBuffer(value),
        ($0.DenyConnectionResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.WatchConnectionRequestsRequest, $0.ConnectionRequestNotification>(
        'WatchConnectionRequests',
        watchConnectionRequests_Pre,
        false,
        true,
        ($core.List<$core.int> value) => $0.WatchConnectionRequestsRequest.fromBuffer(value),
        ($0.ConnectionRequestNotification value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.WatchApprovalStatusRequest, $0.ApprovalStatusUpdate>(
        'WatchApprovalStatus',
        watchApprovalStatus_Pre,
        false,
        true,
        ($core.List<$core.int> value) => $0.WatchApprovalStatusRequest.fromBuffer(value),
        ($0.ApprovalStatusUpdate value) => value.writeToBuffer()));
  }

  $async.Future<$0.SessionResponse> createSession_Pre($grpc.ServiceCall call, $async.Future<$0.CreateSessionRequest> request) async {
    return createSession(call, await request);
  }

  $async.Future<$0.ListSessionsResponse> listSessions_Pre($grpc.ServiceCall call, $async.Future<$0.ListSessionsRequest> request) async {
    return listSessions(call, await request);
  }

  $async.Future<$0.EndSessionResponse> endSession_Pre($grpc.ServiceCall call, $async.Future<$0.EndSessionRequest> request) async {
    return endSession(call, await request);
  }

  $async.Future<$0.SignalResponse> sendWebRTCSignal_Pre($grpc.ServiceCall call, $async.Future<$0.WebRTCSignal> request) async {
    return sendWebRTCSignal(call, await request);
  }

  $async.Stream<$0.WebRTCSignal> watchWebRTCSignals_Pre($grpc.ServiceCall call, $async.Future<$0.WatchSignalsRequest> request) async* {
    yield* watchWebRTCSignals(call, await request);
  }

  $async.Future<$0.HeartbeatResponse> heartbeat_Pre($grpc.ServiceCall call, $async.Future<$0.HeartbeatRequest> request) async {
    return heartbeat(call, await request);
  }

  $async.Future<$0.RequestConnectionResponse> requestConnection_Pre($grpc.ServiceCall call, $async.Future<$0.RequestConnectionRequest> request) async {
    return requestConnection(call, await request);
  }

  $async.Future<$0.ApproveConnectionResponse> approveConnection_Pre($grpc.ServiceCall call, $async.Future<$0.ApproveConnectionRequest> request) async {
    return approveConnection(call, await request);
  }

  $async.Future<$0.DenyConnectionResponse> denyConnection_Pre($grpc.ServiceCall call, $async.Future<$0.DenyConnectionRequest> request) async {
    return denyConnection(call, await request);
  }

  $async.Stream<$0.ConnectionRequestNotification> watchConnectionRequests_Pre($grpc.ServiceCall call, $async.Future<$0.WatchConnectionRequestsRequest> request) async* {
    yield* watchConnectionRequests(call, await request);
  }

  $async.Stream<$0.ApprovalStatusUpdate> watchApprovalStatus_Pre($grpc.ServiceCall call, $async.Future<$0.WatchApprovalStatusRequest> request) async* {
    yield* watchApprovalStatus(call, await request);
  }

  $async.Future<$0.SessionResponse> createSession($grpc.ServiceCall call, $0.CreateSessionRequest request);
  $async.Future<$0.ListSessionsResponse> listSessions($grpc.ServiceCall call, $0.ListSessionsRequest request);
  $async.Future<$0.EndSessionResponse> endSession($grpc.ServiceCall call, $0.EndSessionRequest request);
  $async.Future<$0.SignalResponse> sendWebRTCSignal($grpc.ServiceCall call, $0.WebRTCSignal request);
  $async.Stream<$0.WebRTCSignal> watchWebRTCSignals($grpc.ServiceCall call, $0.WatchSignalsRequest request);
  $async.Stream<$0.ProviderCommand> providerStream($grpc.ServiceCall call, $async.Stream<$0.ProviderMessage> request);
  $async.Stream<$0.VideoFrame> consumerStream($grpc.ServiceCall call, $async.Stream<$0.ConsumerCommand> request);
  $async.Future<$0.HeartbeatResponse> heartbeat($grpc.ServiceCall call, $0.HeartbeatRequest request);
  $async.Future<$0.RequestConnectionResponse> requestConnection($grpc.ServiceCall call, $0.RequestConnectionRequest request);
  $async.Future<$0.ApproveConnectionResponse> approveConnection($grpc.ServiceCall call, $0.ApproveConnectionRequest request);
  $async.Future<$0.DenyConnectionResponse> denyConnection($grpc.ServiceCall call, $0.DenyConnectionRequest request);
  $async.Stream<$0.ConnectionRequestNotification> watchConnectionRequests($grpc.ServiceCall call, $0.WatchConnectionRequestsRequest request);
  $async.Stream<$0.ApprovalStatusUpdate> watchApprovalStatus($grpc.ServiceCall call, $0.WatchApprovalStatusRequest request);
}
