import "package:http/http.dart" as http;
import "package:shared_preferences/shared_preferences.dart";

class BaseService {
  final String baseUrl = "https://backend-pocketpartners.onrender.com/api/v1";
  //final String baseUrl = "https://8wgtg5zw-8080.brs.devtunnels.ms/api/v1";
  final String resourcePath;

  static final http.Client _sharedClient = http.Client();

  BaseService({required this.resourcePath});

  Future<Map<String, String>> getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    return {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };
  }

  http.Client get client => _sharedClient;

  // Example method
  String getFullUrl() {
    return "$baseUrl/$resourcePath";
  }
}
