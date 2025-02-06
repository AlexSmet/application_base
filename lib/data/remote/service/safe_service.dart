import 'dart:convert';

import 'package:application_base/data/remote/entity/raw_data_entity.dart';
import 'package:application_base/data/remote/service/network_logger_service.dart';

/// Methods for safe work with entities
abstract final class SafeService {
  /// Safe parse JSON with list from string
  static List<Type> parseList<Type>(
    RawDataEntity rawData,
    Type Function(Map<String, dynamic> json) parseFunction,
  ) {
    if (rawData.data.isEmpty) return [];
    try {
      final Object decodedData = json.decode(rawData.data) as Object;
      if (decodedData is! List) throw Exception('JSON is not a list');
      final List<Type> result = [];
      for (final element in decodedData) {
        try {
          result.add(parseFunction(element as Map<String, dynamic>));
        } catch (e) {
          /// Error with one of items in list, log it
          logJsonParsingError(
            json: rawData.data,
            info: e.toString(),
            source: rawData.source,
          );
        }
      }
      return result;
    } catch (e) {
      /// Log it
      logJsonParsingError(
        json: rawData.data,
        info: e.toString(),
        source: rawData.source,
      );
    }
    return [];
  }

  /// Safe parse JSON from string
  static Type? parse<Type>(
    RawDataEntity rawData,
    Type Function(Map<String, dynamic> json) parseFunction,
  ) {
    if (rawData.data.isEmpty) return null;
    try {
      return parseFunction(jsonDecode(rawData.data) as Map<String, dynamic>);
    } catch (e) {
      /// Log it
      logJsonParsingError(
        json: rawData.data,
        info: e.toString(),
        source: rawData.source,
      );
    }
    return null;
  }
}
