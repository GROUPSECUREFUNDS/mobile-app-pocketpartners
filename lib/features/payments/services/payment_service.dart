import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile_app_pocketpartners/data/services/base_service.dart';
import 'package:mobile_app_pocketpartners/features/payments/models/payment_model.dart';
import 'package:mobile_app_pocketpartners/features/payments/models/expense_entity.dart';
import 'package:mobile_app_pocketpartners/features/payments/models/contact_entity.dart';
import 'package:mobile_app_pocketpartners/features/payments/models/group_entity.dart';

class PaymentService extends BaseService {
  PaymentService() : super(resourcePath: "payments");



  /// 🔷 Helper general para GET con parseo seguro
  Future<dynamic> getJson(String url) async {
    final headers = await getHeaders();
    final response = await client.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 404) {
      print("Resource not found: $url");
      return []; // lista vacía si no hay resultados
    } else {
      print("Error fetching resource ($url): ${response.statusCode}");
      throw Exception('Failed to load resource ($url): ${response.statusCode}');
    }
  }

  /// 🔷 Obtener pagos por ID
  Future<PaymentModel> getPaymentById(dynamic paymentId) async {
    final data = await getJson("${getFullUrl()}/$paymentId");
    return PaymentModel.fromJson(data);
  }

  /// 🔷 Obtener pagos por expenseId
  Future<List<PaymentModel>> getPaymentByExpenseId(dynamic expenseId) async {
    final data = await getJson("${getFullUrl()}/expenseId/$expenseId");
    return List<PaymentModel>.from(data.map((json) => PaymentModel.fromJson(json)));
  }

  /// 🔷 Obtener pagos por userId
  Future<List<PaymentModel>> getPaymentByUserId(dynamic userId) async {
    final data = await getJson("${getFullUrl()}/userId/$userId");
    return List<PaymentModel>.from(data.map((json) => PaymentModel.fromJson(json)));
  }


  /// 🔷 Obtener pagos por userId y status
  Future<List<PaymentModel>> getPaymentByUserIdAndStatus(dynamic userId, String status) async {
    final data = await getJson("${getFullUrl()}/userId/$userId/status/$status");
    return List<PaymentModel>.from(data.map((json) => PaymentModel.fromJson(json)));
  }



  /// 🔷 Obtener incoming payments por userInformationId
  Future<List<PaymentModel>> getIncomingPaymentsByUserInformationId(int userInformationId) async {
    final data = await getJson("${getFullUrl()}/incoming/$userInformationId");
    return List<PaymentModel>.from(data.map((json) => PaymentModel.fromJson(json)));
  }

  /// 🔷 Marcar un payment como completado
  Future<dynamic> postCompletePaymentById(dynamic paymentId) async {
    final headers = await getHeaders();
    final url = "${getFullUrl()}/$paymentId/completed";

    final response = await client.post(Uri.parse(url), headers: headers);
    return jsonDecode(response.body);
  }

  /// 🔷 Crear un nuevo payment
  Future<PaymentModel> postPayment(Map<String, dynamic> payment) async {
    final headers = await getHeaders();
    final url = getFullUrl();

    final response = await client.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(payment),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return PaymentModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create payment: ${response.statusCode}');
    }
  }

  /// 🔷 Obtener grupos unidos por usuario
  Future<List<dynamic>> getJoinedUserGroups(int userId) async {
    final data = await getJson("$baseUrl/groups/members/$userId");
    return data;
  }


  ///metodos de otros servicios:

  Future<ExpensesEntity> getExpenseById(int expenseId) async {
    final headers = await getHeaders();
    final url = "$baseUrl/expenses/$expenseId";

    final response = await client.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return ExpensesEntity.fromJson(data);
    } else {
      print("Error fetching expense: ${response.statusCode}");
      throw Exception('Failed to load expense with id $expenseId');
    }
  }

  Future<dynamic> getGroupById(dynamic groupId) async {
    final headers = await getHeaders();
    final url = "$baseUrl/groups/$groupId";
    final response = await client.get(Uri.parse(url), headers: headers);
    return jsonDecode(response.body);
  }

  Future<dynamic> getContactById(dynamic userId) async {
    final headers = await getHeaders();
    final url = "$baseUrl/contacts/userId/$userId";
    final response = await client.get(Uri.parse(url), headers: headers);
    return jsonDecode(response.body);
  }


}
