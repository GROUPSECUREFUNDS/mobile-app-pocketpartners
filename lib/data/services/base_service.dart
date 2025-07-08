import "dart:convert";

import "package:http/http.dart" as http;
import "package:shared_preferences/shared_preferences.dart";

class BaseService {
  final String baseUrl = "https://backend-pocketpartners.onrender.com/api/v1";
  final String baseUrlimage = "https://backend-pocketpartners.onrender.com/api/v1/images";
  final String baseUrlocr = "https://backend-pocketpartners.onrender.com/api/v1/ocr-receipt";

  //final String baseUrl = "https://8wgtg5zw-8080.brs.devtunnels.ms/api/v1";
  final String resourcePath;

  static final http.Client _sharedClient = http.Client();

  BaseService({required this.resourcePath});
  /// 🔑 Obtiene headers con token de autorización
  Future<Map<String, String>> getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    if (token == null || token.isEmpty) {
      throw Exception("Token de autenticación no encontrado. Realiza login nuevamente.");
    }

    print("🔑 Token usado en headers: $token");

    return {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };
  }

  http.Client get client => _sharedClient;
  String getFullUrl() {
    String formattedBase = baseUrl.endsWith('/')
        ? baseUrl.substring(0, baseUrl.length - 1)
        : baseUrl;
    String formattedResource = resourcePath.startsWith('/')
        ? resourcePath
        : '/$resourcePath';
    return "$formattedBase$formattedResource";
  }

  Future<dynamic> getJson(String url) async {
    final response = await client.get(Uri.parse(url), headers: await getHeaders());

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 404) {
      print("Resource not found: $url");
      return [];
    } else {
      print("Error fetching resource ($url): ${response.statusCode}");
      throw Exception('Failed to load resource ($url): ${response.statusCode}');
    }
  }

  /// 🔷 GET ALL
  Future<dynamic> getAll() async {
    final url = getFullUrl();
    final response = await client.get(Uri.parse(url), headers: await getHeaders());

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load data (${response.statusCode})');
    }
  }

  /// 🔷 CREATE
  Future<dynamic> create(dynamic item) async {
    final url = getFullUrl();
    final response = await client.post(
      Uri.parse(url),
      headers: await getHeaders(),
      body: jsonEncode(item),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to create item (${response.statusCode})');
    }
  }

  /// 🔷 UPDATE
  Future<dynamic> update(dynamic id, dynamic item) async {
    final url = "${getFullUrl()}/$id";
    final response = await client.put(
      Uri.parse(url),
      headers: await getHeaders(),
      body: jsonEncode(item),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to update item ($id) (${response.statusCode})');
    }
  }

  /// 🔷 DELETE
  Future<void> delete(dynamic id) async {
    final url = "${getFullUrl()}/$id";
    final response = await client.delete(
      Uri.parse(url),
      headers: await getHeaders(),
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete item ($id) (${response.statusCode})');
    }
  }
  Future<dynamic> postJson(String url, Map<String, dynamic> body) async {
    final response = await client.post(
      Uri.parse(url),
      headers: await getHeaders(),
      body: jsonEncode(body),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to POST to $url (${response.statusCode})');
    }
  }

  Future<void> deleteJson(String url) async {
    final response = await client.delete(
      Uri.parse(url),
      headers: await getHeaders(),
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to DELETE $url (${response.statusCode})');
    }
  }

}
