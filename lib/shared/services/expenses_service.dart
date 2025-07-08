// lib/shared/services/expenses_service.dart
import 'dart:convert';
import '../../data/models/expenses/expenses_request_model.dart';
import '../../data/models/expenses/expenses_response_model.dart';
import '../../data/services/base_service.dart';

class ExpensesService extends BaseService {
  ExpensesService() : super(resourcePath: 'expenses');

  Future<List<ExpensesResponseModel>> getExpenses() async {
    final response = await client.get(
      Uri.parse(getFullUrl()),
      headers: await getHeaders(),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((e) => ExpensesResponseModel.fromJson(e)).toList();
    } else {
      throw Exception('Error fetching expenses: ${response.body}');
    }
  }
  Future<List<ExpensesResponseModel>> getExpensesByUserId(int userId) async {
    final url = Uri.parse("${getFullUrl()}/userId/$userId");
    final response = await client.get(
      url,
      headers: await getHeaders(),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((e) => ExpensesResponseModel.fromJson(e)).toList();
    } else {
      throw Exception("Error fetching expenses by user ID: ${response.body}");
    }
  }


  Future<void> createExpense(ExpensesRequestModel data) async {
    final response = await client.post(
      Uri.parse(getFullUrl()),
      headers: await getHeaders(),
      body: json.encode(data.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Error creating expense: ${response.body}');
    }
  }
}
