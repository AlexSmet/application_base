///
sealed class NetworkEvent {
  ///
  NetworkEvent({this.data});

  ///
  final Object? data;
}

/// Request sent successfully, got response with expected status code
final class NetworkSuccess extends NetworkEvent {
  ///
  NetworkSuccess({super.data});
}

/// Internet or backend connection successfully restore
final class NetworkRestore extends NetworkEvent {
  ///
  NetworkRestore({super.data});
}

/// There is no internet connection or backend is down
final class NetworkConnectionLost extends NetworkEvent {
  ///
  NetworkConnectionLost({super.data});
}

/// Request cancelled by timeout
final class NetworkRequestTimeout extends NetworkEvent {
  ///
  NetworkRequestTimeout({super.data});
}

/// Got 401 HTTP status
final class NetworkUnauthorized extends NetworkEvent {
  ///
  NetworkUnauthorized({super.data});
}

/// Got 404 HTTP status
final class NetworkNotFound extends NetworkEvent {
  ///
  NetworkNotFound({super.data});
}

/// Got a response with unexpected HTTP status
final class NetworkUnexpectedResponse extends NetworkEvent {
  ///
  NetworkUnexpectedResponse({super.data});
}

/// Got an error while sending request
final class NetworkUnexpectedError extends NetworkEvent {
  ///
  NetworkUnexpectedError({super.data});
}
