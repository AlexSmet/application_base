///
sealed class FlavorType {
  /// Flavor name for logger
  final String name = '';
}

/// Development release version with test functionality
final class FlavorDevelopment implements FlavorType {
  ///
  @override
  final String name = 'Development';
}

/// Production release version without test functionality
final class FlavorProduction implements FlavorType {
  ///
  @override
  final String name = 'Production';
}
