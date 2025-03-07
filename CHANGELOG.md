## 0.0.4

* **RequestPostWithFile** is now web-compatible but requires XFile instead of 
local file path
* In **RequestServiceBase** added parameter **logSensitive** to send or not to
send sensitive data in logger (instead of private **_sendSensitive** parameter)
* **onUnauthorized** -> **notifyUnauthorized**
* Logger events in debug mode won't be sent to remote logger anymore
* Error in response will be logged in remote logger with response body despite
**logSensitive** parameter


## 0.0.3

* Dependencies update

## 0.0.2

* API interaction based on [http](https://pub.dev/packages/http)
* Online / offline state change checker

## 0.0.1

* Analysis options
* Flavors
* GetIt based on [get_it](https://pub.dev/packages/get_it)
* Logger based on [Logger](https://pub.dev/packages/logger)
* Navigation utilities based on [AutoRoute](https://pub.dev/packages/auto_route)