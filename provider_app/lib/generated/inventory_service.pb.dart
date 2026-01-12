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
    $core.String? location,
    $core.double? latitude,
    $core.double? longitude,
  }) {
    final $result = create();
    if (providerId != null) {
      $result.providerId = providerId;
    }
    if (providerName != null) {
      $result.providerName = providerName;
    }
    if (location != null) {
      $result.location = location;
    }
    if (latitude != null) {
      $result.latitude = latitude;
    }
    if (longitude != null) {
      $result.longitude = longitude;
    }
    return $result;
  }
  CreateSessionRequest._() : super();
  factory CreateSessionRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CreateSessionRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CreateSessionRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'inventory'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'providerId')
    ..aOS(2, _omitFieldNames ? '' : 'providerName')
    ..aOS(3, _omitFieldNames ? '' : 'location')
    ..a<$core.double>(4, _omitFieldNames ? '' : 'latitude', $pb.PbFieldType.OD)
    ..a<$core.double>(5, _omitFieldNames ? '' : 'longitude', $pb.PbFieldType.OD)
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

  @$pb.TagNumber(3)
  $core.String get location => $_getSZ(2);
  @$pb.TagNumber(3)
  set location($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasLocation() => $_has(2);
  @$pb.TagNumber(3)
  void clearLocation() => clearField(3);

  @$pb.TagNumber(4)
  $core.double get latitude => $_getN(3);
  @$pb.TagNumber(4)
  set latitude($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasLatitude() => $_has(3);
  @$pb.TagNumber(4)
  void clearLatitude() => clearField(4);

  @$pb.TagNumber(5)
  $core.double get longitude => $_getN(4);
  @$pb.TagNumber(5)
  set longitude($core.double v) { $_setDouble(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasLongitude() => $_has(4);
  @$pb.TagNumber(5)
  void clearLongitude() => clearField(5);
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
    $core.bool? success,
  }) {
    final $result = create();
    if (success != null) {
      $result.success = success;
    }
    return $result;
  }
  HeartbeatResponse._() : super();
  factory HeartbeatResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory HeartbeatResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'HeartbeatResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'inventory'), createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'success')
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
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool v) { $_setBool(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => clearField(1);
}

class RequestConnectionRequest extends $pb.GeneratedMessage {
  factory RequestConnectionRequest({
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
  RequestConnectionRequest._() : super();
  factory RequestConnectionRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RequestConnectionRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RequestConnectionRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'inventory'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'sessionId')
    ..aOS(2, _omitFieldNames ? '' : 'consumerId')
    ..aOS(3, _omitFieldNames ? '' : 'consumerName')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RequestConnectionRequest clone() => RequestConnectionRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RequestConnectionRequest copyWith(void Function(RequestConnectionRequest) updates) => super.copyWith((message) => updates(message as RequestConnectionRequest)) as RequestConnectionRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RequestConnectionRequest create() => RequestConnectionRequest._();
  RequestConnectionRequest createEmptyInstance() => create();
  static $pb.PbList<RequestConnectionRequest> createRepeated() => $pb.PbList<RequestConnectionRequest>();
  @$core.pragma('dart2js:noInline')
  static RequestConnectionRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RequestConnectionRequest>(create);
  static RequestConnectionRequest? _defaultInstance;

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

class RequestConnectionResponse extends $pb.GeneratedMessage {
  factory RequestConnectionResponse({
    $core.String? requestId,
  }) {
    final $result = create();
    if (requestId != null) {
      $result.requestId = requestId;
    }
    return $result;
  }
  RequestConnectionResponse._() : super();
  factory RequestConnectionResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RequestConnectionResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RequestConnectionResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'inventory'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'requestId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RequestConnectionResponse clone() => RequestConnectionResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RequestConnectionResponse copyWith(void Function(RequestConnectionResponse) updates) => super.copyWith((message) => updates(message as RequestConnectionResponse)) as RequestConnectionResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RequestConnectionResponse create() => RequestConnectionResponse._();
  RequestConnectionResponse createEmptyInstance() => create();
  static $pb.PbList<RequestConnectionResponse> createRepeated() => $pb.PbList<RequestConnectionResponse>();
  @$core.pragma('dart2js:noInline')
  static RequestConnectionResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RequestConnectionResponse>(create);
  static RequestConnectionResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get requestId => $_getSZ(0);
  @$pb.TagNumber(1)
  set requestId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasRequestId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRequestId() => clearField(1);
}

class ApproveConnectionRequest extends $pb.GeneratedMessage {
  factory ApproveConnectionRequest({
    $core.String? requestId,
  }) {
    final $result = create();
    if (requestId != null) {
      $result.requestId = requestId;
    }
    return $result;
  }
  ApproveConnectionRequest._() : super();
  factory ApproveConnectionRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ApproveConnectionRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ApproveConnectionRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'inventory'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'requestId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ApproveConnectionRequest clone() => ApproveConnectionRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ApproveConnectionRequest copyWith(void Function(ApproveConnectionRequest) updates) => super.copyWith((message) => updates(message as ApproveConnectionRequest)) as ApproveConnectionRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ApproveConnectionRequest create() => ApproveConnectionRequest._();
  ApproveConnectionRequest createEmptyInstance() => create();
  static $pb.PbList<ApproveConnectionRequest> createRepeated() => $pb.PbList<ApproveConnectionRequest>();
  @$core.pragma('dart2js:noInline')
  static ApproveConnectionRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ApproveConnectionRequest>(create);
  static ApproveConnectionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get requestId => $_getSZ(0);
  @$pb.TagNumber(1)
  set requestId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasRequestId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRequestId() => clearField(1);
}

class ApproveConnectionResponse extends $pb.GeneratedMessage {
  factory ApproveConnectionResponse({
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
  ApproveConnectionResponse._() : super();
  factory ApproveConnectionResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ApproveConnectionResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ApproveConnectionResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'inventory'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'sessionId')
    ..aOS(2, _omitFieldNames ? '' : 'token')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ApproveConnectionResponse clone() => ApproveConnectionResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ApproveConnectionResponse copyWith(void Function(ApproveConnectionResponse) updates) => super.copyWith((message) => updates(message as ApproveConnectionResponse)) as ApproveConnectionResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ApproveConnectionResponse create() => ApproveConnectionResponse._();
  ApproveConnectionResponse createEmptyInstance() => create();
  static $pb.PbList<ApproveConnectionResponse> createRepeated() => $pb.PbList<ApproveConnectionResponse>();
  @$core.pragma('dart2js:noInline')
  static ApproveConnectionResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ApproveConnectionResponse>(create);
  static ApproveConnectionResponse? _defaultInstance;

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

class DenyConnectionRequest extends $pb.GeneratedMessage {
  factory DenyConnectionRequest({
    $core.String? requestId,
    $core.String? reason,
  }) {
    final $result = create();
    if (requestId != null) {
      $result.requestId = requestId;
    }
    if (reason != null) {
      $result.reason = reason;
    }
    return $result;
  }
  DenyConnectionRequest._() : super();
  factory DenyConnectionRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DenyConnectionRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DenyConnectionRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'inventory'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'requestId')
    ..aOS(2, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DenyConnectionRequest clone() => DenyConnectionRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DenyConnectionRequest copyWith(void Function(DenyConnectionRequest) updates) => super.copyWith((message) => updates(message as DenyConnectionRequest)) as DenyConnectionRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DenyConnectionRequest create() => DenyConnectionRequest._();
  DenyConnectionRequest createEmptyInstance() => create();
  static $pb.PbList<DenyConnectionRequest> createRepeated() => $pb.PbList<DenyConnectionRequest>();
  @$core.pragma('dart2js:noInline')
  static DenyConnectionRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DenyConnectionRequest>(create);
  static DenyConnectionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get requestId => $_getSZ(0);
  @$pb.TagNumber(1)
  set requestId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasRequestId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRequestId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get reason => $_getSZ(1);
  @$pb.TagNumber(2)
  set reason($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasReason() => $_has(1);
  @$pb.TagNumber(2)
  void clearReason() => clearField(2);
}

class DenyConnectionResponse extends $pb.GeneratedMessage {
  factory DenyConnectionResponse({
    $core.bool? success,
  }) {
    final $result = create();
    if (success != null) {
      $result.success = success;
    }
    return $result;
  }
  DenyConnectionResponse._() : super();
  factory DenyConnectionResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DenyConnectionResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DenyConnectionResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'inventory'), createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DenyConnectionResponse clone() => DenyConnectionResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DenyConnectionResponse copyWith(void Function(DenyConnectionResponse) updates) => super.copyWith((message) => updates(message as DenyConnectionResponse)) as DenyConnectionResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DenyConnectionResponse create() => DenyConnectionResponse._();
  DenyConnectionResponse createEmptyInstance() => create();
  static $pb.PbList<DenyConnectionResponse> createRepeated() => $pb.PbList<DenyConnectionResponse>();
  @$core.pragma('dart2js:noInline')
  static DenyConnectionResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DenyConnectionResponse>(create);
  static DenyConnectionResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool v) { $_setBool(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => clearField(1);
}

class WatchConnectionRequestsRequest extends $pb.GeneratedMessage {
  factory WatchConnectionRequestsRequest({
    $core.String? sessionId,
  }) {
    final $result = create();
    if (sessionId != null) {
      $result.sessionId = sessionId;
    }
    return $result;
  }
  WatchConnectionRequestsRequest._() : super();
  factory WatchConnectionRequestsRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory WatchConnectionRequestsRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'WatchConnectionRequestsRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'inventory'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'sessionId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  WatchConnectionRequestsRequest clone() => WatchConnectionRequestsRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  WatchConnectionRequestsRequest copyWith(void Function(WatchConnectionRequestsRequest) updates) => super.copyWith((message) => updates(message as WatchConnectionRequestsRequest)) as WatchConnectionRequestsRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WatchConnectionRequestsRequest create() => WatchConnectionRequestsRequest._();
  WatchConnectionRequestsRequest createEmptyInstance() => create();
  static $pb.PbList<WatchConnectionRequestsRequest> createRepeated() => $pb.PbList<WatchConnectionRequestsRequest>();
  @$core.pragma('dart2js:noInline')
  static WatchConnectionRequestsRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<WatchConnectionRequestsRequest>(create);
  static WatchConnectionRequestsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionId() => clearField(1);
}

class ConnectionRequestNotification extends $pb.GeneratedMessage {
  factory ConnectionRequestNotification({
    $core.String? requestId,
    $core.String? consumerId,
    $core.String? consumerName,
    $fixnum.Int64? timestamp,
  }) {
    final $result = create();
    if (requestId != null) {
      $result.requestId = requestId;
    }
    if (consumerId != null) {
      $result.consumerId = consumerId;
    }
    if (consumerName != null) {
      $result.consumerName = consumerName;
    }
    if (timestamp != null) {
      $result.timestamp = timestamp;
    }
    return $result;
  }
  ConnectionRequestNotification._() : super();
  factory ConnectionRequestNotification.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ConnectionRequestNotification.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ConnectionRequestNotification', package: const $pb.PackageName(_omitMessageNames ? '' : 'inventory'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'requestId')
    ..aOS(2, _omitFieldNames ? '' : 'consumerId')
    ..aOS(3, _omitFieldNames ? '' : 'consumerName')
    ..aInt64(4, _omitFieldNames ? '' : 'timestamp')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ConnectionRequestNotification clone() => ConnectionRequestNotification()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ConnectionRequestNotification copyWith(void Function(ConnectionRequestNotification) updates) => super.copyWith((message) => updates(message as ConnectionRequestNotification)) as ConnectionRequestNotification;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ConnectionRequestNotification create() => ConnectionRequestNotification._();
  ConnectionRequestNotification createEmptyInstance() => create();
  static $pb.PbList<ConnectionRequestNotification> createRepeated() => $pb.PbList<ConnectionRequestNotification>();
  @$core.pragma('dart2js:noInline')
  static ConnectionRequestNotification getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ConnectionRequestNotification>(create);
  static ConnectionRequestNotification? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get requestId => $_getSZ(0);
  @$pb.TagNumber(1)
  set requestId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasRequestId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRequestId() => clearField(1);

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

  @$pb.TagNumber(4)
  $fixnum.Int64 get timestamp => $_getI64(3);
  @$pb.TagNumber(4)
  set timestamp($fixnum.Int64 v) { $_setInt64(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasTimestamp() => $_has(3);
  @$pb.TagNumber(4)
  void clearTimestamp() => clearField(4);
}

class WatchApprovalStatusRequest extends $pb.GeneratedMessage {
  factory WatchApprovalStatusRequest({
    $core.String? requestId,
  }) {
    final $result = create();
    if (requestId != null) {
      $result.requestId = requestId;
    }
    return $result;
  }
  WatchApprovalStatusRequest._() : super();
  factory WatchApprovalStatusRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory WatchApprovalStatusRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'WatchApprovalStatusRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'inventory'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'requestId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  WatchApprovalStatusRequest clone() => WatchApprovalStatusRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  WatchApprovalStatusRequest copyWith(void Function(WatchApprovalStatusRequest) updates) => super.copyWith((message) => updates(message as WatchApprovalStatusRequest)) as WatchApprovalStatusRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WatchApprovalStatusRequest create() => WatchApprovalStatusRequest._();
  WatchApprovalStatusRequest createEmptyInstance() => create();
  static $pb.PbList<WatchApprovalStatusRequest> createRepeated() => $pb.PbList<WatchApprovalStatusRequest>();
  @$core.pragma('dart2js:noInline')
  static WatchApprovalStatusRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<WatchApprovalStatusRequest>(create);
  static WatchApprovalStatusRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get requestId => $_getSZ(0);
  @$pb.TagNumber(1)
  set requestId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasRequestId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRequestId() => clearField(1);
}

class ApprovalStatusUpdate extends $pb.GeneratedMessage {
  factory ApprovalStatusUpdate({
    ApprovalStatus? status,
    $core.String? sessionId,
    $core.String? token,
    $core.String? message,
  }) {
    final $result = create();
    if (status != null) {
      $result.status = status;
    }
    if (sessionId != null) {
      $result.sessionId = sessionId;
    }
    if (token != null) {
      $result.token = token;
    }
    if (message != null) {
      $result.message = message;
    }
    return $result;
  }
  ApprovalStatusUpdate._() : super();
  factory ApprovalStatusUpdate.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ApprovalStatusUpdate.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ApprovalStatusUpdate', package: const $pb.PackageName(_omitMessageNames ? '' : 'inventory'), createEmptyInstance: create)
    ..e<ApprovalStatus>(1, _omitFieldNames ? '' : 'status', $pb.PbFieldType.OE, defaultOrMaker: ApprovalStatus.PENDING, valueOf: ApprovalStatus.valueOf, enumValues: ApprovalStatus.values)
    ..aOS(2, _omitFieldNames ? '' : 'sessionId')
    ..aOS(3, _omitFieldNames ? '' : 'token')
    ..aOS(4, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ApprovalStatusUpdate clone() => ApprovalStatusUpdate()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ApprovalStatusUpdate copyWith(void Function(ApprovalStatusUpdate) updates) => super.copyWith((message) => updates(message as ApprovalStatusUpdate)) as ApprovalStatusUpdate;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ApprovalStatusUpdate create() => ApprovalStatusUpdate._();
  ApprovalStatusUpdate createEmptyInstance() => create();
  static $pb.PbList<ApprovalStatusUpdate> createRepeated() => $pb.PbList<ApprovalStatusUpdate>();
  @$core.pragma('dart2js:noInline')
  static ApprovalStatusUpdate getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ApprovalStatusUpdate>(create);
  static ApprovalStatusUpdate? _defaultInstance;

  @$pb.TagNumber(1)
  ApprovalStatus get status => $_getN(0);
  @$pb.TagNumber(1)
  set status(ApprovalStatus v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasStatus() => $_has(0);
  @$pb.TagNumber(1)
  void clearStatus() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get sessionId => $_getSZ(1);
  @$pb.TagNumber(2)
  set sessionId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasSessionId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSessionId() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get token => $_getSZ(2);
  @$pb.TagNumber(3)
  set token($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasToken() => $_has(2);
  @$pb.TagNumber(3)
  void clearToken() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get message => $_getSZ(3);
  @$pb.TagNumber(4)
  set message($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasMessage() => $_has(3);
  @$pb.TagNumber(4)
  void clearMessage() => clearField(4);
}

/// Session Discovery Messages
class ListSessionsRequest extends $pb.GeneratedMessage {
  factory ListSessionsRequest({
    $core.String? searchQuery,
  }) {
    final $result = create();
    if (searchQuery != null) {
      $result.searchQuery = searchQuery;
    }
    return $result;
  }
  ListSessionsRequest._() : super();
  factory ListSessionsRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListSessionsRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ListSessionsRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'inventory'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'searchQuery')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListSessionsRequest clone() => ListSessionsRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListSessionsRequest copyWith(void Function(ListSessionsRequest) updates) => super.copyWith((message) => updates(message as ListSessionsRequest)) as ListSessionsRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListSessionsRequest create() => ListSessionsRequest._();
  ListSessionsRequest createEmptyInstance() => create();
  static $pb.PbList<ListSessionsRequest> createRepeated() => $pb.PbList<ListSessionsRequest>();
  @$core.pragma('dart2js:noInline')
  static ListSessionsRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListSessionsRequest>(create);
  static ListSessionsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get searchQuery => $_getSZ(0);
  @$pb.TagNumber(1)
  set searchQuery($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSearchQuery() => $_has(0);
  @$pb.TagNumber(1)
  void clearSearchQuery() => clearField(1);
}

class ListSessionsResponse extends $pb.GeneratedMessage {
  factory ListSessionsResponse({
    $core.Iterable<SessionInfo>? sessions,
  }) {
    final $result = create();
    if (sessions != null) {
      $result.sessions.addAll(sessions);
    }
    return $result;
  }
  ListSessionsResponse._() : super();
  factory ListSessionsResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListSessionsResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ListSessionsResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'inventory'), createEmptyInstance: create)
    ..pc<SessionInfo>(1, _omitFieldNames ? '' : 'sessions', $pb.PbFieldType.PM, subBuilder: SessionInfo.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListSessionsResponse clone() => ListSessionsResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListSessionsResponse copyWith(void Function(ListSessionsResponse) updates) => super.copyWith((message) => updates(message as ListSessionsResponse)) as ListSessionsResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListSessionsResponse create() => ListSessionsResponse._();
  ListSessionsResponse createEmptyInstance() => create();
  static $pb.PbList<ListSessionsResponse> createRepeated() => $pb.PbList<ListSessionsResponse>();
  @$core.pragma('dart2js:noInline')
  static ListSessionsResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListSessionsResponse>(create);
  static ListSessionsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<SessionInfo> get sessions => $_getList(0);
}

class SessionInfo extends $pb.GeneratedMessage {
  factory SessionInfo({
    $core.String? sessionId,
    $core.String? providerName,
    $core.String? location,
    $core.String? formattedAddress,
    $core.double? latitude,
    $core.double? longitude,
    $core.bool? inActiveCall,
    $fixnum.Int64? createdAt,
    $core.bool? acceptingConnections,
  }) {
    final $result = create();
    if (sessionId != null) {
      $result.sessionId = sessionId;
    }
    if (providerName != null) {
      $result.providerName = providerName;
    }
    if (location != null) {
      $result.location = location;
    }
    if (formattedAddress != null) {
      $result.formattedAddress = formattedAddress;
    }
    if (latitude != null) {
      $result.latitude = latitude;
    }
    if (longitude != null) {
      $result.longitude = longitude;
    }
    if (inActiveCall != null) {
      $result.inActiveCall = inActiveCall;
    }
    if (createdAt != null) {
      $result.createdAt = createdAt;
    }
    if (acceptingConnections != null) {
      $result.acceptingConnections = acceptingConnections;
    }
    return $result;
  }
  SessionInfo._() : super();
  factory SessionInfo.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SessionInfo.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SessionInfo', package: const $pb.PackageName(_omitMessageNames ? '' : 'inventory'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'sessionId')
    ..aOS(2, _omitFieldNames ? '' : 'providerName')
    ..aOS(3, _omitFieldNames ? '' : 'location')
    ..aOS(4, _omitFieldNames ? '' : 'formattedAddress')
    ..a<$core.double>(5, _omitFieldNames ? '' : 'latitude', $pb.PbFieldType.OD)
    ..a<$core.double>(6, _omitFieldNames ? '' : 'longitude', $pb.PbFieldType.OD)
    ..aOB(7, _omitFieldNames ? '' : 'inActiveCall')
    ..aInt64(8, _omitFieldNames ? '' : 'createdAt')
    ..aOB(9, _omitFieldNames ? '' : 'acceptingConnections')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SessionInfo clone() => SessionInfo()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SessionInfo copyWith(void Function(SessionInfo) updates) => super.copyWith((message) => updates(message as SessionInfo)) as SessionInfo;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SessionInfo create() => SessionInfo._();
  SessionInfo createEmptyInstance() => create();
  static $pb.PbList<SessionInfo> createRepeated() => $pb.PbList<SessionInfo>();
  @$core.pragma('dart2js:noInline')
  static SessionInfo getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SessionInfo>(create);
  static SessionInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get providerName => $_getSZ(1);
  @$pb.TagNumber(2)
  set providerName($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasProviderName() => $_has(1);
  @$pb.TagNumber(2)
  void clearProviderName() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get location => $_getSZ(2);
  @$pb.TagNumber(3)
  set location($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasLocation() => $_has(2);
  @$pb.TagNumber(3)
  void clearLocation() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get formattedAddress => $_getSZ(3);
  @$pb.TagNumber(4)
  set formattedAddress($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasFormattedAddress() => $_has(3);
  @$pb.TagNumber(4)
  void clearFormattedAddress() => clearField(4);

  @$pb.TagNumber(5)
  $core.double get latitude => $_getN(4);
  @$pb.TagNumber(5)
  set latitude($core.double v) { $_setDouble(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasLatitude() => $_has(4);
  @$pb.TagNumber(5)
  void clearLatitude() => clearField(5);

  @$pb.TagNumber(6)
  $core.double get longitude => $_getN(5);
  @$pb.TagNumber(6)
  set longitude($core.double v) { $_setDouble(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasLongitude() => $_has(5);
  @$pb.TagNumber(6)
  void clearLongitude() => clearField(6);

  @$pb.TagNumber(7)
  $core.bool get inActiveCall => $_getBF(6);
  @$pb.TagNumber(7)
  set inActiveCall($core.bool v) { $_setBool(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasInActiveCall() => $_has(6);
  @$pb.TagNumber(7)
  void clearInActiveCall() => clearField(7);

  @$pb.TagNumber(8)
  $fixnum.Int64 get createdAt => $_getI64(7);
  @$pb.TagNumber(8)
  set createdAt($fixnum.Int64 v) { $_setInt64(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasCreatedAt() => $_has(7);
  @$pb.TagNumber(8)
  void clearCreatedAt() => clearField(8);

  @$pb.TagNumber(9)
  $core.bool get acceptingConnections => $_getBF(8);
  @$pb.TagNumber(9)
  set acceptingConnections($core.bool v) { $_setBool(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasAcceptingConnections() => $_has(8);
  @$pb.TagNumber(9)
  void clearAcceptingConnections() => clearField(9);
}

enum Command_CommandType {
  navigation, 
  laser, 
  stop, 
  zoom, 
  voice, 
  text, 
  notSet
}

/// Command Messages
class Command extends $pb.GeneratedMessage {
  factory Command({
    $core.String? sessionId,
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
  Command._() : super();
  factory Command.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Command.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static const $core.Map<$core.int, Command_CommandType> _Command_CommandTypeByTag = {
    2 : Command_CommandType.navigation,
    3 : Command_CommandType.laser,
    4 : Command_CommandType.stop,
    5 : Command_CommandType.zoom,
    6 : Command_CommandType.voice,
    7 : Command_CommandType.text,
    0 : Command_CommandType.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Command', package: const $pb.PackageName(_omitMessageNames ? '' : 'inventory'), createEmptyInstance: create)
    ..oo(0, [2, 3, 4, 5, 6, 7])
    ..aOS(1, _omitFieldNames ? '' : 'sessionId')
    ..aOM<NavigationCommand>(2, _omitFieldNames ? '' : 'navigation', subBuilder: NavigationCommand.create)
    ..aOM<LaserCommand>(3, _omitFieldNames ? '' : 'laser', subBuilder: LaserCommand.create)
    ..aOM<StopCommand>(4, _omitFieldNames ? '' : 'stop', subBuilder: StopCommand.create)
    ..aOM<ZoomCommand>(5, _omitFieldNames ? '' : 'zoom', subBuilder: ZoomCommand.create)
    ..aOM<VoiceCommand>(6, _omitFieldNames ? '' : 'voice', subBuilder: VoiceCommand.create)
    ..aOM<TextCommand>(7, _omitFieldNames ? '' : 'text', subBuilder: TextCommand.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Command clone() => Command()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Command copyWith(void Function(Command) updates) => super.copyWith((message) => updates(message as Command)) as Command;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Command create() => Command._();
  Command createEmptyInstance() => create();
  static $pb.PbList<Command> createRepeated() => $pb.PbList<Command>();
  @$core.pragma('dart2js:noInline')
  static Command getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Command>(create);
  static Command? _defaultInstance;

  Command_CommandType whichCommandType() => _Command_CommandTypeByTag[$_whichOneof(0)]!;
  void clearCommandType() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $core.String get sessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionId() => clearField(1);

  @$pb.TagNumber(2)
  NavigationCommand get navigation => $_getN(1);
  @$pb.TagNumber(2)
  set navigation(NavigationCommand v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasNavigation() => $_has(1);
  @$pb.TagNumber(2)
  void clearNavigation() => clearField(2);
  @$pb.TagNumber(2)
  NavigationCommand ensureNavigation() => $_ensure(1);

  @$pb.TagNumber(3)
  LaserCommand get laser => $_getN(2);
  @$pb.TagNumber(3)
  set laser(LaserCommand v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasLaser() => $_has(2);
  @$pb.TagNumber(3)
  void clearLaser() => clearField(3);
  @$pb.TagNumber(3)
  LaserCommand ensureLaser() => $_ensure(2);

  @$pb.TagNumber(4)
  StopCommand get stop => $_getN(3);
  @$pb.TagNumber(4)
  set stop(StopCommand v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasStop() => $_has(3);
  @$pb.TagNumber(4)
  void clearStop() => clearField(4);
  @$pb.TagNumber(4)
  StopCommand ensureStop() => $_ensure(3);

  @$pb.TagNumber(5)
  ZoomCommand get zoom => $_getN(4);
  @$pb.TagNumber(5)
  set zoom(ZoomCommand v) { setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasZoom() => $_has(4);
  @$pb.TagNumber(5)
  void clearZoom() => clearField(5);
  @$pb.TagNumber(5)
  ZoomCommand ensureZoom() => $_ensure(4);

  @$pb.TagNumber(6)
  VoiceCommand get voice => $_getN(5);
  @$pb.TagNumber(6)
  set voice(VoiceCommand v) { setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasVoice() => $_has(5);
  @$pb.TagNumber(6)
  void clearVoice() => clearField(6);
  @$pb.TagNumber(6)
  VoiceCommand ensureVoice() => $_ensure(5);

  @$pb.TagNumber(7)
  TextCommand get text => $_getN(6);
  @$pb.TagNumber(7)
  set text(TextCommand v) { setField(7, v); }
  @$pb.TagNumber(7)
  $core.bool hasText() => $_has(6);
  @$pb.TagNumber(7)
  void clearText() => clearField(7);
  @$pb.TagNumber(7)
  TextCommand ensureText() => $_ensure(6);
}

class CommandResponse extends $pb.GeneratedMessage {
  factory CommandResponse({
    $core.bool? success,
    $core.String? message,
  }) {
    final $result = create();
    if (success != null) {
      $result.success = success;
    }
    if (message != null) {
      $result.message = message;
    }
    return $result;
  }
  CommandResponse._() : super();
  factory CommandResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CommandResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CommandResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'inventory'), createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CommandResponse clone() => CommandResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CommandResponse copyWith(void Function(CommandResponse) updates) => super.copyWith((message) => updates(message as CommandResponse)) as CommandResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CommandResponse create() => CommandResponse._();
  CommandResponse createEmptyInstance() => create();
  static $pb.PbList<CommandResponse> createRepeated() => $pb.PbList<CommandResponse>();
  @$core.pragma('dart2js:noInline')
  static CommandResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CommandResponse>(create);
  static CommandResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool v) { $_setBool(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get message => $_getSZ(1);
  @$pb.TagNumber(2)
  set message($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessage() => clearField(2);
}

class WebRTCSignal extends $pb.GeneratedMessage {
  factory WebRTCSignal({
    $core.String? sessionId,
    $core.String? fromDeviceId,
    $core.String? toDeviceId,
    WebRTCSignal_SignalType? type,
    $core.String? payload,
  }) {
    final $result = create();
    if (sessionId != null) {
      $result.sessionId = sessionId;
    }
    if (fromDeviceId != null) {
      $result.fromDeviceId = fromDeviceId;
    }
    if (toDeviceId != null) {
      $result.toDeviceId = toDeviceId;
    }
    if (type != null) {
      $result.type = type;
    }
    if (payload != null) {
      $result.payload = payload;
    }
    return $result;
  }
  WebRTCSignal._() : super();
  factory WebRTCSignal.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory WebRTCSignal.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'WebRTCSignal', package: const $pb.PackageName(_omitMessageNames ? '' : 'inventory'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'sessionId')
    ..aOS(2, _omitFieldNames ? '' : 'fromDeviceId')
    ..aOS(3, _omitFieldNames ? '' : 'toDeviceId')
    ..e<WebRTCSignal_SignalType>(4, _omitFieldNames ? '' : 'type', $pb.PbFieldType.OE, defaultOrMaker: WebRTCSignal_SignalType.OFFER, valueOf: WebRTCSignal_SignalType.valueOf, enumValues: WebRTCSignal_SignalType.values)
    ..aOS(5, _omitFieldNames ? '' : 'payload')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  WebRTCSignal clone() => WebRTCSignal()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  WebRTCSignal copyWith(void Function(WebRTCSignal) updates) => super.copyWith((message) => updates(message as WebRTCSignal)) as WebRTCSignal;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WebRTCSignal create() => WebRTCSignal._();
  WebRTCSignal createEmptyInstance() => create();
  static $pb.PbList<WebRTCSignal> createRepeated() => $pb.PbList<WebRTCSignal>();
  @$core.pragma('dart2js:noInline')
  static WebRTCSignal getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<WebRTCSignal>(create);
  static WebRTCSignal? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get fromDeviceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set fromDeviceId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasFromDeviceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearFromDeviceId() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get toDeviceId => $_getSZ(2);
  @$pb.TagNumber(3)
  set toDeviceId($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasToDeviceId() => $_has(2);
  @$pb.TagNumber(3)
  void clearToDeviceId() => clearField(3);

  @$pb.TagNumber(4)
  WebRTCSignal_SignalType get type => $_getN(3);
  @$pb.TagNumber(4)
  set type(WebRTCSignal_SignalType v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasType() => $_has(3);
  @$pb.TagNumber(4)
  void clearType() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get payload => $_getSZ(4);
  @$pb.TagNumber(5)
  set payload($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasPayload() => $_has(4);
  @$pb.TagNumber(5)
  void clearPayload() => clearField(5);
}

class SignalResponse extends $pb.GeneratedMessage {
  factory SignalResponse({
    $core.bool? success,
    $core.String? message,
  }) {
    final $result = create();
    if (success != null) {
      $result.success = success;
    }
    if (message != null) {
      $result.message = message;
    }
    return $result;
  }
  SignalResponse._() : super();
  factory SignalResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SignalResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SignalResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'inventory'), createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SignalResponse clone() => SignalResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SignalResponse copyWith(void Function(SignalResponse) updates) => super.copyWith((message) => updates(message as SignalResponse)) as SignalResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SignalResponse create() => SignalResponse._();
  SignalResponse createEmptyInstance() => create();
  static $pb.PbList<SignalResponse> createRepeated() => $pb.PbList<SignalResponse>();
  @$core.pragma('dart2js:noInline')
  static SignalResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SignalResponse>(create);
  static SignalResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool v) { $_setBool(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get message => $_getSZ(1);
  @$pb.TagNumber(2)
  set message($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessage() => clearField(2);
}

class WatchSignalsRequest extends $pb.GeneratedMessage {
  factory WatchSignalsRequest({
    $core.String? sessionId,
    $core.String? deviceId,
  }) {
    final $result = create();
    if (sessionId != null) {
      $result.sessionId = sessionId;
    }
    if (deviceId != null) {
      $result.deviceId = deviceId;
    }
    return $result;
  }
  WatchSignalsRequest._() : super();
  factory WatchSignalsRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory WatchSignalsRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'WatchSignalsRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'inventory'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'sessionId')
    ..aOS(2, _omitFieldNames ? '' : 'deviceId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  WatchSignalsRequest clone() => WatchSignalsRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  WatchSignalsRequest copyWith(void Function(WatchSignalsRequest) updates) => super.copyWith((message) => updates(message as WatchSignalsRequest)) as WatchSignalsRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WatchSignalsRequest create() => WatchSignalsRequest._();
  WatchSignalsRequest createEmptyInstance() => create();
  static $pb.PbList<WatchSignalsRequest> createRepeated() => $pb.PbList<WatchSignalsRequest>();
  @$core.pragma('dart2js:noInline')
  static WatchSignalsRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<WatchSignalsRequest>(create);
  static WatchSignalsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get deviceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set deviceId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasDeviceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearDeviceId() => clearField(2);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
