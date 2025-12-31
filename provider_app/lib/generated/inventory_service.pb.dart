//
//  Generated code. Do not modify.
//  source: inventory_service.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'inventory_service.pbenum.dart';

export 'inventory_service.pbenum.dart';

/// Session messages
class CreateSessionRequest extends $pb.GeneratedMessage {
  factory CreateSessionRequest({
    $core.String? providerId,
    $core.String? providerName,
  }) {
    final $result = create();
    if (providerId != null) {
      $result.providerId = providerId;
    }
    if (providerName != null) {
      $result.providerName = providerName;
    }
    return $result;
  }
  CreateSessionRequest._() : super();
  factory CreateSessionRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CreateSessionRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CreateSessionRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'inventory'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'providerId')
    ..aOS(2, _omitFieldNames ? '' : 'providerName')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CreateSessionRequest clone() => CreateSessionRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CreateSessionRequest copyWith(void Function(CreateSessionRequest) updates) => super.copyWith((message) => updates(message as CreateSessionRequest)) as CreateSessionRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateSessionRequest create() => CreateSessionRequest._();
  CreateSessionRequest createEmptyInstance() => create();
  static $pb.PbList<CreateSessionRequest> createRepeated() => $pb.PbList<CreateSessionRequest>();
  @$core.pragma('dart2js:noInline')
  static CreateSessionRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CreateSessionRequest>(create);
  static CreateSessionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get providerId => $_getSZ(0);
  @$pb.TagNumber(1)
  set providerId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasProviderId() => $_has(0);
  @$pb.TagNumber(1)
  void clearProviderId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get providerName => $_getSZ(1);
  @$pb.TagNumber(2)
  set providerName($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasProviderName() => $_has(1);
  @$pb.TagNumber(2)
  void clearProviderName() => clearField(2);
}

