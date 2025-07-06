import 'dart:convert';
import 'package:mobile_app_pocketpartners/data/models/group/group_member_response_model.dart';
import 'package:mobile_app_pocketpartners/data/services/base_service.dart';

class GroupMembersService extends BaseService {
  GroupMembersService() : super(resourcePath: "groups");

  /// Obtener miembros de un grupo
  Future<List<GroupMemberResponseModel>> getGroupMembers(int groupId) async {
    final headers = await getHeaders();
    final response = await client.get(
      Uri.parse("${getFullUrl()}/$groupId/members"),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList
          .map((json) => GroupMemberResponseModel.fromJson(json))
          .toList();
    } else {
      throw Exception("Error al obtener miembros del grupo");
    }
  }

  /// Añadir miembro a un grupo
  Future<void> addGroupMember(int groupId, int memberId) async {
    final headers = await getHeaders();
    final body = jsonEncode({'memberId': memberId});

    final response = await client.post(
      Uri.parse("${getFullUrl()}/$groupId/members"),
      headers: headers,
      body: body,
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception("Error al agregar miembro: ${response.body}");
    }
  }

  /// Eliminar miembro de un grupo
  Future<void> deleteGroupMember(int groupId, int userId) async {
    final headers = await getHeaders();
    final response = await client.delete(
      Uri.parse("${getFullUrl()}/$groupId/members/$userId"),
      headers: headers,
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception("Error al eliminar miembro: ${response.body}");
    }
  }
}
