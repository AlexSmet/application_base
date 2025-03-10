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

  ///
  bool get isOk => statusCode == 200 || statusCode == 201;

  ///
  bool get isNotOk => !isOk;
}