class JoinSessionRequest extends $pb.GeneratedMessage {
  factory JoinSessionRequest({
    $core.String? sessionId,
    $core.String? consumerId,
    $core.String? consumerName,
  }) {
    final $result = create();
    if (sessionId != null) {
      $result.sessionId = sessionId;
    }
    if (consumerId != null) {
      $result.consumerId = consumerId;
    }
    if (consumerName != null) {
      $result.consumerName = consumerName;
    }
    return $result;
  }
  JoinSessionRequest._() : super();
  factory JoinSessionRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory JoinSessionRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'JoinSessionRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'inventory'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'sessionId')
    ..aOS(2, _omitFieldNames ? '' : 'consumerId')
    ..aOS(3, _omitFieldNames ? '' : 'consumerName')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  JoinSessionRequest clone() => JoinSessionRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  JoinSessionRequest copyWith(void Function(JoinSessionRequest) updates) => super.copyWith((message) => updates(message as JoinSessionRequest)) as JoinSessionRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static JoinSessionRequest create() => JoinSessionRequest._();
  JoinSessionRequest createEmptyInstance() => create();
  static $pb.PbList<JoinSessionRequest> createRepeated() => $pb.PbList<JoinSessionRequest>();
  @$core.pragma('dart2js:noInline')
  static JoinSessionRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<JoinSessionRequest>(create);
  static JoinSessionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get consumerId => $_getSZ(1);
  @$pb.TagNumber(2)
  set consumerId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasConsumerId() => $_has(1);
  @$pb.TagNumber(2)
  void clearConsumerId() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get consumerName => $_getSZ(2);
  @$pb.TagNumber(3)
  set consumerName($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasConsumerName() => $_has(2);
  @$pb.TagNumber(3)
  void clearConsumerName() => clearField(3);
}

class SessionResponse extends $pb.GeneratedMessage {
  factory SessionResponse({
    $core.String? sessionId,
    $core.String? token,
    $core.bool? success,
    $core.String? message,
  }) {
    final $result = create();
    if (sessionId != null) {
      $result.sessionId = sessionId;
    }
    if (token != null) {
      $result.token = token;
    }
    if (success != null) {
      $result.success = success;
    }
    if (message != null) {
      $result.message = message;
    }
    return $result;
  }
  SessionResponse._() : super();
  factory SessionResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SessionResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SessionResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'inventory'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'sessionId')
    ..aOS(2, _omitFieldNames ? '' : 'token')
    ..aOB(3, _omitFieldNames ? '' : 'success')
    ..aOS(4, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SessionResponse clone() => SessionResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SessionResponse copyWith(void Function(SessionResponse) updates) => super.copyWith((message) => updates(message as SessionResponse)) as SessionResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SessionResponse create() => SessionResponse._();
  SessionResponse createEmptyInstance() => create();
  static $pb.PbList<SessionResponse> createRepeated() => $pb.PbList<SessionResponse>();
  @$core.pragma('dart2js:noInline')
  static SessionResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SessionResponse>(create);
  static SessionResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get token => $_getSZ(1);
  @$pb.TagNumber(2)
  set token($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasToken() => $_has(1);
  @$pb.TagNumber(2)
  void clearToken() => clearField(2);

  @$pb.TagNumber(3)
  $core.bool get success => $_getBF(2);
  @$pb.TagNumber(3)
  set success($core.bool v) { $_setBool(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasSuccess() => $_has(2);
  @$pb.TagNumber(3)
  void clearSuccess() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get message => $_getSZ(3);
  @$pb.TagNumber(4)
  set message($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasMessage() => $_has(3);
  @$pb.TagNumber(4)
  void clearMessage() => clearField(4);
}

class EndSessionRequest extends $pb.GeneratedMessage {
  factory EndSessionRequest({
    $core.String? sessionId,
    $core.String? token,
  }) {
    final $result = create();
    if (sessionId != null) {
      $result.sessionId = sessionId;
    }
    if (token != null) {
      $result.token = token;
    }
    return $result;
  }
  EndSessionRequest._() : super();
  factory EndSessionRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory EndSessionRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'EndSessionRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'inventory'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'sessionId')
    ..aOS(2, _omitFieldNames ? '' : 'token')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  EndSessionRequest clone() => EndSessionRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  EndSessionRequest copyWith(void Function(EndSessionRequest) updates) => super.copyWith((message) => updates(message as EndSessionRequest)) as EndSessionRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EndSessionRequest create() => EndSessionRequest._();
  EndSessionRequest createEmptyInstance() => create();
  static $pb.PbList<EndSessionRequest> createRepeated() => $pb.PbList<EndSessionRequest>();
  @$core.pragma('dart2js:noInline')
  static EndSessionRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<EndSessionRequest>(create);
  static EndSessionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get token => $_getSZ(1);
  @$pb.TagNumber(2)
  set token($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasToken() => $_has(1);
  @$pb.TagNumber(2)
  void clearToken() => clearField(2);
}

class EndSessionResponse extends $pb.GeneratedMessage {
  factory EndSessionResponse({
    $core.bool? success,
  }) {
    final $result = create();
    if (success != null) {
      $result.success = success;
    }
    return $result;
  }
  EndSessionResponse._() : super();
  factory EndSessionResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory EndSessionResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'EndSessionResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'inventory'), createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  EndSessionResponse clone() => EndSessionResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  EndSessionResponse copyWith(void Function(EndSessionResponse) updates) => super.copyWith((message) => updates(message as EndSessionResponse)) as EndSessionResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EndSessionResponse create() => EndSessionResponse._();
  EndSessionResponse createEmptyInstance() => create();
  static $pb.PbList<EndSessionResponse> createRepeated() => $pb.PbList<EndSessionResponse>();
  @$core.pragma('dart2js:noInline')
  static EndSessionResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<EndSessionResponse>(create);
  static EndSessionResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool v) { $_setBool(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => clearField(1);
}

enum ProviderMessage_Payload {
  videoFrame, 
  sensorData, 
  status, 
  notSet
}

/// Provider messages
class ProviderMessage extends $pb.GeneratedMessage {
  factory ProviderMessage({
    $core.String? sessionId,
    $core.String? token,
    VideoFrame? videoFrame,
    SensorData? sensorData,
    ProviderStatus? status,
  }) {
    final $result = create();
    if (sessionId != null) {
      $result.sessionId = sessionId;
    }
    if (token != null) {
      $result.token = token;
    }
    if (videoFrame != null) {
      $result.videoFrame = videoFrame;
    }
    if (sensorData != null) {
      $result.sensorData = sensorData;
    }
    if (status != null) {
      $result.status = status;
    }
    return $result;
  }
  ProviderMessage._() : super();
  factory ProviderMessage.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ProviderMessage.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static const $core.Map<$core.int, ProviderMessage_Payload> _ProviderMessage_PayloadByTag = {
    3 : ProviderMessage_Payload.videoFrame,
    4 : ProviderMessage_Payload.sensorData,
    5 : ProviderMessage_Payload.status,
    0 : ProviderMessage_Payload.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ProviderMessage', package: const $pb.PackageName(_omitMessageNames ? '' : 'inventory'), createEmptyInstance: create)
    ..oo(0, [3, 4, 5])
    ..aOS(1, _omitFieldNames ? '' : 'sessionId')
    ..aOS(2, _omitFieldNames ? '' : 'token')
    ..aOM<VideoFrame>(3, _omitFieldNames ? '' : 'videoFrame', subBuilder: VideoFrame.create)
    ..aOM<SensorData>(4, _omitFieldNames ? '' : 'sensorData', subBuilder: SensorData.create)
    ..aOM<ProviderStatus>(5, _omitFieldNames ? '' : 'status', subBuilder: ProviderStatus.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ProviderMessage clone() => ProviderMessage()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ProviderMessage copyWith(void Function(ProviderMessage) updates) => super.copyWith((message) => updates(message as ProviderMessage)) as ProviderMessage;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ProviderMessage create() => ProviderMessage._();
  ProviderMessage createEmptyInstance() => create();
  static $pb.PbList<ProviderMessage> createRepeated() => $pb.PbList<ProviderMessage>();
  @$core.pragma('dart2js:noInline')
  static ProviderMessage getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ProviderMessage>(create);
  static ProviderMessage? _defaultInstance;

  ProviderMessage_Payload whichPayload() => _ProviderMessage_PayloadByTag[$_whichOneof(0)]!;
  void clearPayload() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $core.String get sessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get token => $_getSZ(1);
  @$pb.TagNumber(2)
  set token($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasToken() => $_has(1);
  @$pb.TagNumber(2)
  void clearToken() => clearField(2);

  @$pb.TagNumber(3)
  VideoFrame get videoFrame => $_getN(2);
  @$pb.TagNumber(3)
  set videoFrame(VideoFrame v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasVideoFrame() => $_has(2);
  @$pb.TagNumber(3)
  void clearVideoFrame() => clearField(3);
  @$pb.TagNumber(3)
  VideoFrame ensureVideoFrame() => $_ensure(2);

  @$pb.TagNumber(4)
  SensorData get sensorData => $_getN(3);
  @$pb.TagNumber(4)
  set sensorData(SensorData v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasSensorData() => $_has(3);
  @$pb.TagNumber(4)
  void clearSensorData() => clearField(4);
  @$pb.TagNumber(4)
  SensorData ensureSensorData() => $_ensure(3);

  @$pb.TagNumber(5)
  ProviderStatus get status => $_getN(4);
  @$pb.TagNumber(5)
  set status(ProviderStatus v) { setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasStatus() => $_has(4);
  @$pb.TagNumber(5)
  void clearStatus() => clearField(5);
  @$pb.TagNumber(5)
  ProviderStatus ensureStatus() => $_ensure(4);
}

class VideoFrame extends $pb.GeneratedMessage {
  factory VideoFrame({
    $core.List<$core.int>? frameData,
    $fixnum.Int64? timestampMs,
    $core.int? width,
    $core.int? height,
    $core.bool? isBlurred,
  }) {
    final $result = create();
    if (frameData != null) {
      $result.frameData = frameData;
    }
    if (timestampMs != null) {
      $result.timestampMs = timestampMs;
    }
    if (width != null) {
      $result.width = width;
    }
    if (height != null) {
      $result.height = height;
    }
    if (isBlurred != null) {
      $result.isBlurred = isBlurred;
    }
    return $result;
  }
  VideoFrame._() : super();
  factory VideoFrame.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory VideoFrame.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'VideoFrame', package: const $pb.PackageName(_omitMessageNames ? '' : 'inventory'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'frameData', $pb.PbFieldType.OY)
    ..aInt64(2, _omitFieldNames ? '' : 'timestampMs')
    ..a<$core.int>(3, _omitFieldNames ? '' : 'width', $pb.PbFieldType.O3)
    ..a<$core.int>(4, _omitFieldNames ? '' : 'height', $pb.PbFieldType.O3)
    ..aOB(5, _omitFieldNames ? '' : 'isBlurred')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  VideoFrame clone() => VideoFrame()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  VideoFrame copyWith(void Function(VideoFrame) updates) => super.copyWith((message) => updates(message as VideoFrame)) as VideoFrame;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static VideoFrame create() => VideoFrame._();
  VideoFrame createEmptyInstance() => create();
  static $pb.PbList<VideoFrame> createRepeated() => $pb.PbList<VideoFrame>();
  @$core.pragma('dart2js:noInline')
  static VideoFrame getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<VideoFrame>(create);
  static VideoFrame? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get frameData => $_getN(0);
  @$pb.TagNumber(1)
  set frameData($core.List<$core.int> v) { $_setBytes(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasFrameData() => $_has(0);
  @$pb.TagNumber(1)
  void clearFrameData() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get timestampMs => $_getI64(1);
  @$pb.TagNumber(2)
  set timestampMs($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasTimestampMs() => $_has(1);
  @$pb.TagNumber(2)
  void clearTimestampMs() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get width => $_getIZ(2);
  @$pb.TagNumber(3)
  set width($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasWidth() => $_has(2);
  @$pb.TagNumber(3)
  void clearWidth() => clearField(3);

  @$pb.TagNumber(4)
  $core.int get height => $_getIZ(3);
  @$pb.TagNumber(4)
  set height($core.int v) { $_setSignedInt32(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasHeight() => $_has(3);
  @$pb.TagNumber(4)
  void clearHeight() => clearField(4);

  @$pb.TagNumber(5)
  $core.bool get isBlurred => $_getBF(4);
  @$pb.TagNumber(5)
  set isBlurred($core.bool v) { $_setBool(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasIsBlurred() => $_has(4);
  @$pb.TagNumber(5)
  void clearIsBlurred() => clearField(5);
}

class SensorData extends $pb.GeneratedMessage {
  factory SensorData({
    $core.double? accelerometerX,
    $core.double? accelerometerY,
    $core.double? accelerometerZ,
    $core.double? compassHeading,
    $core.double? gyroscopeX,
    $core.double? gyroscopeY,
    $core.double? gyroscopeZ,
  }) {
    final $result = create();
    if (accelerometerX != null) {
      $result.accelerometerX = accelerometerX;
    }
    if (accelerometerY != null) {
      $result.accelerometerY = accelerometerY;
    }
    if (accelerometerZ != null) {
      $result.accelerometerZ = accelerometerZ;
    }
    if (compassHeading != null) {
      $result.compassHeading = compassHeading;
    }
    if (gyroscopeX != null) {
      $result.gyroscopeX = gyroscopeX;
    }
    if (gyroscopeY != null) {
      $result.gyroscopeY = gyroscopeY;
    }
    if (gyroscopeZ != null) {
      $result.gyroscopeZ = gyroscopeZ;
    }
    return $result;
  }
  SensorData._() : super();
  factory SensorData.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SensorData.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SensorData', package: const $pb.PackageName(_omitMessageNames ? '' : 'inventory'), createEmptyInstance: create)
    ..a<$core.double>(1, _omitFieldNames ? '' : 'accelerometerX', $pb.PbFieldType.OF)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'accelerometerY', $pb.PbFieldType.OF)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'accelerometerZ', $pb.PbFieldType.OF)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'compassHeading', $pb.PbFieldType.OF)
    ..a<$core.double>(5, _omitFieldNames ? '' : 'gyroscopeX', $pb.PbFieldType.OF)
    ..a<$core.double>(6, _omitFieldNames ? '' : 'gyroscopeY', $pb.PbFieldType.OF)
    ..a<$core.double>(7, _omitFieldNames ? '' : 'gyroscopeZ', $pb.PbFieldType.OF)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SensorData clone() => SensorData()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SensorData copyWith(void Function(SensorData) updates) => super.copyWith((message) => updates(message as SensorData)) as SensorData;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SensorData create() => SensorData._();
  SensorData createEmptyInstance() => create();
  static $pb.PbList<SensorData> createRepeated() => $pb.PbList<SensorData>();
  @$core.pragma('dart2js:noInline')
  static SensorData getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SensorData>(create);
  static SensorData? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get accelerometerX => $_getN(0);
  @$pb.TagNumber(1)
  set accelerometerX($core.double v) { $_setFloat(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasAccelerometerX() => $_has(0);
  @$pb.TagNumber(1)
  void clearAccelerometerX() => clearField(1);

  @$pb.TagNumber(2)
  $core.double get accelerometerY => $_getN(1);
  @$pb.TagNumber(2)
  set accelerometerY($core.double v) { $_setFloat(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasAccelerometerY() => $_has(1);
  @$pb.TagNumber(2)
  void clearAccelerometerY() => clearField(2);

  @$pb.TagNumber(3)
  $core.double get accelerometerZ => $_getN(2);
  @$pb.TagNumber(3)
  set accelerometerZ($core.double v) { $_setFloat(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasAccelerometerZ() => $_has(2);
  @$pb.TagNumber(3)
  void clearAccelerometerZ() => clearField(3);

  @$pb.TagNumber(4)
  $core.double get compassHeading => $_getN(3);
  @$pb.TagNumber(4)
  set compassHeading($core.double v) { $_setFloat(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasCompassHeading() => $_has(3);
  @$pb.TagNumber(4)
  void clearCompassHeading() => clearField(4);

  @$pb.TagNumber(5)
  $core.double get gyroscopeX => $_getN(4);
  @$pb.TagNumber(5)
  set gyroscopeX($core.double v) { $_setFloat(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasGyroscopeX() => $_has(4);
  @$pb.TagNumber(5)
  void clearGyroscopeX() => clearField(5);

  @$pb.TagNumber(6)
  $core.double get gyroscopeY => $_getN(5);
  @$pb.TagNumber(6)
  set gyroscopeY($core.double v) { $_setFloat(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasGyroscopeY() => $_has(5);
  @$pb.TagNumber(6)
  void clearGyroscopeY() => clearField(6);

  @$pb.TagNumber(7)
  $core.double get gyroscopeZ => $_getN(6);
  @$pb.TagNumber(7)
  set gyroscopeZ($core.double v) { $_setFloat(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasGyroscopeZ() => $_has(6);
  @$pb.TagNumber(7)
  void clearGyroscopeZ() => clearField(7);
}

class ProviderStatus extends $pb.GeneratedMessage {
  factory ProviderStatus({
    $core.bool? cameraActive,
    $core.int? batteryLevel,
  }) {
    final $result = create();
    if (cameraActive != null) {
      $result.cameraActive = cameraActive;
    }
    if (batteryLevel != null) {
      $result.batteryLevel = batteryLevel;
    }
    return $result;
  }
  ProviderStatus._() : super();
  factory ProviderStatus.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ProviderStatus.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ProviderStatus', package: const $pb.PackageName(_omitMessageNames ? '' : 'inventory'), createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'cameraActive')
    ..a<$core.int>(2, _omitFieldNames ? '' : 'batteryLevel', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ProviderStatus clone() => ProviderStatus()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ProviderStatus copyWith(void Function(ProviderStatus) updates) => super.copyWith((message) => updates(message as ProviderStatus)) as ProviderStatus;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ProviderStatus create() => ProviderStatus._();
  ProviderStatus createEmptyInstance() => create();
  static $pb.PbList<ProviderStatus> createRepeated() => $pb.PbList<ProviderStatus>();
  @$core.pragma('dart2js:noInline')
  static ProviderStatus getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ProviderStatus>(create);
  static ProviderStatus? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get cameraActive => $_getBF(0);
  @$pb.TagNumber(1)
  set cameraActive($core.bool v) { $_setBool(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCameraActive() => $_has(0);
  @$pb.TagNumber(1)
  void clearCameraActive() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get batteryLevel => $_getIZ(1);
  @$pb.TagNumber(2)
  set batteryLevel($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasBatteryLevel() => $_has(1);
  @$pb.TagNumber(2)
  void clearBatteryLevel() => clearField(2);
}

enum ProviderCommand_Command {
  navigation, 
  laser, 
  stop, 
  zoom, 
  notSet
}

/// Provider receives commands from Consumer
class ProviderCommand extends $pb.GeneratedMessage {
  factory ProviderCommand({
    NavigationCommand? navigation,
    LaserCommand? laser,
    StopCommand? stop,
    ZoomCommand? zoom,
  }) {
    final $result = create();
    if (navigation != null) {
      $result.navigation = navigation;
    }
    if (laser != null) {
      $result.laser = laser;
    }
    if (stop != null) {
      $result.stop = stop;
    }
    if (zoom != null) {
      $result.zoom = zoom;
    }
    return $result;
  }
  ProviderCommand._() : super();
  factory ProviderCommand.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ProviderCommand.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static const $core.Map<$core.int, ProviderCommand_Command> _ProviderCommand_CommandByTag = {
    1 : ProviderCommand_Command.navigation,
    2 : ProviderCommand_Command.laser,
    3 : ProviderCommand_Command.stop,
    4 : ProviderCommand_Command.zoom,
    0 : ProviderCommand_Command.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ProviderCommand', package: const $pb.PackageName(_omitMessageNames ? '' : 'inventory'), createEmptyInstance: create)
    ..oo(0, [1, 2, 3, 4])
    ..aOM<NavigationCommand>(1, _omitFieldNames ? '' : 'navigation', subBuilder: NavigationCommand.create)
    ..aOM<LaserCommand>(2, _omitFieldNames ? '' : 'laser', subBuilder: LaserCommand.create)
    ..aOM<StopCommand>(3, _omitFieldNames ? '' : 'stop', subBuilder: StopCommand.create)
    ..aOM<ZoomCommand>(4, _omitFieldNames ? '' : 'zoom', subBuilder: ZoomCommand.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ProviderCommand clone() => ProviderCommand()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ProviderCommand copyWith(void Function(ProviderCommand) updates) => super.copyWith((message) => updates(message as ProviderCommand)) as ProviderCommand;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ProviderCommand create() => ProviderCommand._();
  ProviderCommand createEmptyInstance() => create();
  static $pb.PbList<ProviderCommand> createRepeated() => $pb.PbList<ProviderCommand>();
  @$core.pragma('dart2js:noInline')
  static ProviderCommand getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ProviderCommand>(create);
  static ProviderCommand? _defaultInstance;

  ProviderCommand_Command whichCommand() => _ProviderCommand_CommandByTag[$_whichOneof(0)]!;
  void clearCommand() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  NavigationCommand get navigation => $_getN(0);
  @$pb.TagNumber(1)
  set navigation(NavigationCommand v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasNavigation() => $_has(0);
  @$pb.TagNumber(1)
  void clearNavigation() => clearField(1);
  @$pb.TagNumber(1)
  NavigationCommand ensureNavigation() => $_ensure(0);

  @$pb.TagNumber(2)
  LaserCommand get laser => $_getN(1);
  @$pb.TagNumber(2)
  set laser(LaserCommand v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasLaser() => $_has(1);
  @$pb.TagNumber(2)
  void clearLaser() => clearField(2);
  @$pb.TagNumber(2)
  LaserCommand ensureLaser() => $_ensure(1);

  @$pb.TagNumber(3)
  StopCommand get stop => $_getN(2);
  @$pb.TagNumber(3)
  set stop(StopCommand v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasStop() => $_has(2);
  @$pb.TagNumber(3)
  void clearStop() => clearField(3);
  @$pb.TagNumber(3)
  StopCommand ensureStop() => $_ensure(2);

  @$pb.TagNumber(4)
  ZoomCommand get zoom => $_getN(3);
  @$pb.TagNumber(4)
  set zoom(ZoomCommand v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasZoom() => $_has(3);
  @$pb.TagNumber(4)
  void clearZoom() => clearField(4);
  @$pb.TagNumber(4)
  ZoomCommand ensureZoom() => $_ensure(3);
}

class NavigationCommand extends $pb.GeneratedMessage {
  factory NavigationCommand({
    NavigationCommand_Direction? direction,
    $core.double? intensity,
  }) {
    final $result = create();
    if (direction != null) {
      $result.direction = direction;
    }
    if (intensity != null) {
      $result.intensity = intensity;
    }
    return $result;
  }
  NavigationCommand._() : super();
  factory NavigationCommand.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory NavigationCommand.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'NavigationCommand', package: const $pb.PackageName(_omitMessageNames ? '' : 'inventory'), createEmptyInstance: create)
    ..e<NavigationCommand_Direction>(1, _omitFieldNames ? '' : 'direction', $pb.PbFieldType.OE, defaultOrMaker: NavigationCommand_Direction.UNKNOWN, valueOf: NavigationCommand_Direction.valueOf, enumValues: NavigationCommand_Direction.values)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'intensity', $pb.PbFieldType.OF)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  NavigationCommand clone() => NavigationCommand()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  NavigationCommand copyWith(void Function(NavigationCommand) updates) => super.copyWith((message) => updates(message as NavigationCommand)) as NavigationCommand;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static NavigationCommand create() => NavigationCommand._();
  NavigationCommand createEmptyInstance() => create();
  static $pb.PbList<NavigationCommand> createRepeated() => $pb.PbList<NavigationCommand>();
  @$core.pragma('dart2js:noInline')
  static NavigationCommand getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<NavigationCommand>(create);
  static NavigationCommand? _defaultInstance;

  @$pb.TagNumber(1)
  NavigationCommand_Direction get direction => $_getN(0);
  @$pb.TagNumber(1)
  set direction(NavigationCommand_Direction v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasDirection() => $_has(0);
  @$pb.TagNumber(1)
  void clearDirection() => clearField(1);

  @$pb.TagNumber(2)
  $core.double get intensity => $_getN(1);
  @$pb.TagNumber(2)
  set intensity($core.double v) { $_setFloat(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasIntensity() => $_has(1);
  @$pb.TagNumber(2)
  void clearIntensity() => clearField(2);
}

class LaserCommand extends $pb.GeneratedMessage {
  factory LaserCommand({
    $core.bool? active,
    $core.double? screenX,
    $core.double? screenY,
  }) {
    final $result = create();
    if (active != null) {
      $result.active = active;
    }
    if (screenX != null) {
      $result.screenX = screenX;
    }
    if (screenY != null) {
      $result.screenY = screenY;
    }
    return $result;
  }
  LaserCommand._() : super();
  factory LaserCommand.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LaserCommand.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'LaserCommand', package: const $pb.PackageName(_omitMessageNames ? '' : 'inventory'), createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'active')
    ..a<$core.double>(2, _omitFieldNames ? '' : 'screenX', $pb.PbFieldType.OF)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'screenY', $pb.PbFieldType.OF)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LaserCommand clone() => LaserCommand()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LaserCommand copyWith(void Function(LaserCommand) updates) => super.copyWith((message) => updates(message as LaserCommand)) as LaserCommand;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LaserCommand create() => LaserCommand._();
  LaserCommand createEmptyInstance() => create();
  static $pb.PbList<LaserCommand> createRepeated() => $pb.PbList<LaserCommand>();
  @$core.pragma('dart2js:noInline')
  static LaserCommand getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LaserCommand>(create);
  static LaserCommand? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get active => $_getBF(0);
  @$pb.TagNumber(1)
  set active($core.bool v) { $_setBool(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasActive() => $_has(0);
  @$pb.TagNumber(1)
  void clearActive() => clearField(1);

  @$pb.TagNumber(2)
  $core.double get screenX => $_getN(1);
  @$pb.TagNumber(2)
  set screenX($core.double v) { $_setFloat(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasScreenX() => $_has(1);
  @$pb.TagNumber(2)
  void clearScreenX() => clearField(2);

  @$pb.TagNumber(3)
  $core.double get screenY => $_getN(2);
  @$pb.TagNumber(3)
  set screenY($core.double v) { $_setFloat(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasScreenY() => $_has(2);
  @$pb.TagNumber(3)
  void clearScreenY() => clearField(3);
}

class StopCommand extends $pb.GeneratedMessage {
  factory StopCommand({
    $core.bool? emergency,
  }) {
    final $result = create();
    if (emergency != null) {
      $result.emergency = emergency;
    }
    return $result;
  }
  StopCommand._() : super();
  factory StopCommand.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory StopCommand.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'StopCommand', package: const $pb.PackageName(_omitMessageNames ? '' : 'inventory'), createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'emergency')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  StopCommand clone() => StopCommand()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  StopCommand copyWith(void Function(StopCommand) updates) => super.copyWith((message) => updates(message as StopCommand)) as StopCommand;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StopCommand create() => StopCommand._();
  StopCommand createEmptyInstance() => create();
  static $pb.PbList<StopCommand> createRepeated() => $pb.PbList<StopCommand>();
  @$core.pragma('dart2js:noInline')
  static StopCommand getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<StopCommand>(create);
  static StopCommand? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get emergency => $_getBF(0);
  @$pb.TagNumber(1)
  set emergency($core.bool v) { $_setBool(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasEmergency() => $_has(0);
  @$pb.TagNumber(1)
  void clearEmergency() => clearField(1);
}

class ZoomCommand extends $pb.GeneratedMessage {
  factory ZoomCommand({
    ZoomCommand_ZoomType? type,
    $core.double? level,
  }) {
    final $result = create();
    if (type != null) {
      $result.type = type;
    }
    if (level != null) {
      $result.level = level;
    }
    return $result;
  }
  ZoomCommand._() : super();
  factory ZoomCommand.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ZoomCommand.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ZoomCommand', package: const $pb.PackageName(_omitMessageNames ? '' : 'inventory'), createEmptyInstance: create)
    ..e<ZoomCommand_ZoomType>(1, _omitFieldNames ? '' : 'type', $pb.PbFieldType.OE, defaultOrMaker: ZoomCommand_ZoomType.IN, valueOf: ZoomCommand_ZoomType.valueOf, enumValues: ZoomCommand_ZoomType.values)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'level', $pb.PbFieldType.OF)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ZoomCommand clone() => ZoomCommand()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ZoomCommand copyWith(void Function(ZoomCommand) updates) => super.copyWith((message) => updates(message as ZoomCommand)) as ZoomCommand;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ZoomCommand create() => ZoomCommand._();
  ZoomCommand createEmptyInstance() => create();
  static $pb.PbList<ZoomCommand> createRepeated() => $pb.PbList<ZoomCommand>();
  @$core.pragma('dart2js:noInline')
  static ZoomCommand getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ZoomCommand>(create);
  static ZoomCommand? _defaultInstance;

  @$pb.TagNumber(1)
  ZoomCommand_ZoomType get type => $_getN(0);
  @$pb.TagNumber(1)
  set type(ZoomCommand_ZoomType v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => clearField(1);

  @$pb.TagNumber(2)
  $core.double get level => $_getN(1);
  @$pb.TagNumber(2)
  set level($core.double v) { $_setFloat(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasLevel() => $_has(1);
  @$pb.TagNumber(2)
  void clearLevel() => clearField(2);
}

enum ConsumerCommand_Command {
  navigation, 
  laser, 
  stop, 
  zoom, 
  voice, 
  text, 
  notSet
}

/// Consumer messages
class ConsumerCommand extends $pb.GeneratedMessage {
  factory ConsumerCommand({
    $core.String? sessionId,
    $core.String? token,
    NavigationCommand? navigation,
    LaserCommand? laser,
    StopCommand? stop,
    ZoomCommand? zoom,
    VoiceCommand? voice,
    TextCommand? text,
  }) {
    final $result = create();
    if (sessionId != null) {
      $result.sessionId = sessionId;
    }
    if (token != null) {
      $result.token = token;
    }
    if (navigation != null) {
      $result.navigation = navigation;
    }
    if (laser != null) {
      $result.laser = laser;
    }
    if (stop != null) {
      $result.stop = stop;
    }
    if (zoom != null) {
      $result.zoom = zoom;
    }
    if (voice != null) {
      $result.voice = voice;
    }
    if (text != null) {
      $result.text = text;
    }
    return $result;
  }
  ConsumerCommand._() : super();
  factory ConsumerCommand.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ConsumerCommand.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static const $core.Map<$core.int, ConsumerCommand_Command> _ConsumerCommand_CommandByTag = {
    3 : ConsumerCommand_Command.navigation,
    4 : ConsumerCommand_Command.laser,
    5 : ConsumerCommand_Command.stop,
    6 : ConsumerCommand_Command.zoom,
    7 : ConsumerCommand_Command.voice,
    8 : ConsumerCommand_Command.text,
    0 : ConsumerCommand_Command.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ConsumerCommand', package: const $pb.PackageName(_omitMessageNames ? '' : 'inventory'), createEmptyInstance: create)
    ..oo(0, [3, 4, 5, 6, 7, 8])
    ..aOS(1, _omitFieldNames ? '' : 'sessionId')
    ..aOS(2, _omitFieldNames ? '' : 'token')
    ..aOM<NavigationCommand>(3, _omitFieldNames ? '' : 'navigation', subBuilder: NavigationCommand.create)
    ..aOM<LaserCommand>(4, _omitFieldNames ? '' : 'laser', subBuilder: LaserCommand.create)
    ..aOM<StopCommand>(5, _omitFieldNames ? '' : 'stop', subBuilder: StopCommand.create)
    ..aOM<ZoomCommand>(6, _omitFieldNames ? '' : 'zoom', subBuilder: ZoomCommand.create)
    ..aOM<VoiceCommand>(7, _omitFieldNames ? '' : 'voice', subBuilder: VoiceCommand.create)
    ..aOM<TextCommand>(8, _omitFieldNames ? '' : 'text', subBuilder: TextCommand.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ConsumerCommand clone() => ConsumerCommand()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ConsumerCommand copyWith(void Function(ConsumerCommand) updates) => super.copyWith((message) => updates(message as ConsumerCommand)) as ConsumerCommand;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ConsumerCommand create() => ConsumerCommand._();
  ConsumerCommand createEmptyInstance() => create();
  static $pb.PbList<ConsumerCommand> createRepeated() => $pb.PbList<ConsumerCommand>();
  @$core.pragma('dart2js:noInline')
  static ConsumerCommand getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ConsumerCommand>(create);
  static ConsumerCommand? _defaultInstance;

  ConsumerCommand_Command whichCommand() => _ConsumerCommand_CommandByTag[$_whichOneof(0)]!;
  void clearCommand() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $core.String get sessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get token => $_getSZ(1);
  @$pb.TagNumber(2)
  set token($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasToken() => $_has(1);
  @$pb.TagNumber(2)
  void clearToken() => clearField(2);

  @$pb.TagNumber(3)
  NavigationCommand get navigation => $_getN(2);
  @$pb.TagNumber(3)
  set navigation(NavigationCommand v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasNavigation() => $_has(2);
  @$pb.TagNumber(3)
  void clearNavigation() => clearField(3);
  @$pb.TagNumber(3)
  NavigationCommand ensureNavigation() => $_ensure(2);

  @$pb.TagNumber(4)
  LaserCommand get laser => $_getN(3);
  @$pb.TagNumber(4)
  set laser(LaserCommand v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasLaser() => $_has(3);
  @$pb.TagNumber(4)
  void clearLaser() => clearField(4);
  @$pb.TagNumber(4)
  LaserCommand ensureLaser() => $_ensure(3);

  @$pb.TagNumber(5)
  StopCommand get stop => $_getN(4);
  @$pb.TagNumber(5)
  set stop(StopCommand v) { setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasStop() => $_has(4);
  @$pb.TagNumber(5)
  void clearStop() => clearField(5);
  @$pb.TagNumber(5)
  StopCommand ensureStop() => $_ensure(4);

  @$pb.TagNumber(6)
  ZoomCommand get zoom => $_getN(5);
  @$pb.TagNumber(6)
  set zoom(ZoomCommand v) { setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasZoom() => $_has(5);
  @$pb.TagNumber(6)
  void clearZoom() => clearField(6);
  @$pb.TagNumber(6)
  ZoomCommand ensureZoom() => $_ensure(5);

  @$pb.TagNumber(7)
  VoiceCommand get voice => $_getN(6);
  @$pb.TagNumber(7)
  set voice(VoiceCommand v) { setField(7, v); }
  @$pb.TagNumber(7)
  $core.bool hasVoice() => $_has(6);
  @$pb.TagNumber(7)
  void clearVoice() => clearField(7);
  @$pb.TagNumber(7)
  VoiceCommand ensureVoice() => $_ensure(6);

  @$pb.TagNumber(8)
  TextCommand get text => $_getN(7);
  @$pb.TagNumber(8)
  set text(TextCommand v) { setField(8, v); }
  @$pb.TagNumber(8)
  $core.bool hasText() => $_has(7);
  @$pb.TagNumber(8)
  void clearText() => clearField(8);
  @$pb.TagNumber(8)
  TextCommand ensureText() => $_ensure(7);
}

class VoiceCommand extends $pb.GeneratedMessage {
  factory VoiceCommand({
    $core.String? transcribedText,
    $core.double? confidence,
  }) {
    final $result = create();
    if (transcribedText != null) {
      $result.transcribedText = transcribedText;
    }
    if (confidence != null) {
      $result.confidence = confidence;
    }
    return $result;
  }
  VoiceCommand._() : super();
  factory VoiceCommand.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory VoiceCommand.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'VoiceCommand', package: const $pb.PackageName(_omitMessageNames ? '' : 'inventory'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'transcribedText')
    ..a<$core.double>(2, _omitFieldNames ? '' : 'confidence', $pb.PbFieldType.OF)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  VoiceCommand clone() => VoiceCommand()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  VoiceCommand copyWith(void Function(VoiceCommand) updates) => super.copyWith((message) => updates(message as VoiceCommand)) as VoiceCommand;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static VoiceCommand create() => VoiceCommand._();
  VoiceCommand createEmptyInstance() => create();
  static $pb.PbList<VoiceCommand> createRepeated() => $pb.PbList<VoiceCommand>();
  @$core.pragma('dart2js:noInline')
  static VoiceCommand getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<VoiceCommand>(create);
  static VoiceCommand? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get transcribedText => $_getSZ(0);
  @$pb.TagNumber(1)
  set transcribedText($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTranscribedText() => $_has(0);
  @$pb.TagNumber(1)
  void clearTranscribedText() => clearField(1);

  @$pb.TagNumber(2)
  $core.double get confidence => $_getN(1);
  @$pb.TagNumber(2)
  set confidence($core.double v) { $_setFloat(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasConfidence() => $_has(1);
  @$pb.TagNumber(2)
  void clearConfidence() => clearField(2);
}

class TextCommand extends $pb.GeneratedMessage {
  factory TextCommand({
    $core.String? text,
  }) {
    final $result = create();
    if (text != null) {
      $result.text = text;
    }
    return $result;
  }
  TextCommand._() : super();
  factory TextCommand.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TextCommand.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'TextCommand', package: const $pb.PackageName(_omitMessageNames ? '' : 'inventory'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'text')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  TextCommand clone() => TextCommand()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  TextCommand copyWith(void Function(TextCommand) updates) => super.copyWith((message) => updates(message as TextCommand)) as TextCommand;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TextCommand create() => TextCommand._();
  TextCommand createEmptyInstance() => create();
  static $pb.PbList<TextCommand> createRepeated() => $pb.PbList<TextCommand>();
  @$core.pragma('dart2js:noInline')
  static TextCommand getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TextCommand>(create);
  static TextCommand? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get text => $_getSZ(0);
  @$pb.TagNumber(1)
  set text($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasText() => $_has(0);
  @$pb.TagNumber(1)
  void clearText() => clearField(1);
}

/// Heartbeat
class HeartbeatRequest extends $pb.GeneratedMessage {
  factory HeartbeatRequest({
    $core.String? sessionId,
    $core.String? token,
    $core.String? role,
  }) {
    final $result = create();
    if (sessionId != null) {
      $result.sessionId = sessionId;
    }
    if (token != null) {
      $result.token = token;
    }
    if (role != null) {
      $result.role = role;
    }
    return $result;
  }
  HeartbeatRequest._() : super();
  factory HeartbeatRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory HeartbeatRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'HeartbeatRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'inventory'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'sessionId')
    ..aOS(2, _omitFieldNames ? '' : 'token')
    ..aOS(3, _omitFieldNames ? '' : 'role')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  HeartbeatRequest clone() => HeartbeatRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  HeartbeatRequest copyWith(void Function(HeartbeatRequest) updates) => super.copyWith((message) => updates(message as HeartbeatRequest)) as HeartbeatRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static HeartbeatRequest create() => HeartbeatRequest._();
  HeartbeatRequest createEmptyInstance() => create();
  static $pb.PbList<HeartbeatRequest> createRepeated() => $pb.PbList<HeartbeatRequest>();
  @$core.pragma('dart2js:noInline')
  static HeartbeatRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<HeartbeatRequest>(create);
  static HeartbeatRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get token => $_getSZ(1);
  @$pb.TagNumber(2)
  set token($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasToken() => $_has(1);
  @$pb.TagNumber(2)
  void clearToken() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get role => $_getSZ(2);
  @$pb.TagNumber(3)
  set role($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasRole() => $_has(2);
  @$pb.TagNumber(3)
  void clearRole() => clearField(3);
}

class HeartbeatResponse extends $pb.GeneratedMessage {
  factory HeartbeatResponse({
    $core.bool? active,
    $fixnum.Int64? sessionDurationMs,
  }) {
    final $result = create();
    if (active != null) {
      $result.active = active;
    }
    if (sessionDurationMs != null) {
      $result.sessionDurationMs = sessionDurationMs;
    }
    return $result;
  }
  HeartbeatResponse._() : super();
  factory HeartbeatResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory HeartbeatResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'HeartbeatResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'inventory'), createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'active')
    ..aInt64(2, _omitFieldNames ? '' : 'sessionDurationMs')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  HeartbeatResponse clone() => HeartbeatResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  HeartbeatResponse copyWith(void Function(HeartbeatResponse) updates) => super.copyWith((message) => updates(message as HeartbeatResponse)) as HeartbeatResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static HeartbeatResponse create() => HeartbeatResponse._();
  HeartbeatResponse createEmptyInstance() => create();
  static $pb.PbList<HeartbeatResponse> createRepeated() => $pb.PbList<HeartbeatResponse>();
  @$core.pragma('dart2js:noInline')
  static HeartbeatResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<HeartbeatResponse>(create);
  static HeartbeatResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get active => $_getBF(0);
  @$pb.TagNumber(1)
  set active($core.bool v) { $_setBool(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasActive() => $_has(0);
  @$pb.TagNumber(1)
  void clearActive() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get sessionDurationMs => $_getI64(1);
  @$pb.TagNumber(2)
  set sessionDurationMs($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasSessionDurationMs() => $_has(1);
  @$pb.TagNumber(2)
  void clearSessionDurationMs() => clearField(2);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
