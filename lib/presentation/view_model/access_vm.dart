import 'package:application_base/core/service/logger_service.dart';
import 'package:application_base/presentation/navigation/navigation_service.dart';
import 'package:flutter/foundation.dart';

///
final class AccessVM with ChangeNotifier {
  ///
  AccessVM._();

  ///
  factory AccessVM.singleton() => _instance;

  ///
  static final _instance = AccessVM._();

  ///
  bool _isGranted = false;

  ///
  bool get isGranted => _isGranted;

  ///
  void grantAccess() => _changeGrantedState(isAccessGranted: true);

  ///
  void revokeAccess({required bool needNotify}) => _changeGrantedState(
        isAccessGranted: false,
        needNotify: needNotify,
      );

  /// Auto route to authorization screen on **needNotify** is true,
  /// auto return to current route after success authorization
  ///
  /// Overwise replace all screens to default so it will trigger authorization
  /// screen opening as on notifing but will be opened main route after success
  /// authorization
  void _changeGrantedState({
    required bool isAccessGranted,
    bool needNotify = true,
  }) {
    _isGranted = isAccessGranted;
    if (!_isGranted) {
      if (needNotify) {
        /// Notify only on access revoking
        /// Because on access granting the application have special behaviour
        notifyListeners();
      } else {
        /// Just open default screen, navigator will do all over itself
        openDefaultScreen();
      }
    }
    logInfo(info: 'Access state: $_isGranted');
  }
}
