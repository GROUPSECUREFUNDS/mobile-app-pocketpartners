import 'dart:convert';

import 'package:mobile_app_pocketpartners/data/models/auth/login_request_model.dart';
import 'package:mobile_app_pocketpartners/data/models/auth/register_response_model.dart';
import 'package:mobile_app_pocketpartners/data/models/auth/login_response_model.dart';
import 'package:mobile_app_pocketpartners/data/models/auth/register_request_model.dart';
import 'package:mobile_app_pocketpartners/data/services/base_service.dart';

class AuthenticationService extends BaseService {
  Map<String, String> customHeaders = {"Content-Type": "application/json"};

  AuthenticationService() : super(resourcePath: "authentication");

  // Add methods for authentication, e.g., login, logout, register
  Future<LoginResponseModel> signIn(LoginRequestModel loginRequest) async {
    final response = await client.post(
      Uri.parse("${getFullUrl()}/sign-in"),
      headers: customHeaders,
      body: jsonEncode(loginRequest.toJson()),
    );

    if (response.statusCode == 200) {
      return LoginResponseModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to login: ${response.body}");
    }
  }

  Future<RegisterResponseModel> signUp(
    RegisterRequestModel registerRequest,
  ) async {
    // Implement registration logic here
    final response = await client.post(
      Uri.parse("${getFullUrl()}/sign-up"),
      headers: customHeaders,
      body: registerRequest.toJson(),
    );

    if (response.statusCode == 201) {
      return RegisterResponseModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to register");
    }
  }
}
