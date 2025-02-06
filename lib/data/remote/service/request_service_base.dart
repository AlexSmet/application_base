import 'dart:async';
import 'dart:io';

import 'package:application_base/core/service/service_locator.dart';
import 'package:application_base/data/remote/const/network_event.dart';
import 'package:application_base/data/remote/const/request_type.dart';
import 'package:application_base/data/remote/service/network_logger_service.dart';
import 'package:application_base/data/remote/service/request_timeout_service.dart';
import 'package:application_base/domain/subject/network_subject.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';

/// Extended class should be a singleton
abstract base class RequestServiceBase {
  // Optimize(Alex): попробовать заменить на RetryClient для автоматического
  // перезапроса в случае ошибок https://pub.dev/packages/http#retrying-requests
  // Настроить обработку ошибок - как минимум исключить 401.
  /// https://dart.dev/tutorials/server/fetch-data#make-multiple-requests
  final _client = Client();

  ///
  final _connectionSubject = getIt<NetworkSubject>();

  ///
  @mustBeOverridden
  Uri prepareUri({required String path});

  /// Return **null** only if got error with unified application behaviour
  /// via **errorSubject** stream (for example - `no connection` or
  /// `need authorization` errors), so it's not necessary to do something
  /// special in this case.
  ///
  /// Otherwise return **Response** with necessary information.
  Future<Response?> send({
    required RequestType request,
    required Map<String, String> headers,
  }) async {
    try {
      ///
      final Uri uri = prepareUri(path: request.path);

      /// Log request
      logRequestSending(request: request, body: request.body?.toString());

      /// Prepare response
      final Future<Response> futureResponse = switch (request) {
        RequestGet() => _client.get(
            uri,
            headers: headers,
          ),
        RequestPost() => _client.post(
            uri,
            headers: headers,
            body: request.body,
          ),
        RequestPostWithFile() => _sendPostForm(
            uri,
            headers: headers,
            requestData: request,
          ),
        RequestPut() => _client.put(
            uri,
            headers: headers,
            body: request.body,
          ),
        RequestDelete() => _client.delete(
            uri,
            headers: headers,
            body: request.body,
          ),
      };

      /// Send response
      final Response response = await futureResponse
          .timeout(RequestTimeoutService.timeout(request.durationType));

      /// Log response
      logResponseGot(request: request, response: response);

      /// Check it
      if (!request.expectedStatusList.contains(response.statusCode)) {
        if (response.statusCode == HttpStatus.unauthorized) {
          return await _onUnauthorized(request: request);
        }
        if (response.statusCode == HttpStatus.gatewayTimeout) {
          logResponseError(request: request, statusCode: response.statusCode);
          _notify(NetworkConnectionLost());
          return null;
        }

        /// Try to get expected error type
        final NetworkEvent? expectedErrorType =
            request.expectedErrorMap[response.statusCode];
        if (expectedErrorType != null) {
          /// Custom handler
          _notify(expectedErrorType, silence: request.silence);

          /// But also need to log it
          logResponseError(
            request: request,
            statusCode: response.statusCode,
            message: 'expected error',
          );
          return null;
        }

        /// Handle it as unexpected response
        logResponseError(
          request: request,
          statusCode: response.statusCode,
          message: 'unexpected error',
        );
        _notify(NetworkUnexpectedResponse(), silence: request.silence);
        return null;
      }

      /// Expected response, just return it
      _notify(NetworkSuccess(), silence: request.silence);

      return response;
    } on TimeoutException {
      /// Time is out
      logRequestInfo(request: request, info: 'Timeout exception');
      _notify(NetworkRequestTimeout(), silence: request.silence);
    } on SocketException catch (error) {
      if (error.message.contains('Failed host lookup')) {
        /// Only on Android, iOS send timeout exception
        logRequestInfo(request: request, info: 'No connection');
        // Information(Alex): По факту здесь должно быть noConnection, но его
        // используем только для включения офлайн режима,
        // тогда как здесь этого делать не нужно
        _notify(NetworkRequestTimeout(), silence: request.silence);
      } else {
        ///
        logRequestError(
          request: request,
          error: 'Socket exception ${error.message}',
        );
        _notify(NetworkUnexpectedError(), silence: request.silence);
      }
    } on HandshakeException catch (error) {
      /// SSL problem on backend side, need to activate offline mode
      logRequestError(request: request, error: error.message);
      _notify(NetworkConnectionLost());
    } catch (error) {
      /// Something is crashed
      logRequestError(request: request, error: error.toString());
      _notify(NetworkUnexpectedError(), silence: request.silence);
    }
    return null;
  }

  /// Just log an error and notify subjects by default.
  /// Can be overriden for refresh token and re-send request, for example.
  Future<Response?> _onUnauthorized({required RequestType request}) async {
    logResponseError(request: request, statusCode: 401);
    _notify(NetworkUnauthorized());
    return null;
  }

  ///
  void _notify(NetworkEvent type, {bool silence = false}) {
    if (silence) return;
    _connectionSubject.add(type);
  }

  // TODO(Alex): web is not supported for now because of MultipartFile
  Future<Response> _sendPostForm(
    Uri url, {
    required Map<String, String> headers,
    required RequestPostWithFile requestData,
  }) async {
    /// Prepearing request
    final request = MultipartRequest('POST', url);

    /// Add body data
    if (requestData.body != null) request.fields.addAll(requestData.body!);

    /// Add headers
    request.headers.addAll(headers);

    /// Add file
    requestData.files.forEach(
      (String field, String path) async => request.files.add(
        await MultipartFile.fromPath(field, path),
      ),
    );

    /// Sending request
    return Response.fromStream(await request.send());
  }
}
