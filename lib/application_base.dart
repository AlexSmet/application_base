import 'package:application_base/core/service/service_locator.dart';
import 'package:application_base/presentation/navigation/navigation_service.dart';
import 'package:auto_route/auto_route.dart';

abstract final class ApplicationBase {
  ///
  static void prepare({RootStackRouter? routerInstance}) {
    /// Setup service locator
    ServiceLocatorBase.prepare();

    /// Set base application router
    if (routerInstance != null) {
      router = routerInstance;
    }
  }
}
