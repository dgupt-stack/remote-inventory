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

import 'package:protobuf/protobuf.dart' as $pb;

class NavigationCommand_Direction extends $pb.ProtobufEnum {
  static const NavigationCommand_Direction UNKNOWN = NavigationCommand_Direction._(0, _omitEnumNames ? '' : 'UNKNOWN');
  static const NavigationCommand_Direction LEFT = NavigationCommand_Direction._(1, _omitEnumNames ? '' : 'LEFT');
  static const NavigationCommand_Direction RIGHT = NavigationCommand_Direction._(2, _omitEnumNames ? '' : 'RIGHT');
  static const NavigationCommand_Direction UP = NavigationCommand_Direction._(3, _omitEnumNames ? '' : 'UP');
  static const NavigationCommand_Direction DOWN = NavigationCommand_Direction._(4, _omitEnumNames ? '' : 'DOWN');
  static const NavigationCommand_Direction FORWARD = NavigationCommand_Direction._(5, _omitEnumNames ? '' : 'FORWARD');
  static const NavigationCommand_Direction BACKWARD = NavigationCommand_Direction._(6, _omitEnumNames ? '' : 'BACKWARD');

  static const $core.List<NavigationCommand_Direction> values = <NavigationCommand_Direction> [
    UNKNOWN,
    LEFT,
    RIGHT,
    UP,
    DOWN,
    FORWARD,
    BACKWARD,
  ];

  static final $core.Map<$core.int, NavigationCommand_Direction> _byValue = $pb.ProtobufEnum.initByValue(values);
  static NavigationCommand_Direction? valueOf($core.int value) => _byValue[value];

  const NavigationCommand_Direction._($core.int v, $core.String n) : super(v, n);
}

class ZoomCommand_ZoomType extends $pb.ProtobufEnum {
  static const ZoomCommand_ZoomType IN = ZoomCommand_ZoomType._(0, _omitEnumNames ? '' : 'IN');
  static const ZoomCommand_ZoomType OUT = ZoomCommand_ZoomType._(1, _omitEnumNames ? '' : 'OUT');
  static const ZoomCommand_ZoomType RESET = ZoomCommand_ZoomType._(2, _omitEnumNames ? '' : 'RESET');

  static const $core.List<ZoomCommand_ZoomType> values = <ZoomCommand_ZoomType> [
    IN,
    OUT,
    RESET,
  ];

  static final $core.Map<$core.int, ZoomCommand_ZoomType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static ZoomCommand_ZoomType? valueOf($core.int value) => _byValue[value];

  const ZoomCommand_ZoomType._($core.int v, $core.String n) : super(v, n);
}

class ApprovalStatusUpdate_Status extends $pb.ProtobufEnum {
  static const ApprovalStatusUpdate_Status PENDING = ApprovalStatusUpdate_Status._(0, _omitEnumNames ? '' : 'PENDING');
  static const ApprovalStatusUpdate_Status APPROVED = ApprovalStatusUpdate_Status._(1, _omitEnumNames ? '' : 'APPROVED');
  static const ApprovalStatusUpdate_Status DENIED = ApprovalStatusUpdate_Status._(2, _omitEnumNames ? '' : 'DENIED');

  static const $core.List<ApprovalStatusUpdate_Status> values = <ApprovalStatusUpdate_Status> [
    PENDING,
    APPROVED,
    DENIED,
  ];

  static final $core.Map<$core.int, ApprovalStatusUpdate_Status> _byValue = $pb.ProtobufEnum.initByValue(values);
  static ApprovalStatusUpdate_Status? valueOf($core.int value) => _byValue[value];

  const ApprovalStatusUpdate_Status._($core.int v, $core.String n) : super(v, n);
}


const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
