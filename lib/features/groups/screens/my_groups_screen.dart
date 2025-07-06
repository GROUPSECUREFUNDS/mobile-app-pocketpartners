import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app_pocketpartners/data/models/group/group_response_model.dart';
import 'package:mobile_app_pocketpartners/data/services/group/group_service.dart';
import 'package:mobile_app_pocketpartners/core/controllers/auth_controller.dart';

class MyGroupsScreen extends StatefulWidget {
  const MyGroupsScreen({super.key});

  @override
  State<MyGroupsScreen> createState() => _MyGroupsScreenState();
}

class _MyGroupsScreenState extends State<MyGroupsScreen> {
  final GroupService groupService = GroupService();
  final AuthController authController = AuthController();

  List<GroupResponseModel> groups = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadGroups();
  }

  Future<void> loadGroups() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final user = await authController.getUserFromPreferences();

      if (user == null) {
        setState(() {
          errorMessage = 'Usuario no autenticado';
          isLoading = false;
        });
        return;
      }

      final fetchedGroups = await groupService.getAllGroupsByUserId(user.id);

      setState(() {
        groups = fetchedGroups;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Error al cargar grupos: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mis Grupos")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
          ? Center(child: Text(errorMessage!))
          : groups.isEmpty
          ? const Center(child: Text("No tienes grupos aún."))
          : ListView.builder(
              itemCount: groups.length,
              itemBuilder: (context, index) {
                final group = groups[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                      group.groupPhoto.isNotEmpty
                          ? group.groupPhoto
                          : 'https://via.placeholder.com/150',
                    ),
                  ),
                  title: Text(group.name),
                  subtitle: Text(group.description),
                  onTap: () {
                    //context.push('/groups/${group.id}');
                  },
                );
              },
            ),
    );
  }
}
