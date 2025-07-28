import 'dart:io';

import 'package:application_base/data/remote/const/network_event.dart';
import 'package:application_base/data/remote/const/request_duration_type.dart';
import 'package:cross_file/cross_file.dart';

/// API request type with all necessary data
sealed class RequestType {
  ///
  RequestType({
    required this.type,
    required this.path,
    this.expectedStatusList = const [HttpStatus.ok],
    this.expectedErrorMap = const {},
    this.silence = false,
    this.durationType = RequestDurationType.normal,
  });

  /// Type name for logging
  final String type;

  /// Path for request without address and base API segment
  final String path;

  /// Body for request
  Object? get body;

  /// Expected response statuse list in API endpoint
  List<int> expectedStatusList;

  /// Expected response pair `HTTP status -> Network event` map in API endpoint
  Map<int, NetworkEvent> expectedErrorMap;

  /// Do not show error on silence mode
  final bool silence;

  /// Average request duration type
  final RequestDurationType durationType;
}

///
final class RequestGet extends RequestType {
  ///
  RequestGet({
    required super.path,
    super.expectedStatusList = const [HttpStatus.ok],
    super.expectedErrorMap = const {},
    super.silence = false,
    super.durationType = RequestDurationType.normal,
  }) : super(type: 'GET');

  /// Body for request
  @override
  final Object? body = null;
}

///
final class RequestPost extends RequestType {
  ///
  RequestPost({
    required super.path,
    this.body,
    super.expectedStatusList = const [HttpStatus.ok],
    super.expectedErrorMap = const {},
    super.silence = false,
    super.durationType = RequestDurationType.normal,
  }) : super(type: 'POST');

  /// Body for request
  @override
  final String? body;
}

///
final class RequestPostFormData extends RequestType {
  ///
  RequestPostFormData({
    required super.path,
    this.body,
    this.files = const {},
    super.expectedStatusList = const [HttpStatus.ok],
    super.expectedErrorMap = const {},
    super.silence = false,
  }) : super(type: 'POST with files');

  /// Body for request in JSON
  @override
  final Map<String, String>? body;

  /// Field name and path to local file
  final Map<String, XFile> files;
}

///
final class RequestPut extends RequestType {
  ///
  RequestPut({
    required super.path,
    this.body,
    super.expectedStatusList = const [HttpStatus.ok],
    super.expectedErrorMap = const {},
    super.silence = false,
    super.durationType = RequestDurationType.normal,
  }) : super(type: 'PUT');

  /// Body for request
  @override
  final String? body;
}

///
final class RequestPatch extends RequestType {
  ///
  RequestPatch({
    required super.path,
    this.body,
    super.expectedStatusList = const [HttpStatus.ok],
    super.expectedErrorMap = const {},
    super.silence = false,
    super.durationType = RequestDurationType.normal,
  }) : super(type: 'PATCH');

  /// Body for request
  @override
  final String? body;
}

///
final class RequestDelete extends RequestType {
  ///
  RequestDelete({
    required super.path,
    this.body,
    super.expectedStatusList = const [HttpStatus.ok],
    super.expectedErrorMap = const {},
    super.silence = false,
    super.durationType = RequestDurationType.normal,
  }) : super(type: 'DELETE');

  /// Body for request
  @override
  final String? body;
}
