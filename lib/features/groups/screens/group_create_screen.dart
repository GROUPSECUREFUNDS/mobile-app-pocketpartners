import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app_pocketpartners/core/controllers/auth_controller.dart';
import 'package:mobile_app_pocketpartners/data/models/group/group_request_model.dart';
import 'package:mobile_app_pocketpartners/data/services/group/group_service.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({super.key});

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();

  final groupService = GroupService();
  final authController = AuthController();

  bool isLoading = false;

  Future<void> createGroup() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      final user = await authController.getUserFromPreferences();
      if (user == null) throw Exception("Usuario no autenticado");

      final newGroup = GroupRequestModel(
        name: nameController.text,
        description: descriptionController.text,
        groupPhoto: "https://via.placeholder.com/150", // Imagen genérica
        adminId: user.id,
      );

      await groupService.createGroup(newGroup);

      if (!mounted) return;
      context.pop(true); // Indica que se creó un grupo
    } catch (e) {
      print("Error al crear grupo: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error al crear el grupo")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Crear Grupo")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Nombre del Grupo"),
                validator: (value) =>
                    value == null || value.isEmpty ? "Campo obligatorio" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: "Descripción"),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: createGroup,
                      child: const Text("Crear"),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
