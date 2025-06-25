import "package:flutter/foundation.dart";
import "package:mobile_app_pocketpartners/data/models/auth/login_request_model.dart";
import "package:mobile_app_pocketpartners/data/models/auth/login_response_model.dart";
import "package:mobile_app_pocketpartners/data/models/auth/register_request_model.dart";
import "package:mobile_app_pocketpartners/data/models/user_info/userinfo_request_model.dart";
import "package:mobile_app_pocketpartners/data/services/authentication_service.dart";
import "package:mobile_app_pocketpartners/data/services/userinformation_service.dart";
import "package:shared_preferences/shared_preferences.dart";

class AuthController {
  final AuthenticationService _authenticationService = AuthenticationService();
  final UserinformationService _userInformationService = UserinformationService();

  AuthController();


  Future<LoginResponseModel?> getUserFromPreferences() {
    return SharedPreferences.getInstance().then((prefs) {
      final token = prefs.getString('token');
      final userId = prefs.getString('userId');
      final username = prefs.getString('username');

      if (token != null && userId != null && username != null) {
        return LoginResponseModel(
          id: int.parse(userId),
          username: username,
          token: token,
        );
      } else {
        return null; // No user data found in preferences
      }
    });
  }

  Future<void> register(
    RegisterRequestModel registerRequest,
    UserinfoRequestModel userInfoRequest,
  ) async {
    final responseRegister = await _authenticationService.signUp(
      registerRequest,
    );
    userInfoRequest.userId = responseRegister.id;
    await _userInformationService.post(userInfoRequest);

    final responseLogin = await _authenticationService.signIn(
      LoginRequestModel(
        username: registerRequest.username,
        password: registerRequest.password,
      ),
    );

    // Optionally save to shared preferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', responseLogin.token);
    await prefs.setString('userId', responseLogin.id.toString());
    await prefs.setString('username', responseLogin.username);
  }

  Future<void> login(LoginRequestModel loginRequest) async {
    // Call the authentication service to perform login
    final response = await _authenticationService.signIn(loginRequest);

    // Optionally save to shared preferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', response.token);
    await prefs.setString('userId', response.id.toString());
    await prefs.setString('username', response.username);

    debugPrint(
      "User logged in: ${response.username} with token: ${response.token}",
    );
  }

  Future<void> logout() async {

    // Optionally clear shared preferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('userId');
    await prefs.remove('username');
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') != null;
  }

}
