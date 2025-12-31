//
//  Generated code. Do not modify.
//  source: inventory_service.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use createSessionRequestDescriptor instead')
const CreateSessionRequest$json = {
  '1': 'CreateSessionRequest',
  '2': [
    {'1': 'provider_id', '3': 1, '4': 1, '5': 9, '10': 'providerId'},
    {'1': 'provider_name', '3': 2, '4': 1, '5': 9, '10': 'providerName'},
  ],
};

/// Descriptor for `CreateSessionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createSessionRequestDescriptor = $convert.base64Decode(
    'ChRDcmVhdGVTZXNzaW9uUmVxdWVzdBIfCgtwcm92aWRlcl9pZBgBIAEoCVIKcHJvdmlkZXJJZB'
    'IjCg1wcm92aWRlcl9uYW1lGAIgASgJUgxwcm92aWRlck5hbWU=');

@$core.Deprecated('Use joinSessionRequestDescriptor instead')
const JoinSessionRequest$json = {
  '1': 'JoinSessionRequest',
  '2': [
    {'1': 'session_id', '3': 1, '4': 1, '5': 9, '10': 'sessionId'},
    {'1': 'consumer_id', '3': 2, '4': 1, '5': 9, '10': 'consumerId'},
    {'1': 'consumer_name', '3': 3, '4': 1, '5': 9, '10': 'consumerName'},
  ],
};

/// Descriptor for `JoinSessionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List joinSessionRequestDescriptor = $convert.base64Decode(
    'ChJKb2luU2Vzc2lvblJlcXVlc3QSHQoKc2Vzc2lvbl9pZBgBIAEoCVIJc2Vzc2lvbklkEh8KC2'
    'NvbnN1bWVyX2lkGAIgASgJUgpjb25zdW1lcklkEiMKDWNvbnN1bWVyX25hbWUYAyABKAlSDGNv'
    'bnN1bWVyTmFtZQ==');

@$core.Deprecated('Use sessionResponseDescriptor instead')
const SessionResponse$json = {
  '1': 'SessionResponse',
  '2': [
    {'1': 'session_id', '3': 1, '4': 1, '5': 9, '10': 'sessionId'},
    {'1': 'token', '3': 2, '4': 1, '5': 9, '10': 'token'},
    {'1': 'success', '3': 3, '4': 1, '5': 8, '10': 'success'},
    {'1': 'message', '3': 4, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `SessionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sessionResponseDescriptor = $convert.base64Decode(
    'Cg9TZXNzaW9uUmVzcG9uc2USHQoKc2Vzc2lvbl9pZBgBIAEoCVIJc2Vzc2lvbklkEhQKBXRva2'
    'VuGAIgASgJUgV0b2tlbhIYCgdzdWNjZXNzGAMgASgIUgdzdWNjZXNzEhgKB21lc3NhZ2UYBCAB'
    'KAlSB21lc3NhZ2U=');

@$core.Deprecated('Use endSessionRequestDescriptor instead')
const EndSessionRequest$json = {
  '1': 'EndSessionRequest',
  '2': [
    {'1': 'session_id', '3': 1, '4': 1, '5': 9, '10': 'sessionId'},
    {'1': 'token', '3': 2, '4': 1, '5': 9, '10': 'token'},
  ],
};

/// Descriptor for `EndSessionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List endSessionRequestDescriptor = $convert.base64Decode(
    'ChFFbmRTZXNzaW9uUmVxdWVzdBIdCgpzZXNzaW9uX2lkGAEgASgJUglzZXNzaW9uSWQSFAoFdG'
    '9rZW4YAiABKAlSBXRva2Vu');

@$core.Deprecated('Use endSessionResponseDescriptor instead')
const EndSessionResponse$json = {
  '1': 'EndSessionResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
  ],
};

/// Descriptor for `EndSessionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List endSessionResponseDescriptor = $convert.base64Decode(
    'ChJFbmRTZXNzaW9uUmVzcG9uc2USGAoHc3VjY2VzcxgBIAEoCFIHc3VjY2Vzcw==');

@$core.Deprecated('Use providerMessageDescriptor instead')
const ProviderMessage$json = {
  '1': 'ProviderMessage',
  '2': [
    {'1': 'session_id', '3': 1, '4': 1, '5': 9, '10': 'sessionId'},
    {'1': 'token', '3': 2, '4': 1, '5': 9, '10': 'token'},
    {'1': 'video_frame', '3': 3, '4': 1, '5': 11, '6': '.inventory.VideoFrame', '9': 0, '10': 'videoFrame'},
    {'1': 'sensor_data', '3': 4, '4': 1, '5': 11, '6': '.inventory.SensorData', '9': 0, '10': 'sensorData'},
    {'1': 'status', '3': 5, '4': 1, '5': 11, '6': '.inventory.ProviderStatus', '9': 0, '10': 'status'},
  ],
  '8': [
    {'1': 'payload'},
  ],
};

/// Descriptor for `ProviderMessage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List providerMessageDescriptor = $convert.base64Decode(
    'Cg9Qcm92aWRlck1lc3NhZ2USHQoKc2Vzc2lvbl9pZBgBIAEoCVIJc2Vzc2lvbklkEhQKBXRva2'
    'VuGAIgASgJUgV0b2tlbhI4Cgt2aWRlb19mcmFtZRgDIAEoCzIVLmludmVudG9yeS5WaWRlb0Zy'
    'YW1lSABSCnZpZGVvRnJhbWUSOAoLc2Vuc29yX2RhdGEYBCABKAsyFS5pbnZlbnRvcnkuU2Vuc2'
    '9yRGF0YUgAUgpzZW5zb3JEYXRhEjMKBnN0YXR1cxgFIAEoCzIZLmludmVudG9yeS5Qcm92aWRl'
    'clN0YXR1c0gAUgZzdGF0dXNCCQoHcGF5bG9hZA==');

