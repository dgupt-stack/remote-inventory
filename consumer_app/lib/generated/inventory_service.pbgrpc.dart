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
  static final _$joinSession = $grpc.ClientMethod<$0.JoinSessionRequest, $0.SessionResponse>(
      '/inventory.InventoryService/JoinSession',
      ($0.JoinSessionRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.SessionResponse.fromBuffer(value));
  static final _$endSession = $grpc.ClientMethod<$0.EndSessionRequest, $0.EndSessionResponse>(
      '/inventory.InventoryService/EndSession',
      ($0.EndSessionRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.EndSessionResponse.fromBuffer(value));
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

  InventoryServiceClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options,
        interceptors: interceptors);

  $grpc.ResponseFuture<$0.SessionResponse> createSession($0.CreateSessionRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$createSession, request, options: options);
  }

  $grpc.ResponseFuture<$0.SessionResponse> joinSession($0.JoinSessionRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$joinSession, request, options: options);
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
    $addMethod($grpc.ServiceMethod<$0.JoinSessionRequest, $0.SessionResponse>(
        'JoinSession',
        joinSession_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.JoinSessionRequest.fromBuffer(value),
        ($0.SessionResponse value) => value.writeToBuffer()));
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

  $async.Future<$0.SessionResponse> joinSession_Pre($grpc.ServiceCall call, $async.Future<$0.JoinSessionRequest> request) async {
    return joinSession(call, await request);
  }

  $async.Future<$0.EndSessionResponse> endSession_Pre($grpc.ServiceCall call, $async.Future<$0.EndSessionRequest> request) async {
    return endSession(call, await request);
  }

  $async.Future<$0.HeartbeatResponse> heartbeat_Pre($grpc.ServiceCall call, $async.Future<$0.HeartbeatRequest> request) async {
    return heartbeat(call, await request);
  }

  $async.Future<$0.SessionResponse> createSession($grpc.ServiceCall call, $0.CreateSessionRequest request);
  $async.Future<$0.SessionResponse> joinSession($grpc.ServiceCall call, $0.JoinSessionRequest request);
  $async.Future<$0.EndSessionResponse> endSession($grpc.ServiceCall call, $0.EndSessionRequest request);
  $async.Stream<$0.ProviderCommand> providerStream($grpc.ServiceCall call, $async.Stream<$0.ProviderMessage> request);
  $async.Stream<$0.VideoFrame> consumerStream($grpc.ServiceCall call, $async.Stream<$0.ConsumerCommand> request);
  $async.Future<$0.HeartbeatResponse> heartbeat($grpc.ServiceCall call, $0.HeartbeatRequest request);
}
