import 'dart:async';
// TODO(Alex): избавиться
import 'dart:io';
import 'dart:typed_data';

import 'package:application_base/core/service/platform_service.dart';
import 'package:application_base/core/service/service_locator.dart';
import 'package:application_base/data/remote/const/request_type.dart';
import 'package:application_base/data/remote/service/network_logger_service.dart';
import 'package:application_base/data/remote/service/request_timeout_service.dart';
import 'package:application_base/domain/subject/network_subject.dart';
import 'package:cross_file/cross_file.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';

// TODO(Alex): временные константы из RequestTimeoutService и
// NetworkServiceBase перенести в этот класс - тогда при создании наследника
// этого класса можно будет просто переопределить константы при необходимости,
// а без переопределения будут использоваться дефолтные, как сейчас
///
/// Extended class should be a singleton
abstract base class RequestServiceBase {
  // Optimize(Alex): попробовать заменить на RetryClient для автоматического
  // перезапроса в случае ошибок https://pub.dev/packages/http#retrying-requests
  // Настроить обработку ошибок - как минимум исключить 401.
  /// https://dart.dev/tutorials/server/fetch-data#make-multiple-requests
  final _client = Client();

  ///
  final _networkSubject = getIt<NetworkSubject>();

  /// **isDebug** by default
  set logSensitive(bool newValue) {
    canLogSensitive = newValue;
  }

  ///
  @mustBeOverridden
  Uri prepareUri({required String path});

  // TODO(Alex): Преобразовать RawDataEntity в ResponseEntity и возвращать его
  // вместо Response. ResponseEntity будет независеть от текущего используемого
  // пакета (пока это http, в дальнейшем может быть мигрируем на dio или
  // добавим со временем что-то альтернативное, типа GraphQL) и содержать все
  // нужные данные (пока это только код и тело, в дальнейшем может ещё что
  // понадобится, сможем докинуть без потери обратной совместимости,
  // просто расширив класс)
  ///
  /// Return **null** only if got error with unified application behaviour
  /// via **errorSubject** stream (for example - `no connection` or
  /// `need authorization` errors), so it's not necessary to do something
  /// special in this case.
  ///
  /// Otherwise return **Response** with necessary information.
  Future<Response?> sendBase({
    required RequestType request,
    required Map<String, String> headers,
  }) async {
    try {
      ///
      final Uri uri = prepareUri(path: request.path);

      /// Log request
      logRequestInfo(
        request: request,
        body: request.body?.toString(),
        info: 'Sending',
      );

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

      /// Check it
      if (!request.expectedStatusList.contains(response.statusCode)) {
        /// Some error happened, log it
        logResponseError(request: request, response: response);

        if (response.statusCode == HttpStatus.unauthorized) {
          // To apply custom behaviour on unathorized response (for example to
          // refresh access token) add unauthorized status code to
          // expectedStatusList and check response manually (do not forget to
          // call `onUnauthorized` to notify `NetworkSubject`)
          notifyUnauthorized();
          return null;
        }
        if (response.statusCode == HttpStatus.gatewayTimeout) {
          _notify(NetworkConnectionLost());
          return null;
        }

        /// Try to get expected error type
        final NetworkEvent? expectedErrorType =
            request.expectedErrorMap[response.statusCode];
        if (expectedErrorType != null) {
          /// Custom handler
          _notify(expectedErrorType, silence: request.silence);
          return null;
        }

        /// Handle it as unexpected response
        _notify(NetworkUnexpectedResponse(), silence: request.silence);
        return null;
      }

      /// Expected response, just log it, notify and return
      logResponseInfo(request: request, response: response);
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

  /// Just notify subjects
  void notifyUnauthorized() => _notify(NetworkUnauthorized());

  ///
  void _notify(NetworkEvent type, {bool silence = false}) {
    if (silence) return;
    _networkSubject.add(type);
  }

  ///
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
    if (isWebBased) {
      /// And special header for web compatibility
      request.headers['Access-Control-Allow-Origin'] = '*';
      request.headers['Cache-Control'] = 'no-cache';
      request.headers['Content-Type'] = 'application/x-www-form-urlencoded';
    }

    /// Add file
    requestData.files.forEach((String field, XFile file) async {
      if (isMobileBased) {
        /// Mobile
        request.files.add(await MultipartFile.fromPath(field, file.path));
      } else {
        /// Web - need to use fromBytes instead of fromPath
        final Uint8List fileBytes = await file.readAsBytes();
        request.files.add(
          MultipartFile.fromBytes(
            field,
            fileBytes,
            filename: file.name,
          ),
        );
      }
    });

    /// Sending request
    return Response.fromStream(await request.send());
  }
}
