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

TODO: init example

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

## Navigation utilities

Based of [AutoRoute](https://pub.dev/packages/auto_route)

On application preparing `RootStackRouter` based on `navigatorKey` must be 
created and set as `router`

TODO: init example

```dart
///
```