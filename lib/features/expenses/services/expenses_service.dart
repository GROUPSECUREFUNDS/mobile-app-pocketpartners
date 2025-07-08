import 'dart:convert';
import 'package:mobile_app_pocketpartners/data/services/base_service.dart';

class ExpensesService extends BaseService {
  ExpensesService() : super(resourcePath: "expenses");

  Future<List<dynamic>> getJoinedUserGroups(int userId) async {
    final headers = await getHeaders();
    final url = "$baseUrl/groups/members/$userId";
    final response = await client.get(Uri.parse(url), headers: headers);
    return jsonDecode(response.body);
  }

  Future<dynamic> getExpenseById(dynamic expenseId) async {
    final headers = await getHeaders();
    final url = "${getFullUrl()}/$expenseId";
    final response = await client.get(Uri.parse(url), headers: headers);
    return jsonDecode(response.body);
  }

  Future<List<dynamic>> getExpensesByGroupId(int groupId) async {
    final headers = await getHeaders();
    final url = "${getFullUrl()}/groupId/$groupId";
    final response = await client.get(Uri.parse(url), headers: headers);
    return jsonDecode(response.body);
  }

  Future<List<dynamic>> getExpenses() async {
    final headers = await getHeaders();
    final url = getFullUrl();
    final response = await client.get(Uri.parse(url), headers: headers);
    return jsonDecode(response.body);
  }

  Future<List<dynamic>> getExpensesByUserId(int userId) async {
    final headers = await getHeaders();
    final url = "${getFullUrl()}/userId/$userId";
    final response = await client.get(Uri.parse(url), headers: headers);
    return jsonDecode(response.body);
  }

  Future<dynamic> deleteExpenseById(int expenseId) async {
    final headers = await getHeaders();
    final url = "${getFullUrl()}/expenseId/$expenseId";
    final response = await client.delete(Uri.parse(url), headers: headers);
    return jsonDecode(response.body);
  }

  Future<dynamic> createExpense(Map<String, dynamic> expense) async {
    final headers = await getHeaders();
    final url = getFullUrl();
    final response = await client.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(expense),
    );
    return jsonDecode(response.body);
  }
}