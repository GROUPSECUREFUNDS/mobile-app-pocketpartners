import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile_app_pocketpartners/data/models/group/group_request_model.dart';
import 'package:mobile_app_pocketpartners/data/models/group/group_response_model.dart';
import 'package:mobile_app_pocketpartners/data/services/base_service.dart';

class GroupService extends BaseService {
  GroupService() : super(resourcePath: "groups");

  Future<dynamic> createGroup(GroupRequestModel group) async {
    final headers = await getHeaders();
    final response = await client.post(
      Uri.parse(getFullUrl()),
      headers: headers,
      body: jsonEncode(group.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception("Error al crear grupo: ${response.body}");
    }

    return jsonDecode(response.body);
  }

  Future<List<GroupResponseModel>> getAllGroups() async {
    final headers = await getHeaders();
    final response = await client.get(
      Uri.parse(getFullUrl()),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => GroupResponseModel.fromJson(json)).toList();
    } else {
      throw Exception("Error al obtener los grupos");
    }
  }

  Future<List<GroupResponseModel>> getAllGroupsByUserId(int userId) async {
    final headers = await getHeaders();
    final response = await client.get(
      Uri.parse("${getFullUrl()}/user/$userId"),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => GroupResponseModel.fromJson(json)).toList();
    } else {
      throw Exception("Error al obtener grupos del usuario");
    }
  }

  Future<GroupResponseModel> getById(int id) async {
    final headers = await getHeaders();
    final response = await client.get(
      Uri.parse("${getFullUrl()}/$id"),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return GroupResponseModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Error al obtener grupo por ID");
    }
  }

  Future<GroupResponseModel> updateGroup({
    required int id,
    required String name,
    required String description,
  }) async {
    final headers = await getHeaders();
    final response = await client.put(
      Uri.parse("${getFullUrl()}/$id"),
      headers: headers,
      body: jsonEncode({"name": name, "description": description}),
    );

    if (response.statusCode == 200) {
      return GroupResponseModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Error al actualizar grupo");
    }
  }

  Future<GroupResponseModel> updateGroupImage({
    required int id,
    required String image,
  }) async {
    final headers = await getHeaders();
    final response = await client.put(
      Uri.parse("${getFullUrl()}/$id/image"),
      headers: headers,
      body: jsonEncode({"image": image}),
    );

    if (response.statusCode == 200) {
      return GroupResponseModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Error al actualizar imagen del grupo");
    }
  }

  Future<void> deleteGroup(int id) async {
    final headers = await getHeaders();
    final response = await client.delete(
      Uri.parse("${getFullUrl()}/$id"),
      headers: headers,
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception("Error al eliminar el grupo");
    }
  }

  /*Future<List<MemberInfo>> getAllMembersByIdGroup(int id) async {
    final headers = await getHeaders();
    final response = await client.get(
      Uri.parse("${getFullUrl()}/$id/members"),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => MemberInfo.fromJson(json)).toList();
    } else {
      throw Exception("Error al obtener miembros del grupo");
    }
  }*/

  Future<String> generateInvitation(int groupId) async {
    final headers = await getHeaders();
    final response = await client.post(
      Uri.parse("${getFullUrl()}/$groupId/generate-invitation"),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception("Error al generar código de invitación");
    }
  }

  Future<void> joinGroup({
    required int groupId,
    required int userId,
    required String token,
  }) async {
    final headers = await getHeaders();
    final response = await client.post(
      Uri.parse("${getFullUrl()}/$groupId/join"),
      headers: headers,
      body: jsonEncode({"userId": userId, "token": token}),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception("Error al unirse al grupo");
    }
  }
}
