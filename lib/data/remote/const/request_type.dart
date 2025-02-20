import 'dart:io';

import 'package:application_base/data/remote/const/network_event.dart';
import 'package:application_base/data/remote/const/request_duration_type.dart';

/// API request type with all necessary data
sealed class RequestType {
  /// Type name for logging
  final String type = '';

  /// Path for request without address and base API segment
  final String path = '';

  /// Body for request
  final Object? body = null;

  /// Expected response statuse list in API endpoint
  List<int> expectedStatusList = [];

  /// Expected response pair `HTTP status -> Network event` map in API endpoint
  final Map<int, NetworkEvent> expectedErrorMap = {};

  /// Do not show error on silence mode
  final bool silence = false;

  /// Average request duration type
  final durationType = RequestDurationType.normal;
}

// TODO(Alex): здесь и далее заменить на extends добавив конструктор в базовый
// класс, тогда у наследников можно будет убрать @override'ы и они сильно
// сократяться в размерах, уйдет дублирование
final class RequestGet implements RequestType {
  ///
  RequestGet({
    required this.path,
    this.expectedStatusList = const [HttpStatus.ok],
    this.expectedErrorMap = const {},
    this.silence = false,
    this.durationType = RequestDurationType.normal,
  });

  /// Type name for logging
  @override
  final String type = 'GET';

  /// Path for request without address and base API segment
  @override
  final String path;

  /// Body for request
  @override
  final Object? body = null;

  /// Expected response statuses in API endpoint
  @override
  List<int> expectedStatusList;

  /// Expected response errors in API endpoint
  @override
  final Map<int, NetworkEvent> expectedErrorMap;

  /// Do not show error on silence mode
  @override
  final bool silence;

  /// Average request duration type
  @override
  final RequestDurationType durationType;
}

///
final class RequestPost implements RequestType {
  ///
  RequestPost({
    required this.path,
    this.body,
    this.expectedStatusList = const [HttpStatus.ok],
    this.expectedErrorMap = const {},
    this.silence = false,
    this.durationType = RequestDurationType.normal,
  });

  /// Type name for logging
  @override
  final String type = 'POST';

  /// Path for request without address and base API segment
  @override
  final String path;

  /// Body for request
  @override
  final String? body;

  /// Expected response statuses in API endpoint
  @override
  List<int> expectedStatusList;

  /// Expected response events by status code in API endpoint
  @override
  final Map<int, NetworkEvent> expectedErrorMap;

  /// Do not show error on silence mode
  @override
  final bool silence;

  /// Average request duration type
  @override
  final RequestDurationType durationType;
}

///
final class RequestPostWithFile implements RequestType {
  ///
  RequestPostWithFile({
    required this.path,
    required this.files,
    this.body,
    this.expectedStatusList = const [HttpStatus.ok],
    this.expectedErrorMap = const {},
    this.silence = false,
  });

  /// Type name for logging
  @override
  final String type = 'POST with file';

  /// Path for request without address and base API segment
  @override
  final String path;

  /// Body for request
  @override
  final Map<String, String>? body;

  /// Expected response statuses in API endpoint
  @override
  List<int> expectedStatusList;

  /// Expected response errors in API endpoint
  @override
  final Map<int, NetworkEvent> expectedErrorMap;

  /// Do not show error on silence mode
  @override
  final bool silence;

  /// Average request duration type
  @override
  final RequestDurationType durationType = RequestDurationType.long;

  /// Field name and path to local file
  final Map<String, String> files;
}

///
final class RequestPut implements RequestType {
  ///
  RequestPut({
    required this.path,
    this.body,
    this.expectedStatusList = const [HttpStatus.ok],
    this.expectedErrorMap = const {},
    this.silence = false,
    this.durationType = RequestDurationType.normal,
  });

  /// Type name for logging
  @override
  final String type = 'PUT';

  /// Path for request without address and base API segment
  @override
  final String path;

  /// Body for request
  @override
  final String? body;

  /// Expected response statuses in API endpoint
  @override
  List<int> expectedStatusList;

  /// Expected response errors in API endpoint
  @override
  final Map<int, NetworkEvent> expectedErrorMap;

  /// Do not show error on silence mode
  @override
  final bool silence;

  /// Average request duration type
  @override
  final RequestDurationType durationType;
}

///
final class RequestDelete implements RequestType {
  ///
  RequestDelete({
    required this.path,
    this.body,
    this.expectedStatusList = const [HttpStatus.ok],
    this.expectedErrorMap = const {},
    this.silence = false,
    this.durationType = RequestDurationType.normal,
  });

  /// Type name for logging
  @override
  final String type = 'DELETE';

  /// Path for request without address and base API segment
  @override
  final String path;

  /// Body for request
  @override
  final String? body;

  /// Expected response statuses in API endpoint
  @override
  List<int> expectedStatusList;

  /// Expected response errors in API endpoint
  @override
  final Map<int, NetworkEvent> expectedErrorMap;

  /// Do not show error on silence mode
  @override
  final bool silence;

  /// Average request duration type
  @override
  final RequestDurationType durationType;
}