@$core.Deprecated('Use videoFrameDescriptor instead')
const VideoFrame$json = {
  '1': 'VideoFrame',
  '2': [
    {'1': 'frame_data', '3': 1, '4': 1, '5': 12, '10': 'frameData'},
    {'1': 'timestamp_ms', '3': 2, '4': 1, '5': 3, '10': 'timestampMs'},
    {'1': 'width', '3': 3, '4': 1, '5': 5, '10': 'width'},
    {'1': 'height', '3': 4, '4': 1, '5': 5, '10': 'height'},
    {'1': 'is_blurred', '3': 5, '4': 1, '5': 8, '10': 'isBlurred'},
  ],
};

/// Descriptor for `VideoFrame`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List videoFrameDescriptor = $convert.base64Decode(
    'CgpWaWRlb0ZyYW1lEh0KCmZyYW1lX2RhdGEYASABKAxSCWZyYW1lRGF0YRIhCgx0aW1lc3RhbX'
    'BfbXMYAiABKANSC3RpbWVzdGFtcE1zEhQKBXdpZHRoGAMgASgFUgV3aWR0aBIWCgZoZWlnaHQY'
    'BCABKAVSBmhlaWdodBIdCgppc19ibHVycmVkGAUgASgIUglpc0JsdXJyZWQ=');

@$core.Deprecated('Use sensorDataDescriptor instead')
const SensorData$json = {
  '1': 'SensorData',
  '2': [
    {'1': 'accelerometer_x', '3': 1, '4': 1, '5': 2, '10': 'accelerometerX'},
    {'1': 'accelerometer_y', '3': 2, '4': 1, '5': 2, '10': 'accelerometerY'},
    {'1': 'accelerometer_z', '3': 3, '4': 1, '5': 2, '10': 'accelerometerZ'},
    {'1': 'compass_heading', '3': 4, '4': 1, '5': 2, '10': 'compassHeading'},
    {'1': 'gyroscope_x', '3': 5, '4': 1, '5': 2, '10': 'gyroscopeX'},
    {'1': 'gyroscope_y', '3': 6, '4': 1, '5': 2, '10': 'gyroscopeY'},
    {'1': 'gyroscope_z', '3': 7, '4': 1, '5': 2, '10': 'gyroscopeZ'},
  ],
};

/// Descriptor for `SensorData`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sensorDataDescriptor = $convert.base64Decode(
    'CgpTZW5zb3JEYXRhEicKD2FjY2VsZXJvbWV0ZXJfeBgBIAEoAlIOYWNjZWxlcm9tZXRlclgSJw'
    'oPYWNjZWxlcm9tZXRlcl95GAIgASgCUg5hY2NlbGVyb21ldGVyWRInCg9hY2NlbGVyb21ldGVy'
    'X3oYAyABKAJSDmFjY2VsZXJvbWV0ZXJaEicKD2NvbXBhc3NfaGVhZGluZxgEIAEoAlIOY29tcG'
    'Fzc0hlYWRpbmcSHwoLZ3lyb3Njb3BlX3gYBSABKAJSCmd5cm9zY29wZVgSHwoLZ3lyb3Njb3Bl'
    'X3kYBiABKAJSCmd5cm9zY29wZVkSHwoLZ3lyb3Njb3BlX3oYByABKAJSCmd5cm9zY29wZVo=');

