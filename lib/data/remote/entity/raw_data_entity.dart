///
final class RawDataEntity {
  ///
  RawDataEntity({
    required this.data,
    required this.source,
  });

  /// Raw data - for example non-parsed string from backend
  String data;

  /// Source of data - for logging
  String source;
}
