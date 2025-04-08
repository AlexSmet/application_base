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

  /// Success status code - for now it's 200 & 201.
  /// Maybe it's better to use here all 2xx codes
  bool get isOk => statusCode == 200 || statusCode == 201;

  /// Not success status code - for now it's every code except 200 & 201
  bool get isNotOk => !isOk;
}
