import 'package:application_base/core/service/logger_service.dart';
import 'package:application_base/core/service/service_locator.dart';
import 'package:application_base/data/remote/service/connectivity_service.dart';
import 'package:flutter/widgets.dart';

// Optimize(Alex): в дальнейшем можно будет добавить здесь PublishSubject
// для оперативного отслеживания смены статуса
/// Singleton
final class LifecycleService {
  ///
  final _connectivityService = getIt<ConnectivityService>();

  ///
  AppLifecycleListener? _listener;

  ///
  void prepare() {
    if (_listener != null) return;
    _listener = AppLifecycleListener(onStateChange: _onUpdate);
  }

  // Information(Alex): не используется, так как класс - одиночка с однократной
  // инициализацией при запуске приложения
  void dispose() {
    _listener?.dispose();
  }

  ///
  void _onUpdate(AppLifecycleState state) {
    logInfo(info: 'App state changed to $state');

    if (state == AppLifecycleState.resumed) {
      /// Need to check connectivity
      _connectivityService.getConnectivity();
    }
  }
}
