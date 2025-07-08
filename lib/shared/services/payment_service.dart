import 'dart:convert';

import '../../data/models/payment/payment_request_model.dart';
import '../../data/models/payment/payment_response_model.dart';
import '../../data/services/base_service.dart';

class PaymentService extends BaseService {
  PaymentService() : super(resourcePath: 'payments');

  Future<List<PaymentResponseModel>> getPaymentsByUserId(int userId) async {
    final response = await client.get(
      Uri.parse("${getFullUrl()}/userId/$userId"),
      headers: await getHeaders(),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((e) => PaymentResponseModel.fromJson(e)).toList();
    } else {
      throw Exception('Error fetching payments: ${response.body}');
    }
  }

  Future<void> createPayment(PaymentRequestModel data) async {
    final response = await client.post(
      Uri.parse(getFullUrl()),
      headers: await getHeaders(),
      body: json.encode(data.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Error creating payment: ${response.body}');
    }
  }
}