@$core.Deprecated('Use providerStatusDescriptor instead')
const ProviderStatus$json = {
  '1': 'ProviderStatus',
  '2': [
    {'1': 'camera_active', '3': 1, '4': 1, '5': 8, '10': 'cameraActive'},
    {'1': 'battery_level', '3': 2, '4': 1, '5': 5, '10': 'batteryLevel'},
  ],
};

/// Descriptor for `ProviderStatus`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List providerStatusDescriptor = $convert.base64Decode(
    'Cg5Qcm92aWRlclN0YXR1cxIjCg1jYW1lcmFfYWN0aXZlGAEgASgIUgxjYW1lcmFBY3RpdmUSIw'
    'oNYmF0dGVyeV9sZXZlbBgCIAEoBVIMYmF0dGVyeUxldmVs');

@$core.Deprecated('Use providerCommandDescriptor instead')
const ProviderCommand$json = {
  '1': 'ProviderCommand',
  '2': [
    {'1': 'navigation', '3': 1, '4': 1, '5': 11, '6': '.inventory.NavigationCommand', '9': 0, '10': 'navigation'},
    {'1': 'laser', '3': 2, '4': 1, '5': 11, '6': '.inventory.LaserCommand', '9': 0, '10': 'laser'},
    {'1': 'stop', '3': 3, '4': 1, '5': 11, '6': '.inventory.StopCommand', '9': 0, '10': 'stop'},
    {'1': 'zoom', '3': 4, '4': 1, '5': 11, '6': '.inventory.ZoomCommand', '9': 0, '10': 'zoom'},
  ],
  '8': [
    {'1': 'command'},
  ],
};

/// Descriptor for `ProviderCommand`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List providerCommandDescriptor = $convert.base64Decode(
    'Cg9Qcm92aWRlckNvbW1hbmQSPgoKbmF2aWdhdGlvbhgBIAEoCzIcLmludmVudG9yeS5OYXZpZ2'
    'F0aW9uQ29tbWFuZEgAUgpuYXZpZ2F0aW9uEi8KBWxhc2VyGAIgASgLMhcuaW52ZW50b3J5Lkxh'
    'c2VyQ29tbWFuZEgAUgVsYXNlchIsCgRzdG9wGAMgASgLMhYuaW52ZW50b3J5LlN0b3BDb21tYW'
    '5kSABSBHN0b3ASLAoEem9vbRgEIAEoCzIWLmludmVudG9yeS5ab29tQ29tbWFuZEgAUgR6b29t'
    'QgkKB2NvbW1hbmQ=');

@$core.Deprecated('Use navigationCommandDescriptor instead')
const NavigationCommand$json = {
  '1': 'NavigationCommand',
  '2': [
    {'1': 'direction', '3': 1, '4': 1, '5': 14, '6': '.inventory.NavigationCommand.Direction', '10': 'direction'},
    {'1': 'intensity', '3': 2, '4': 1, '5': 2, '10': 'intensity'},
  ],
  '4': [NavigationCommand_Direction$json],
};

@$core.Deprecated('Use navigationCommandDescriptor instead')
const NavigationCommand_Direction$json = {
  '1': 'Direction',
  '2': [
    {'1': 'UNKNOWN', '2': 0},
    {'1': 'LEFT', '2': 1},
    {'1': 'RIGHT', '2': 2},
    {'1': 'UP', '2': 3},
    {'1': 'DOWN', '2': 4},
    {'1': 'FORWARD', '2': 5},
    {'1': 'BACKWARD', '2': 6},
  ],
};

/// Descriptor for `NavigationCommand`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List navigationCommandDescriptor = $convert.base64Decode(
    'ChFOYXZpZ2F0aW9uQ29tbWFuZBJECglkaXJlY3Rpb24YASABKA4yJi5pbnZlbnRvcnkuTmF2aW'
    'dhdGlvbkNvbW1hbmQuRGlyZWN0aW9uUglkaXJlY3Rpb24SHAoJaW50ZW5zaXR5GAIgASgCUglp'
    'bnRlbnNpdHkiWgoJRGlyZWN0aW9uEgsKB1VOS05PV04QABIICgRMRUZUEAESCQoFUklHSFQQAh'
    'IGCgJVUBADEggKBERPV04QBBILCgdGT1JXQVJEEAUSDAoIQkFDS1dBUkQQBg==');

