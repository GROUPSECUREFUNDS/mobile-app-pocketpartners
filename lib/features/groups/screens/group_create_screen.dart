import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app_pocketpartners/core/controllers/auth_controller.dart';
import 'package:mobile_app_pocketpartners/data/models/group/group_request_model.dart';
import 'package:mobile_app_pocketpartners/data/services/group/group_service.dart';
import 'package:mobile_app_pocketpartners/shared/services/upload_service.dart';

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

  File? selectedImage;
  String? uploadedImageUrl;
  final uploadService = UploadService();

  Future<void> createGroup() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      final user = await authController.getUserFromPreferences();
      if (user == null) throw Exception("Usuario no autenticado");

      final newGroup = GroupRequestModel(
        name: nameController.text,
        description: descriptionController.text,
        groupPhoto: uploadedImageUrl ?? "https://via.placeholder.com/150",
        adminId: user.id,
      );

      await groupService.createGroup(newGroup);

      if (!mounted) return;
      context.pop(true); // Indica que se creó un grupo
    } catch (e) {
      print("Error al crear grupo: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Error al crear el grupo")));
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> pickAndUploadImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        selectedImage = File(picked.path);
      });

      try {
        final url = await uploadService.uploadImage(selectedImage!);
        setState(() {
          uploadedImageUrl = url;
        });
      } catch (e) {
        print("Error al subir imagen: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error al subir la imagen")),
        );
      }
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
                decoration: const InputDecoration(
                  labelText: "Nombre del Grupo",
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? "Campo obligatorio" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: "Descripción"),
                maxLines: 3,
              ),

              // 📷 Subida de imagen
              const SizedBox(height: 16),
              Row(
                children: [
                  if (selectedImage != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        selectedImage!,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    )
                  else
                    const Icon(Icons.image, size: 80, color: Colors.grey),
                  const SizedBox(width: 16),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.upload_file),
                    label: const Text("Subir imagen"),
                    onPressed: pickAndUploadImage,
                  ),
                ],
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
