import 'package:application_base/core/const/flavor_type.dart';
import 'package:application_base/core/service/configuration_service.dart';
import 'package:application_base/core/service/service_locator.dart';
import 'package:application_base/presentation/navigation/navigation_service.dart';
import 'package:auto_route/auto_route.dart';

abstract final class ApplicationBase {
  ///
  static void prepare({
    FlavorType? currentFlavor,
    RootStackRouter? routerInstance,
  }) {
    /// Setup service locator
    ServiceLocatorBase.prepare();

    /// Set flator
    if (currentFlavor != null) flavor = currentFlavor;

    /// Set base application router
    if (routerInstance != null) {
      router = routerInstance;
    }
  }
}
