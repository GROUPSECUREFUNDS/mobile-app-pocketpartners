import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_app_pocketpartners/data/services/base_service.dart';
import 'package:mobile_app_pocketpartners/features/payments/models/payment_model.dart';
import 'package:mobile_app_pocketpartners/features/payments/models/expense_entity.dart';
import 'package:mobile_app_pocketpartners/features/payments/models/group_entity.dart';
import 'package:mobile_app_pocketpartners/features/payments/models/receipt_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  ///
  /// SERVICIOS PARA EL PAYMENT-MADE-PAGE

  Future<ExpensesEntity> getExpenseById(int expenseId) async {
    final headers = await getHeaders();
    final url = "$baseUrl/expenses/$expenseId";

    final response = await client.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return ExpensesEntity.fromJson(data);
    } else {
      print("Error fetching expense: ${response.statusCode}");
      throw Exception("Failed to load expense with id $expenseId ${response.statusCode} ${response.body}");
    }
  }

  Future<GroupEntity> getGroupById(dynamic groupId) async {
    final headers = await getHeaders();
    final url = "$baseUrl/groups/$groupId";
    final response = await client.get(Uri.parse(url), headers: headers);
    return GroupEntity.fromJson(jsonDecode(response.body));
  }

  Future<List<GroupEntity>> getGroupMembers(dynamic groupId) async {
    final headers = await getHeaders();
    final url = "$baseUrl/groups/$groupId/members";
    final response = await client.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200 && response.body.isNotEmpty) {
      final List<dynamic> decodedJson = jsonDecode(response.body);
      return decodedJson.map((json) => GroupEntity.fromJson(json)).toList();
    } else {
      throw Exception("Error al obtener miembros del grupo ($groupId): status ${response.statusCode}, body: ${response.body}");
    }
  }



/// SERVICIOS PARA EL PAYMENT-details-page
  Future<List<ReceiptEntity>> getReceiptsByPaymentId(int paymentId) async {
    final data = await getJson("$baseUrl/receipts/payment/$paymentId");
    print("🔎 Receipts response: $data");

    final receiptsList = data is List
        ? data
        : data['data']; // si la propiedad es 'data'

    return List<ReceiptEntity>.from(receiptsList.map((json) => ReceiptEntity.fromJson(json)));
  }


  Future<void> deleteReceipt(int receiptId) async {
    await deleteJson("$baseUrl/$receiptId");
  }

  Future<void> createReceiptByPayment(Map<String, dynamic> receipt, int paymentId) async {
    await postJson("$baseUrl/receipts/payment", {...receipt, "paymentId": paymentId});
  }



  Future<String> getImageUrlById(String imageId) async {
    final headers = await getHeaders();
    final url = "$baseUrl/$imageId";

    final response = await client.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {

      final data = jsonDecode(response.body);
      return data['imagePath'];
    } else {
      throw Exception("Failed to load image ($imageId): ${response.statusCode}");
    }
  }
  /// 🔷 Obtiene la URL completa de una imagen dado su imageId
  String getImageUrl(String imageId) {
    return "https://backend-pocketpartners.onrender.com/api/v1/images/$imageId";
  }

  Future<String> uploadImage(File imageFile, String token) async {
    var request = http.MultipartRequest('POST', Uri.parse(baseUrlimage));
    request.headers['Authorization'] = 'Bearer $token';
    request.files.add(await http.MultipartFile.fromPath('file', imageFile.path));

    final response = await request.send();

    if (response.statusCode == 200) {
      final respStr = await response.stream.bytesToString();
      final jsonResp = jsonDecode(respStr);
      return jsonResp['imageId'];
    } else {
      throw Exception("Error uploading image (${response.statusCode})");
    }
  }
  ///servicio para OCR:
  Future<Map<String, dynamic>> extractFieldsFromImage(String imageId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    final response = await http.post(
      Uri.parse("$baseUrlocr/from-image"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({"imageId": imageId}),
    );
    if (response.statusCode == 200) {
      debugPrint("body ocr: ${response.body}");
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed OCR (${response.statusCode})");
    }
  }
}
