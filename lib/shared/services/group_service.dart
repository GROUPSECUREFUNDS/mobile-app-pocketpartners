// lib/shared/services/group_service.dart
import 'dart:convert';
import '../../data/models/group/group_request_model.dart';
import '../../data/models/group/group_response_model.dart';
import '../../data/services/base_service.dart';

class GroupService extends BaseService {
  GroupService() : super(resourcePath: 'groups');

  Future<List<GroupResponseModel>> getGroupsByUserId(int userId) async {
    final response = await client.get(
      Uri.parse("${getFullUrl()}/user/$userId"),
      headers: await getHeaders(),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((e) => GroupResponseModel.fromJson(e)).toList();
    } else {
      throw Exception('Error fetching groups: ${response.body}');
    }
  }

  Future<void> createGroup(GroupRequestModel data) async {
    final response = await client.post(
      Uri.parse(getFullUrl()),
      headers: await getHeaders(),
      body: json.encode(data.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Error creating group: ${response.body}');
    }
  }
}