///
enum NavigatorTransaction {
  ///
  push,

  ///
  pop,

  ///
  replace,

  ///
  tabChanged,
}

///
const String _pushed = 'pushed';

///
const String _popped = 'popped';

///
const String _replaced = 'replaced';

///
const String _tabChanged = 'tab changed';

///
String navigatorTransactionString(NavigatorTransaction transaction) =>
    switch (transaction) {
      NavigatorTransaction.push => _pushed,
      NavigatorTransaction.pop => _popped,
      NavigatorTransaction.replace => _replaced,
      NavigatorTransaction.tabChanged => _tabChanged,
    };
