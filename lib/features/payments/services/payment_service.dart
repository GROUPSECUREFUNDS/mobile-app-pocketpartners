import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile_app_pocketpartners/data/services/base_service.dart';

class PaymentService extends BaseService {
  PaymentService() : super(resourcePath: "/payments");

  /// 🔷 Obtener pagos por ID
  Future<dynamic> getPaymentById(dynamic paymentId) async {
    final headers = await getHeaders();
    final url = "${getFullUrl()}/$paymentId";

    final response = await client.get(Uri.parse(url), headers: headers);
    return jsonDecode(response.body);
  }

  /// 🔷 Obtener pagos por expenseId
  Future<dynamic> getPaymentByExpenseId(dynamic expenseId) async {
    final headers = await getHeaders();
    final url = "${getFullUrl()}/expenseId/$expenseId";

    final response = await client.get(Uri.parse(url), headers: headers);
    return jsonDecode(response.body);
  }

  /// 🔷 Obtener pagos por userId
  Future<dynamic> getPaymentByUserId(dynamic userId) async {
    final headers = await getHeaders();
    final url = "${getFullUrl()}/userId/$userId";

    final response = await client.get(Uri.parse(url), headers: headers);
    return jsonDecode(response.body);
  }

  /// 🔷 Obtener pagos por userId y status
  Future<dynamic> getPaymentByUserIdAndStatus(dynamic userId, String status) async {
    final headers = await getHeaders();
    final url = "${getFullUrl()}/userId/$userId/status/$status";

    final response = await client.get(Uri.parse(url), headers: headers);
    return jsonDecode(response.body);
  }

  /// 🔷 Obtener incoming payments por userInformationId
  Future<dynamic> getIncomingPaymentsByUserInformationId(int userInformationId) async {
    final headers = await getHeaders();
    final url = "${getFullUrl()}/incoming/$userInformationId";

    final response = await client.get(Uri.parse(url), headers: headers);
    return jsonDecode(response.body);
  }

  /// 🔷 Marcar un payment como completado
  Future<dynamic> postCompletePaymentById(dynamic paymentId) async {
    final headers = await getHeaders();
    final url = "${getFullUrl()}/$paymentId/completed";

    final response = await client.post(Uri.parse(url), headers: headers);
    return jsonDecode(response.body);
  }

  /// 🔷 Crear un nuevo payment
  Future<dynamic> postPayment(Map<String, dynamic> payment) async {
    final headers = await getHeaders();
    final url = getFullUrl();

    final response = await client.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(payment),
    );
    return jsonDecode(response.body);
  }

  /// 🔷 Obtener grupos unidos por usuario
  Future<List<dynamic>> getJoinedUserGroups(int userId) async {
    final headers = await getHeaders();
    final url = "$baseUrl/groups/members/$userId";
    final response = await client.get(Uri.parse(url), headers: headers);
    return jsonDecode(response.body);
  }


}