@$core.Deprecated('Use laserCommandDescriptor instead')
const LaserCommand$json = {
  '1': 'LaserCommand',
  '2': [
    {'1': 'active', '3': 1, '4': 1, '5': 8, '10': 'active'},
    {'1': 'screen_x', '3': 2, '4': 1, '5': 2, '10': 'screenX'},
    {'1': 'screen_y', '3': 3, '4': 1, '5': 2, '10': 'screenY'},
  ],
};

/// Descriptor for `LaserCommand`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List laserCommandDescriptor = $convert.base64Decode(
    'CgxMYXNlckNvbW1hbmQSFgoGYWN0aXZlGAEgASgIUgZhY3RpdmUSGQoIc2NyZWVuX3gYAiABKA'
    'JSB3NjcmVlblgSGQoIc2NyZWVuX3kYAyABKAJSB3NjcmVlblk=');

@$core.Deprecated('Use stopCommandDescriptor instead')
const StopCommand$json = {
  '1': 'StopCommand',
  '2': [
    {'1': 'emergency', '3': 1, '4': 1, '5': 8, '10': 'emergency'},
  ],
};

/// Descriptor for `StopCommand`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List stopCommandDescriptor = $convert.base64Decode(
    'CgtTdG9wQ29tbWFuZBIcCgllbWVyZ2VuY3kYASABKAhSCWVtZXJnZW5jeQ==');

@$core.Deprecated('Use zoomCommandDescriptor instead')
const ZoomCommand$json = {
  '1': 'ZoomCommand',
  '2': [
    {'1': 'type', '3': 1, '4': 1, '5': 14, '6': '.inventory.ZoomCommand.ZoomType', '10': 'type'},
    {'1': 'level', '3': 2, '4': 1, '5': 2, '10': 'level'},
  ],
  '4': [ZoomCommand_ZoomType$json],
};

@$core.Deprecated('Use zoomCommandDescriptor instead')
const ZoomCommand_ZoomType$json = {
  '1': 'ZoomType',
  '2': [
    {'1': 'IN', '2': 0},
    {'1': 'OUT', '2': 1},
    {'1': 'RESET', '2': 2},
  ],
};

/// Descriptor for `ZoomCommand`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List zoomCommandDescriptor = $convert.base64Decode(
    'Cgtab29tQ29tbWFuZBIzCgR0eXBlGAEgASgOMh8uaW52ZW50b3J5Llpvb21Db21tYW5kLlpvb2'
    '1UeXBlUgR0eXBlEhQKBWxldmVsGAIgASgCUgVsZXZlbCImCghab29tVHlwZRIGCgJJThAAEgcK'
    'A09VVBABEgkKBVJFU0VUEAI=');

@$core.Deprecated('Use consumerCommandDescriptor instead')
const ConsumerCommand$json = {
  '1': 'ConsumerCommand',
  '2': [
    {'1': 'session_id', '3': 1, '4': 1, '5': 9, '10': 'sessionId'},
    {'1': 'token', '3': 2, '4': 1, '5': 9, '10': 'token'},
    {'1': 'navigation', '3': 3, '4': 1, '5': 11, '6': '.inventory.NavigationCommand', '9': 0, '10': 'navigation'},
    {'1': 'laser', '3': 4, '4': 1, '5': 11, '6': '.inventory.LaserCommand', '9': 0, '10': 'laser'},
    {'1': 'stop', '3': 5, '4': 1, '5': 11, '6': '.inventory.StopCommand', '9': 0, '10': 'stop'},
    {'1': 'zoom', '3': 6, '4': 1, '5': 11, '6': '.inventory.ZoomCommand', '9': 0, '10': 'zoom'},
    {'1': 'voice', '3': 7, '4': 1, '5': 11, '6': '.inventory.VoiceCommand', '9': 0, '10': 'voice'},
    {'1': 'text', '3': 8, '4': 1, '5': 11, '6': '.inventory.TextCommand', '9': 0, '10': 'text'},
  ],
  '8': [
    {'1': 'command'},
  ],
};

