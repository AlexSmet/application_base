///
final class ResponseEntity {
  ///
  ResponseEntity({
    required this.body,
    required this.request,
    required this.statusCode,
  });

  ///
  final String body;

  ///
  final String request;

  ///
  final int statusCode;

  /// Success status code
  bool get isOk => statusCode >= 200 && statusCode < 300;

  /// Not success status code - for now it's every code except 200 & 201
  bool get isNotOk => !isOk;
}
