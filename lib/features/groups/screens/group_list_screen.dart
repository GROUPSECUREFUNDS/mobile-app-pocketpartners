import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app_pocketpartners/data/models/group/group_response_model.dart';
import 'package:mobile_app_pocketpartners/data/services/group/group_service.dart';
import 'package:mobile_app_pocketpartners/core/controllers/auth_controller.dart';

class GroupListScreen extends StatefulWidget {
  const GroupListScreen({super.key});

  @override
  State<GroupListScreen> createState() => _GroupListScreenState();
}

class _GroupListScreenState extends State<GroupListScreen> {
  final groupService = GroupService();
  final authController = AuthController();

  List<GroupResponseModel> groups = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadGroups();
  }

  Future<void> loadGroups() async {
    setState(() => isLoading = true);

    try {
      final user = await authController.getUserFromPreferences();
      if (user != null) {
        final fetchedGroups = await groupService.getAllGroupsByUserId(user.id);
        setState(() {
          groups = fetchedGroups;
          isLoading = false;
        });
      } else {
        // Manejar usuario no autenticado
        setState(() => isLoading = false);
      }
    } catch (e) {
      print("Error al cargar grupos: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mis Grupos")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : groups.isEmpty
              ? const Center(child: Text("No tienes grupos aún."))
              : ListView.builder(
                  itemCount: groups.length,
                  itemBuilder: (context, index) {
                    final group = groups[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(group.groupPhoto ?? "https://via.placeholder.com/150"),
                      ),
                      title: Text(group.name),
                      subtitle: Text(group.description ?? ""),
                      onTap: () {
                        context.push('/groups/${group.id}');
                      },
                    );
                  },
                ),
    );
  }
}