/// Descriptor for `ConsumerCommand`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List consumerCommandDescriptor = $convert.base64Decode(
    'Cg9Db25zdW1lckNvbW1hbmQSHQoKc2Vzc2lvbl9pZBgBIAEoCVIJc2Vzc2lvbklkEhQKBXRva2'
    'VuGAIgASgJUgV0b2tlbhI+CgpuYXZpZ2F0aW9uGAMgASgLMhwuaW52ZW50b3J5Lk5hdmlnYXRp'
    'b25Db21tYW5kSABSCm5hdmlnYXRpb24SLwoFbGFzZXIYBCABKAsyFy5pbnZlbnRvcnkuTGFzZX'
    'JDb21tYW5kSABSBWxhc2VyEiwKBHN0b3AYBSABKAsyFi5pbnZlbnRvcnkuU3RvcENvbW1hbmRI'
    'AFIEc3RvcBIsCgR6b29tGAYgASgLMhYuaW52ZW50b3J5Llpvb21Db21tYW5kSABSBHpvb20SLw'
    'oFdm9pY2UYByABKAsyFy5pbnZlbnRvcnkuVm9pY2VDb21tYW5kSABSBXZvaWNlEiwKBHRleHQY'
    'CCABKAsyFi5pbnZlbnRvcnkuVGV4dENvbW1hbmRIAFIEdGV4dEIJCgdjb21tYW5k');

@$core.Deprecated('Use voiceCommandDescriptor instead')
const VoiceCommand$json = {
  '1': 'VoiceCommand',
  '2': [
    {'1': 'transcribed_text', '3': 1, '4': 1, '5': 9, '10': 'transcribedText'},
    {'1': 'confidence', '3': 2, '4': 1, '5': 2, '10': 'confidence'},
  ],
};

/// Descriptor for `VoiceCommand`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List voiceCommandDescriptor = $convert.base64Decode(
    'CgxWb2ljZUNvbW1hbmQSKQoQdHJhbnNjcmliZWRfdGV4dBgBIAEoCVIPdHJhbnNjcmliZWRUZX'
    'h0Eh4KCmNvbmZpZGVuY2UYAiABKAJSCmNvbmZpZGVuY2U=');

@$core.Deprecated('Use textCommandDescriptor instead')
const TextCommand$json = {
  '1': 'TextCommand',
  '2': [
    {'1': 'text', '3': 1, '4': 1, '5': 9, '10': 'text'},
  ],
};

/// Descriptor for `TextCommand`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List textCommandDescriptor = $convert.base64Decode(
    'CgtUZXh0Q29tbWFuZBISCgR0ZXh0GAEgASgJUgR0ZXh0');

@$core.Deprecated('Use heartbeatRequestDescriptor instead')
const HeartbeatRequest$json = {
  '1': 'HeartbeatRequest',
  '2': [
    {'1': 'session_id', '3': 1, '4': 1, '5': 9, '10': 'sessionId'},
    {'1': 'token', '3': 2, '4': 1, '5': 9, '10': 'token'},
    {'1': 'role', '3': 3, '4': 1, '5': 9, '10': 'role'},
  ],
};

/// Descriptor for `HeartbeatRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List heartbeatRequestDescriptor = $convert.base64Decode(
    'ChBIZWFydGJlYXRSZXF1ZXN0Eh0KCnNlc3Npb25faWQYASABKAlSCXNlc3Npb25JZBIUCgV0b2'
    'tlbhgCIAEoCVIFdG9rZW4SEgoEcm9sZRgDIAEoCVIEcm9sZQ==');

@$core.Deprecated('Use heartbeatResponseDescriptor instead')
const HeartbeatResponse$json = {
  '1': 'HeartbeatResponse',
  '2': [
    {'1': 'active', '3': 1, '4': 1, '5': 8, '10': 'active'},
    {'1': 'session_duration_ms', '3': 2, '4': 1, '5': 3, '10': 'sessionDurationMs'},
  ],
};

/// Descriptor for `HeartbeatResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List heartbeatResponseDescriptor = $convert.base64Decode(
    'ChFIZWFydGJlYXRSZXNwb25zZRIWCgZhY3RpdmUYASABKAhSBmFjdGl2ZRIuChNzZXNzaW9uX2'
    'R1cmF0aW9uX21zGAIgASgDUhFzZXNzaW9uRHVyYXRpb25Ncw==');

