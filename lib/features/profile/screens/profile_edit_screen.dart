import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_app_pocketpartners/core/controllers/auth_controller.dart';
import 'package:mobile_app_pocketpartners/data/models/user_info/userinfo_request_model.dart';
import 'package:mobile_app_pocketpartners/data/services/userinformation_service.dart';
import 'package:mobile_app_pocketpartners/shared/services/upload_service.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _authController = AuthController();
  final _userInfoService = UserinformationService();
  final _uploadService = UploadService();
  final _imagePicker = ImagePicker();

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

  String? _imageUrl;
  bool _isLoading = false;
  bool _imageLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final user = await _authController.getUserFromPreferences();
    if (user != null) {
      final info = await _userInfoService.getByUserId(user.id);
      setState(() {
        firstNameController.text = info.firstName;
        lastNameController.text = info.lastName;
        emailController.text = info.email;
        phoneNumberController.text = info.phoneNumber;
        _imageUrl = info.photo;
      });
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _imagePicker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() => _imageLoading = true);
      final file = File(pickedFile.path);
      final url = await _uploadService.uploadImage(file);
      setState(() {
        _imageUrl = url;
        _imageLoading = false;
      });
    }
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final user = await _authController.getUserFromPreferences();
    if (user != null) {
      final updatedInfo = UserinfoRequestModel(
        userId: user.id,
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        email: emailController.text,
        phoneNumber: phoneNumberController.text,
        photo: _imageUrl ?? '',
      );
      print("🔁 Intentando actualizar: ${updatedInfo.toJson()}");
      try {
        await _userInfoService.updateUserInfo(updatedInfo);
        if (mounted) Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error al guardar cambios: $e")),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Editar Perfil")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 70,
                      backgroundImage: _imageUrl != null ? NetworkImage(_imageUrl!) : null,
                      backgroundColor: Colors.grey[300],
                      child: _imageLoading ? const CircularProgressIndicator() : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: IconButton(
                        icon: const Icon(Icons.photo_library, color: Colors.white),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.purple,
                          shape: const CircleBorder(),
                        ),
                        onPressed: () => _pickImage(ImageSource.gallery),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: firstNameController,
                decoration: const InputDecoration(labelText: "Nombre"),
                validator: (value) =>
                value == null || value.isEmpty ? "Campo requerido" : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: lastNameController,
                decoration: const InputDecoration(labelText: "Apellido"),
                validator: (value) =>
                value == null || value.isEmpty ? "Campo requerido" : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: "Correo"),
                keyboardType: TextInputType.emailAddress,
                validator: (value) =>
                value == null || value.isEmpty ? "Campo requerido" : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: phoneNumberController,
                decoration: const InputDecoration(labelText: "Teléfono"),
                keyboardType: TextInputType.phone,
                validator: (value) =>
                value == null || value.isEmpty ? "Campo requerido" : null,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _isLoading ? null : _saveChanges,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text("Guardar Cambios"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
