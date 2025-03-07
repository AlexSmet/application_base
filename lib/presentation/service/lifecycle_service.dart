import 'dart:async';

import 'package:application_base/core/service/logger_service.dart';
import 'package:application_base/core/service/service_locator.dart';
import 'package:application_base/data/remote/service/connectivity_service.dart';
import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';

/// Singleton
final class LifecycleService {
  ///
  final _connectivityService = getIt<ConnectivityService>();

  ///
  final _lifecycleSubject = PublishSubject<AppLifecycleState>();

  ///
  AppLifecycleListener? _listener;

  ///
  AppLifecycleState _actualState = AppLifecycleState.resumed;

  ///
  AppLifecycleState get actualState => _actualState;

  ///
  void prepare() {
    if (_listener != null) return;
    _listener = AppLifecycleListener(onStateChange: _onUpdate);
  }

  ///
  void dispose() {
    _listener?.dispose();
    _lifecycleSubject.close();
  }

  ///
  void _onUpdate(AppLifecycleState state) {
    logInfo(info: 'App state changed from $actualState to $state');
    _actualState = state;

    if (state == AppLifecycleState.resumed) {
      /// Need to check connectivity
      _connectivityService.getConnectivity();
    }
    _lifecycleSubject.add(state);
  }

  ///
  StreamSubscription<AppLifecycleState> listen(
    void Function(AppLifecycleState) onData,
  ) =>
      _lifecycleSubject.listen(onData);
}
