import 'package:application_base/core/service/logger_service.dart';
import 'package:application_base/data/remote/const/request_type.dart';
import 'package:http/http.dart';

/// Can send sensitive data to remote logger or not
bool canLogSensitive = false;

/// Logging request information
void logRequestInfo({
  required RequestType request,
  String? body,
  String? info,
}) {
  String information = 'Request ${request.type} ${request.path}';
  if (canLogSensitive && body != null) information += '\nBody $body';
  if (info != null) information += '\n$info';
  logInfo(info: information);
}

/// Logging request error
void logRequestError({
  required RequestType request,
  required String error,
}) =>
    logError(error: 'Request ${request.type} ${request.path}\n$error');

/// Logging response
void logResponseInfo({
  required RequestType request,
  required Response response,
}) {
  String information = 'Request ${request.type} ${request.path}\n'
      'Response ${response.statusCode}';
  if (canLogSensitive && response.body.isNotEmpty) {
    information += '\nBody ${response.body}';
  }
  logInfo(info: information);
}

/// Error in response
void logResponseError({
  required RequestType request,
  required Response response,
}) {
  String error = 'Request ${request.type} ${request.path}\n'
      'Response ${response.statusCode}';
  if (response.body.isNotEmpty) error += '\nBody ${response.body}';
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
  if (canLogSensitive) error += '\n$json';
  logError(error: error);
}

///
void logTokenEmptyError({required RequestType request}) => logInfo(
      info: 'Request ${request.type} ${request.path}\n'
          'Can not be sent without token',
    );
