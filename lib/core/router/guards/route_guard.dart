import "package:mobile_app_pocketpartners/core/controllers/auth_controller.dart";

class RouteGuard {
  static Future<String?> privateGuard() async {
    AuthController authController = AuthController();
    if(await authController.isLoggedIn()) {
      return null;
    } else {
      return "/auth/login";
    }
  }

  static Future<String?> publicGuard() async {
    AuthController authController = AuthController();
    if(await authController.isLoggedIn()) {
      return "/home";
    } else {
      return null;
    }
  }
}
