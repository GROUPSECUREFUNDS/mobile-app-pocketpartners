// profile_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app_pocketpartners/core/controllers/auth_controller.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final authController = AuthController();
  Map<String, dynamic>? user;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final fetchedUser = await authController.getUserFromPreferences();
    setState(() {
      user = fetchedUser?.toJson();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Perfil"), actions: [
        IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () => context.push("/profile/edit"),
        )
      ]),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage(user!["photo"] ?? ""),
            ),
            const SizedBox(height: 20),
            Text("${user!["firstName"]} ${user!["lastName"]}", style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text(user!["email"] ?? ""),
            const SizedBox(height: 5),
            Text(user!["phoneNumber"] ?? ""),
          ],
        ),
      ),
    );
  }
}
