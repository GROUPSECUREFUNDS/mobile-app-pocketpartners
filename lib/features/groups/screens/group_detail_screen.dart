import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app_pocketpartners/data/models/group/group_response_model.dart';
import 'package:mobile_app_pocketpartners/data/models/group/group_member_response_model.dart';
import 'package:mobile_app_pocketpartners/data/services/group/group_service.dart';
import 'package:mobile_app_pocketpartners/data/services/group/groupmembers_service.dart';
import 'package:mobile_app_pocketpartners/core/controllers/auth_controller.dart';

class GroupDetailsScreen extends StatefulWidget {
  final int groupId;

  const GroupDetailsScreen({super.key, required this.groupId});

  @override
  State<GroupDetailsScreen> createState() => _GroupDetailsScreenState();
}

class _GroupDetailsScreenState extends State<GroupDetailsScreen> {
  final groupService = GroupService();
  final groupMembersService = GroupMembersService();
  final authController = AuthController();

  GroupResponseModel? group;
  List<GroupMemberResponseModel> members = [];
  bool isLoading = true;
  int? currentUserId;

  @override
  void initState() {
    super.initState();
    loadGroupDetails();
  }

  Future<void> loadGroupDetails() async {
    setState(() => isLoading = true);

    try {
      final user = await authController.getUserFromPreferences();
      if (user != null) {
        currentUserId = user.id;
        group = await groupService.getById(widget.groupId);
        members = await groupMembersService.getGroupMembers(widget.groupId);
      }
    } catch (e) {
      print("Error al cargar detalles del grupo: $e");
    }

    setState(() => isLoading = false);
  }

  /*@override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (group == null) {
      return const Scaffold(body: Center(child: Text("Grupo no encontrado")));
    }

    return Scaffold(
      appBar: AppBar(title: Text(group!.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Información del grupo
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Image.network(group!.groupPhoto, height: 100),
                    const SizedBox(height: 10),
                    Text(group!.description),
                    const SizedBox(height: 10),
                    Text(
                      "Fecha de creación: ${DateFormat('dd/MM/yyyy').format(group!.createdAt)}",
                    ),
                    Text("Miembros: ${members.length}"),
                    if (group!.adminId == currentUserId)
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            "/group-config/${group!.id}",
                          );
                        },
                        child: const Text("Editar grupo"),
                      ),
                  ],
                ),
              ),
            ),

            // Lista de miembros
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Miembros",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    for (var member in members)
                      ListTile(
                        title: Text(member.fullName),
                        subtitle: Text("Rol: ${member.role}"),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }*/

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (group == null) {
      return const Scaffold(body: Center(child: Text("Grupo no encontrado")));
    }

    return Scaffold(
      appBar: AppBar(title: Text(group!.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Image.network(group!.groupPhoto, height: 100),
                        const SizedBox(height: 10),
                        Text(group!.description),
                        const SizedBox(height: 10),
                        Text(
                          "Fecha de creación: ${DateFormat('dd/MM/yyyy').format(group!.createdAt)}",
                        ),
                        Text("Miembros: ${members.length}"),
                        if (group!.adminId == currentUserId)
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                "/group-config/${group!.id}",
                              );
                            },
                            child: const Text("Editar grupo"),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Miembros",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        for (var member in members)
                          ListTile(
                            title: Text(member.fullName),
                            subtitle: Text("Rol: ${member.role}"),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
