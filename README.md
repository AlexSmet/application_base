<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

Unified base for Flutter applications based on [special architecture](https://miro.com/app/board/uXjVNJVBM3o=/?share_link_id=771428578014)

## Features

For now includes:
* [Analysis options](#analysis-options)
* [Logger](#logger)
* [Navigation utilities](#navigation-utilities)

## Usage

Just call `ApplicationBase.prepare();` on application  launching to initialize
all necessary data.

## Analysis options

Create an `analysis_options.yaml` file at the root of the package (alongside 
the `pubspec.yaml` file) and `include: application_base/analysis_options.yaml` 
from it.

Example `analysis_options.yaml` file:

```yaml
# This file configures the analyzer, which statically analyzes Dart code to
# check for errors, warnings, and lints.
#
# The issues identified by the analyzer are surfaced in the UI of Dart-enabled
# IDEs (https://dart.dev/tools#ides-and-editors). The analyzer can also be
# invoked from the command line by running `flutter analyze`.
#
# Additional information about this file can be found at
# https://dart.dev/guides/language/analysis-options
#
# Full list of rules can be fount at https://dart.dev/tools/linter-rules
#
# To get a preview of the proposed changes run
# dart fix --dry-run
#
# To apply the changes run
# dart fix --apply
include: package:application_base/analysis_options.yaml
```

## Logger

Based on [Logger](https://pub.dev/packages/logger)

For logging in remote systems (such as Crashlytics, Sentry or smth else) just
set `logInfoRemote` and `logErrorRemote`:

```dart
///
void _logInfo({required String information}) => 
    SomeRemoteService.log(information);
///
void _logError({required String error}) => 
    SomeRemoteService.log(error);

void prepare(){
    logInfoRemote = _logInfo;
    logErrorRemote = _logError;
}
```

Also you can set User ID for local error logging:

```dart
///
void setUser() {
    /// Set user in logger
    loggerUserId = userId;
}
```

And use logger everywhere it need

```dart
logInfo(info: 'Interesting information');
logError(error: 'Some error happened');
```

## Navigation utilities

Based on [AutoRoute](https://pub.dev/packages/auto_route)

On application preparing `RootStackRouter` based on `navigatorKey` must be 
created and set as `router`:

1. Create router instance

```dart
import 'package:application_base/presentation/navigation/guard/authentication_guard.dart';
import 'package:application_base/presentation/navigation/navigation_service.dart';

///
final routerInstance = RouterPro(
  authenticationGuard: AuthenticationGuard(
    authorizationRoute: const AuthRoute(),// Your default non-authorized route
  ),
  navigatorKey: navigatorKey,
);
```

2. Set created instance as `router`

Somewhere on application launching

```dart
import 'package:application_base/presentation/navigation/navigation_service.dart';

router = routerInstance;
```

Or set it directrly on package prepare flow

```dart
import 'package:application_base/application_base.dart';

ApplicationBase.prepare(routerInstance: routerInstance);
```

3. Also you can create `routerConfig` with existing `Access checker` and 
`Observer`:

```dart
///
final RouterConfig<UrlState> routerConfig = routerInstance.config(
    reevaluateListenable: getIt<AccessVM>(),
    navigatorObservers: () => [
        NavigatorObserverPro(),
    ],
);
```

and use it as Application `routerConfig`

```dart
MaterialApp.router(
    /// ...
    routerConfig: routerConfig,
    /// ...
)
```

All screen and tab changes will be auto-loggied via `NavigatorObserverPro`