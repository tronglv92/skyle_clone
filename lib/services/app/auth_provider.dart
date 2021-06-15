import 'package:dio/dio.dart';
import 'package:skyle_clone/models/local/token.dart';
import 'package:skyle_clone/models/remote/login_response.dart';
import 'package:skyle_clone/services/cache/credential.dart';
import 'package:skyle_clone/services/rest_api/api_user.dart';
import 'package:skyle_clone/services/safety/change_notifier_safety.dart';

class AuthProvider extends ChangeNotifierSafety {
  AuthProvider(this._api, this._credential);

  /// Authentication api
  final ApiUser _api;

  /// Credential
  final Credential _credential;

  @override
  void resetState() {}

  /// Call api login
  Future<bool> login(String email, String password) async {
    final Response<Map<String, dynamic>> result =
        await _api.logIn(email, password).timeout(const Duration(seconds: 30));
    final LoginResponse loginResponse = LoginResponse(result.data);
    final Token token = loginResponse.data;
    if (token != null) {
      /// Save credential
      final bool saveRes = await _credential.storeCredential(token, cache: true);
      return saveRes;
    } else {
      throw DioError(
          requestOptions: null, error: loginResponse.error?.message ?? 'Login error', type: DioErrorType.response);
    }
  }

  /// Call api login with error
  Future<LoginResponse> logInWithError() async {
    final Response<Map<String, dynamic>> result = await _api.logInWithError().timeout(const Duration(seconds: 30));
    final LoginResponse loginResponse = LoginResponse(result.data);
    return loginResponse;
  }

  /// Call api login with exception
  Future<void> logInWithException() async {
    await Future<void>.delayed(const Duration(seconds: 1));
    throw DioError(requestOptions: null, error: 'Login with exception', type: DioErrorType.response);
  }

  /// Call logout
  Future<bool> logout() async {
    await Future<void>.delayed(const Duration(seconds: 1));

    /// Save credential
    final bool saveRes = await _credential.storeCredential(null, cache: true);
    return saveRes;
  }
}
