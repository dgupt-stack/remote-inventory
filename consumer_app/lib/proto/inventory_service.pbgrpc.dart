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

@$pb.GrpcServiceName('inventory.RemoteInventoryService')
class RemoteInventoryServiceClient extends $grpc.Client {
  static final _$createSession = $grpc.ClientMethod<$0.CreateSessionRequest, $0.SessionResponse>(
      '/inventory.RemoteInventoryService/CreateSession',
      ($0.CreateSessionRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.SessionResponse.fromBuffer(value));
  static final _$listSessions = $grpc.ClientMethod<$0.ListSessionsRequest, $0.ListSessionsResponse>(
      '/inventory.RemoteInventoryService/ListSessions',
      ($0.ListSessionsRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.ListSessionsResponse.fromBuffer(value));
  static final _$requestConnection = $grpc.ClientMethod<$0.ConnectionRequest, $0.ConnectionResponse>(
      '/inventory.RemoteInventoryService/RequestConnection',
      ($0.ConnectionRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.ConnectionResponse.fromBuffer(value));
  static final _$watchConnectionRequests = $grpc.ClientMethod<$0.WatchRequestsRequest, $0.ConnectionRequestNotification>(
      '/inventory.RemoteInventoryService/WatchConnectionRequests',
      ($0.WatchRequestsRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.ConnectionRequestNotification.fromBuffer(value));
  static final _$approveConnection = $grpc.ClientMethod<$0.ApproveRequest, $0.ApproveResponse>(
      '/inventory.RemoteInventoryService/ApproveConnection',
      ($0.ApproveRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.ApproveResponse.fromBuffer(value));
  static final _$denyConnection = $grpc.ClientMethod<$0.DenyRequest, $0.DenyResponse>(
      '/inventory.RemoteInventoryService/DenyConnection',
      ($0.DenyRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.DenyResponse.fromBuffer(value));
  static final _$watchApprovalStatus = $grpc.ClientMethod<$0.WatchApprovalRequest, $0.ApprovalStatusUpdate>(
      '/inventory.RemoteInventoryService/WatchApprovalStatus',
      ($0.WatchApprovalRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.ApprovalStatusUpdate.fromBuffer(value));
  static final _$streamVideo = $grpc.ClientMethod<$0.VideoFrame, $0.VideoFrame>(
      '/inventory.RemoteInventoryService/StreamVideo',
      ($0.VideoFrame value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.VideoFrame.fromBuffer(value));
  static final _$sendCommand = $grpc.ClientMethod<$0.Command, $0.CommandResponse>(
      '/inventory.RemoteInventoryService/SendCommand',
      ($0.Command value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.CommandResponse.fromBuffer(value));
  static final _$endSession = $grpc.ClientMethod<$0.EndSessionRequest, $0.EndSessionResponse>(
      '/inventory.RemoteInventoryService/EndSession',
      ($0.EndSessionRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.EndSessionResponse.fromBuffer(value));
  static final _$providerStream = $grpc.ClientMethod<$0.ProviderMessage, $0.ProviderCommand>(
      '/inventory.RemoteInventoryService/ProviderStream',
      ($0.ProviderMessage value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.ProviderCommand.fromBuffer(value));
  static final _$consumerStream = $grpc.ClientMethod<$0.ConsumerCommand, $0.VideoFrame>(
      '/inventory.RemoteInventoryService/ConsumerStream',
      ($0.ConsumerCommand value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.VideoFrame.fromBuffer(value));
  static final _$heartbeat = $grpc.ClientMethod<$0.HeartbeatRequest, $0.HeartbeatResponse>(
      '/inventory.RemoteInventoryService/Heartbeat',
      ($0.HeartbeatRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.HeartbeatResponse.fromBuffer(value));

  RemoteInventoryServiceClient($grpc.ClientChannel channel,
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

  $grpc.ResponseFuture<$0.ConnectionResponse> requestConnection($0.ConnectionRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$requestConnection, request, options: options);
  }

  $grpc.ResponseStream<$0.ConnectionRequestNotification> watchConnectionRequests($0.WatchRequestsRequest request, {$grpc.CallOptions? options}) {
    return $createStreamingCall(_$watchConnectionRequests, $async.Stream.fromIterable([request]), options: options);
  }

  $grpc.ResponseFuture<$0.ApproveResponse> approveConnection($0.ApproveRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$approveConnection, request, options: options);
  }

  $grpc.ResponseFuture<$0.DenyResponse> denyConnection($0.DenyRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$denyConnection, request, options: options);
  }

  $grpc.ResponseStream<$0.ApprovalStatusUpdate> watchApprovalStatus($0.WatchApprovalRequest request, {$grpc.CallOptions? options}) {
    return $createStreamingCall(_$watchApprovalStatus, $async.Stream.fromIterable([request]), options: options);
  }

  $grpc.ResponseStream<$0.VideoFrame> streamVideo($async.Stream<$0.VideoFrame> request, {$grpc.CallOptions? options}) {
    return $createStreamingCall(_$streamVideo, request, options: options);
  }

  $grpc.ResponseFuture<$0.CommandResponse> sendCommand($0.Command request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$sendCommand, request, options: options);
  }

  $grpc.ResponseFuture<$0.EndSessionResponse> endSession($0.EndSessionRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$endSession, request, options: options);
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
}

@$pb.GrpcServiceName('inventory.RemoteInventoryService')
abstract class RemoteInventoryServiceBase extends $grpc.Service {
  $core.String get $name => 'inventory.RemoteInventoryService';

  RemoteInventoryServiceBase() {
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
    $addMethod($grpc.ServiceMethod<$0.ConnectionRequest, $0.ConnectionResponse>(
        'RequestConnection',
        requestConnection_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.ConnectionRequest.fromBuffer(value),
        ($0.ConnectionResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.WatchRequestsRequest, $0.ConnectionRequestNotification>(
        'WatchConnectionRequests',
        watchConnectionRequests_Pre,
        false,
        true,
        ($core.List<$core.int> value) => $0.WatchRequestsRequest.fromBuffer(value),
        ($0.ConnectionRequestNotification value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ApproveRequest, $0.ApproveResponse>(
        'ApproveConnection',
        approveConnection_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.ApproveRequest.fromBuffer(value),
        ($0.ApproveResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.DenyRequest, $0.DenyResponse>(
        'DenyConnection',
        denyConnection_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.DenyRequest.fromBuffer(value),
        ($0.DenyResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.WatchApprovalRequest, $0.ApprovalStatusUpdate>(
        'WatchApprovalStatus',
        watchApprovalStatus_Pre,
        false,
        true,
        ($core.List<$core.int> value) => $0.WatchApprovalRequest.fromBuffer(value),
        ($0.ApprovalStatusUpdate value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.VideoFrame, $0.VideoFrame>(
        'StreamVideo',
        streamVideo,
        true,
        true,
        ($core.List<$core.int> value) => $0.VideoFrame.fromBuffer(value),
        ($0.VideoFrame value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Command, $0.CommandResponse>(
        'SendCommand',
        sendCommand_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Command.fromBuffer(value),
        ($0.CommandResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.EndSessionRequest, $0.EndSessionResponse>(
        'EndSession',
        endSession_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.EndSessionRequest.fromBuffer(value),
        ($0.EndSessionResponse value) => value.writeToBuffer()));
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
  }

  $async.Future<$0.SessionResponse> createSession_Pre($grpc.ServiceCall call, $async.Future<$0.CreateSessionRequest> request) async {
    return createSession(call, await request);
  }

  $async.Future<$0.ListSessionsResponse> listSessions_Pre($grpc.ServiceCall call, $async.Future<$0.ListSessionsRequest> request) async {
    return listSessions(call, await request);
  }

  $async.Future<$0.ConnectionResponse> requestConnection_Pre($grpc.ServiceCall call, $async.Future<$0.ConnectionRequest> request) async {
    return requestConnection(call, await request);
  }

  $async.Stream<$0.ConnectionRequestNotification> watchConnectionRequests_Pre($grpc.ServiceCall call, $async.Future<$0.WatchRequestsRequest> request) async* {
    yield* watchConnectionRequests(call, await request);
  }

  $async.Future<$0.ApproveResponse> approveConnection_Pre($grpc.ServiceCall call, $async.Future<$0.ApproveRequest> request) async {
    return approveConnection(call, await request);
  }

  $async.Future<$0.DenyResponse> denyConnection_Pre($grpc.ServiceCall call, $async.Future<$0.DenyRequest> request) async {
    return denyConnection(call, await request);
  }

  $async.Stream<$0.ApprovalStatusUpdate> watchApprovalStatus_Pre($grpc.ServiceCall call, $async.Future<$0.WatchApprovalRequest> request) async* {
    yield* watchApprovalStatus(call, await request);
  }

  $async.Future<$0.CommandResponse> sendCommand_Pre($grpc.ServiceCall call, $async.Future<$0.Command> request) async {
    return sendCommand(call, await request);
  }

  $async.Future<$0.EndSessionResponse> endSession_Pre($grpc.ServiceCall call, $async.Future<$0.EndSessionRequest> request) async {
    return endSession(call, await request);
  }

  $async.Future<$0.HeartbeatResponse> heartbeat_Pre($grpc.ServiceCall call, $async.Future<$0.HeartbeatRequest> request) async {
    return heartbeat(call, await request);
  }

  $async.Future<$0.SessionResponse> createSession($grpc.ServiceCall call, $0.CreateSessionRequest request);
  $async.Future<$0.ListSessionsResponse> listSessions($grpc.ServiceCall call, $0.ListSessionsRequest request);
  $async.Future<$0.ConnectionResponse> requestConnection($grpc.ServiceCall call, $0.ConnectionRequest request);
  $async.Stream<$0.ConnectionRequestNotification> watchConnectionRequests($grpc.ServiceCall call, $0.WatchRequestsRequest request);
  $async.Future<$0.ApproveResponse> approveConnection($grpc.ServiceCall call, $0.ApproveRequest request);
  $async.Future<$0.DenyResponse> denyConnection($grpc.ServiceCall call, $0.DenyRequest request);
  $async.Stream<$0.ApprovalStatusUpdate> watchApprovalStatus($grpc.ServiceCall call, $0.WatchApprovalRequest request);
  $async.Stream<$0.VideoFrame> streamVideo($grpc.ServiceCall call, $async.Stream<$0.VideoFrame> request);
  $async.Future<$0.CommandResponse> sendCommand($grpc.ServiceCall call, $0.Command request);
  $async.Future<$0.EndSessionResponse> endSession($grpc.ServiceCall call, $0.EndSessionRequest request);
  $async.Stream<$0.ProviderCommand> providerStream($grpc.ServiceCall call, $async.Stream<$0.ProviderMessage> request);
  $async.Stream<$0.VideoFrame> consumerStream($grpc.ServiceCall call, $async.Stream<$0.ConsumerCommand> request);
  $async.Future<$0.HeartbeatResponse> heartbeat($grpc.ServiceCall call, $0.HeartbeatRequest request);
}
