import 'package:firebase_auth/firebase_auth.dart';
import 'package:skyle_clone/models/local/db_user.dart';

import 'package:skyle_clone/services/my_rest_api/api_user.dart';

import 'package:skyle_clone/services/safety/change_notifier_safety.dart';
import 'package:skyle_clone/utils/app_log.dart';

class AuthProvider extends ChangeNotifierSafety {
  AuthProvider(){
    logger.e("AuthProvider create");
    this._api=ApiUser();
  }

  /// Authentication api
   ApiUser _api;

  DBUser _user;

  DBUser get user => _user;

  set user(DBUser user) {
    _user = user;
    logger.d("vao trong nay 1");
    notifyListeners();

  }

  // /// Credential
  // final Credential _credential;

  @override
  void resetState() {}

  Future<void> refreshUser() async {
    DBUser dbUser = await _api.getUserDetails();
    _user = dbUser;
    logger.d("vao trong nay 2");
    notifyListeners();
  }

  User getCurrentUser() {
    return _api.getCurrentUser();
  }

  Future<User> loginByGoogle() {
    return _api.loginByGoogle();
  }

  Future<bool> logOut() {
    return _api.logOut();
  }

  Future<bool> userExits(User user) {
    return _api.userExits(user);
  }

  Future<void> addUserToFirebaseDb(User currentUser) {
    return _api.addUserToFirebaseDb(currentUser);
  }

  Future<DBUser> getUserDetails() {
    return _api.getUserDetails();
  }

  Future<List<DBUser>> fetchAllUsers(DBUser currentUser){
    return _api.fetchAllUsers(currentUser);
  }
  Future<DBUser> getUserDetailsById(id)  {
    return _api.getUserDetailsById(id);
  }
}
