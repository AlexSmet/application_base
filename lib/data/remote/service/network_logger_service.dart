import 'package:application_base/core/service/logger_service.dart';
import 'package:application_base/core/service/platform_service.dart';
import 'package:application_base/data/remote/const/request_type.dart';
import 'package:http/http.dart';

/// Is it possible to send sensitive information to remote logger or not
bool get _sendSensitive => isDebug;

/// Logging request
void logRequestSending({
  required RequestType request,
  required String? body,
}) {
  String information = 'Request ${request.type} ${request.path} sending';
  if (_sendSensitive && body != null) information += '\nBody $body';
  logInfo(info: information);
}

/// Logging request information
void logRequestInfo({
  required RequestType request,
  required String info,
}) =>
    logInfo(info: 'Request ${request.type} ${request.path}\n$info');

/// Logging request error
void logRequestError({
  required RequestType request,
  required String error,
}) =>
    logError(error: 'Request ${request.type} ${request.path}\n$error');

/// Logging response
void logResponseGot({
  required RequestType request,
  required Response response,
}) {
  String information = 'Request ${request.type} ${request.path}\n'
      'Response ${response.statusCode}';
  if (_sendSensitive && response.body.isNotEmpty) {
    information += '\nBody ${response.body}';
  }
  logInfo(info: information);
}

/// Error in response
void logResponseError({
  required RequestType request,
  required int statusCode,
  String message = '',
}) {
  String error = 'Request ${request.type} ${request.path}\n'
      'Response $statusCode';
  if (message.isNotEmpty) error += ' - $message';
  logError(error: error);
}

/// Error on JSON parsing
void logJsonParsingError({
  required String json,
  required String info,
  String? source,
}) {
  String error = 'Request $source\n'
      'Got JSON parsing error $info';
  if (_sendSensitive) error += '\n$json';
  logError(error: error);
}

///
void logTokenEmptyError({required RequestType request}) => logInfo(
      info: 'Request ${request.type} ${request.path}\n'
          'Can not be sent without token',
    );
