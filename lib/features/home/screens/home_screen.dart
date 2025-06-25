import "package:flutter/material.dart";
import "package:mobile_app_pocketpartners/core/controllers/auth_controller.dart";
import "package:mobile_app_pocketpartners/data/models/auth/login_response_model.dart";

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final authController = AuthController();
  LoginResponseModel? userData;

  @override
  void initState() {
    super.initState();
    authController.getUserFromPreferences().then((user) {
      if (user != null) {
        setState(() {
          userData = user;
        });
      } else {
        setState(() {
          userData = LoginResponseModel(username: "Guest", id: 0, token: "");
        });
      }
    }).catchError((error) {
      // Handle error if needed
      print("Error fetching user data: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(child: Column(
      children: [
        const Text("Welcome to Pocket Partners"),
        const SizedBox(height: 20),
        if (userData != null) ...[
          Text("Username: ${userData?.username}"),
          Text("User ID: ${userData?.id}"),
          Text("Token: ${userData?.token}"),
        ] else
          const Text("No user data available."),
      ],
    ));
  }
}
