import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kDebugMode, kIsWeb;

/// Note: using `Platform` on web throws exception,
/// so web checking must be the first

///
enum AvailablePlatform {
  ///
  android,

  ///
  iOS,

  ///
  macOS,

  ///
  windows,

  ///
  linux,

  ///
  fuchsia,

  ///
  web,
}

// Optimize(Alex): add list of supported platforms based on AvailablePlatform?

///
bool get isDebug => kDebugMode;

///
bool get isAndroid => !isWeb && Platform.isAndroid;

///
bool get isIOS => !isWeb && Platform.isIOS;

///
bool get isMacOS => !isWeb && Platform.isMacOS;

///
bool get isWindows => !isWeb && Platform.isWindows;

///
bool get isLinux => !isWeb && Platform.isLinux;

///
bool get isFuchsia => !isWeb && Platform.isFuchsia;

///
bool get isWeb => kIsWeb;

///
bool get isMobileBased => !isWeb && (isAndroid || isIOS || isFuchsia);

///
bool get isDesktopBased => !isWeb && (isMacOS || isWindows || isLinux);

///
bool get isWebBased => isWeb;

///
String get currentPlatformString {
  if (isWeb) return 'web';
  return Platform.operatingSystem;
}

///
AvailablePlatform get currentPlatform {
  if (isWeb) return AvailablePlatform.web;
  if (isAndroid) return AvailablePlatform.android;
  if (isIOS) return AvailablePlatform.iOS;
  if (isMacOS) return AvailablePlatform.macOS;
  if (isWindows) return AvailablePlatform.windows;
  if (isLinux) return AvailablePlatform.linux;
  if (isFuchsia) return AvailablePlatform.fuchsia;
  // Optimize(Alex): think later
  return AvailablePlatform.android;
}
