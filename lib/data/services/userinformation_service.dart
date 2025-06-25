import 'dart:convert';

import 'package:mobile_app_pocketpartners/data/models/user_info/userinfo_request_model.dart';
import 'package:mobile_app_pocketpartners/data/models/user_info/userinfo_response_model.dart';
import 'package:mobile_app_pocketpartners/data/services/base_service.dart';

class UserinformationService extends BaseService{
  UserinformationService() : super(resourcePath: "usersInformation");

  Future<UserinfoResponseModel> post(UserinfoRequestModel userInfo) async {
    final headers = await getHeaders();
    final response = await client.post(
      Uri.parse(getFullUrl()),
      headers: headers,
      body: jsonEncode(userInfo.toJson()),
    );

    if (response.statusCode == 201) {
      return UserinfoResponseModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to save user information: ${response.body}");
    }
  }

  Future<UserinfoResponseModel> getByUserId(int userId) async {
    final headers = await getHeaders();
    final response = await client.get(
      Uri.parse("${getFullUrl()}/userId/$userId"),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return UserinfoResponseModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to fetch user information");
    }
  }
}