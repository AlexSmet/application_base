import 'package:application_base/data/remote/service/connectivity_service.dart';
import 'package:application_base/presentation/service/lifecycle_service.dart';
import 'package:application_base/presentation/view_model/access_vm.dart';
import 'package:get_it/get_it.dart';

/// Common instance for service locator
final getIt = GetIt.instance;

abstract final class ServiceLocatorBase {
  /// Setup service locator
  static void prepare() {
    getIt

      /// Data layer
      ..registerLazySingleton<ConnectivityService>(ConnectivityService.new)

      /// Presentation layer
      ..registerLazySingleton<LifecycleService>(LifecycleService.new)
      ..registerLazySingleton<AccessVM>(AccessVM.new);
  }
}
