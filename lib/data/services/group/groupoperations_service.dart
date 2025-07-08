import 'dart:convert';
import 'package:mobile_app_pocketpartners/data/models/group/group_operation_request_model.dart';
import 'package:mobile_app_pocketpartners/data/models/group/group_operation_response_model.dart';
import 'package:mobile_app_pocketpartners/data/services/base_service.dart';

class GroupOperationsService extends BaseService {
  GroupOperationsService() : super(resourcePath: "/groupOperations");

  /// Obtener todas las operaciones de un grupo
  Future<List<GroupOperationResponseModel>> getAllByGroupId(int groupId) async {
    final headers = await getHeaders();
    final response = await client.get(
      Uri.parse("${getFullUrl()}/groupId/$groupId"),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList
          .map((json) => GroupOperationResponseModel.fromJson(json))
          .toList();
    } else {
      throw Exception("Error al obtener operaciones del grupo");
    }
  }

  /// Crear nueva operación (gasto o pago) para un grupo
  Future<GroupOperationResponseModel> postOperation(GroupOperationRequestModel request) async {
    final headers = await getHeaders();
    final response = await client.post(
      Uri.parse(getFullUrl()),
      headers: headers,
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return GroupOperationResponseModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Error al crear operación: ${response.body}");
    }
  }
}
