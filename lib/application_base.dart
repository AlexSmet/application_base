import 'package:application_base/core/service/service_locator.dart';

abstract final class ApplicationBase {
  ///
  static Future<void> prepare() async {
    /// Setup service locator
    ServiceLocatorBase.prepare();
  }
}
