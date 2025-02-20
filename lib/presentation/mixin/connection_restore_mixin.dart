import 'dart:async';

import 'package:application_base/core/service/service_locator.dart';
import 'package:application_base/domain/subject/network_subject.dart';
import 'package:meta/meta.dart';

// TODO(Alex): перенести в domain layer
base mixin ConnectionRestoreMixin {
  ///
  late StreamSubscription<NetworkEvent> _subscriptionConnection;

  ///
  void prepareConnection() {
    _subscriptionConnection = getIt<NetworkSubject>().listenConnectionRestore(
      onConnectionRestore,
    );
  }

  ///
  Future<void> disposeConnection() => _subscriptionConnection.cancel();

  ///
  @mustBeOverridden
  void onConnectionRestore();
}
