import 'package:application_base/presentation/view_model/access_vm.dart';
import 'package:get_it/get_it.dart';

/// Common instance for service locator
final getIt = GetIt.instance;

abstract final class ServiceLocatorBase {
  /// Setup service locator
  static void prepare() {
    getIt.registerLazySingleton<AccessVM>(AccessVM.new);
  }
}
