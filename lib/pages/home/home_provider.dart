import 'package:skyle_clone/models/local/token.dart';

import 'package:skyle_clone/services/safety/change_notifier_safety.dart';

class HomeProvider extends ChangeNotifierSafety {
  HomeProvider();

  ///#region PRIVATE PROPERTIES
  /// -----------------
  /// Authentication api


  ///#endregion

  ///#region PUBLIC PROPERTIES
  /// -----------------
  /// Get user info
  // Token get token => _api.token;

  ///#endregion

  ///#region METHODS
  /// -----------------

  @override
  void resetState() {}

  ///#endregion
}
