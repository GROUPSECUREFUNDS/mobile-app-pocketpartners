import "dart:io";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";
import "package:image_picker/image_picker.dart";
import "package:mobile_app_pocketpartners/data/models/auth/register_request_model.dart";
import "package:mobile_app_pocketpartners/data/models/user_info/userinfo_request_model.dart";
import "package:mobile_app_pocketpartners/shared/services/upload_service.dart";
import "../../../core/controllers/auth_controller.dart";

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final uploadService = UploadService();
  final authController = AuthController();
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _imagePicker = ImagePicker();

  bool _imageLoading = false;
  bool _isLoading = false;
  String? _imageUrl;

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _imagePicker.pickImage(source: source);
    if (pickedFile != null) {
      var file = File(pickedFile.path);
      setState(() => _imageLoading = true);
      String? urlImage = await uploadService.uploadImage(file);
      setState(() {
        _imageUrl = urlImage;
        _imageLoading = false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No image selected")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF7B2FF7), Color(0xFF9F44D3)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    "Crea tu cuenta",
                    style: TextStyle(
                      fontSize: 28,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.grey[300],
                        backgroundImage: _imageUrl != null ? NetworkImage(_imageUrl!) : null,
                        child: _imageLoading
                            ? const CircularProgressIndicator()
                            : (_imageUrl == null
                            ? const Icon(Icons.person, size: 60, color: Colors.grey)
                            : null),
                      ),
                      Positioned(
                        bottom: 0,
                        child: IconButton(
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.purple,
                            shape: const CircleBorder(),
                          ),
                          icon: const Icon(Icons.photo_camera, color: Colors.white),
                          onPressed: () => _pickImage(ImageSource.gallery),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            _buildField(Icons.person, "Username", usernameController, false),
                            const SizedBox(height: 12),
                            _buildField(Icons.lock, "Password", passwordController, true),
                            const SizedBox(height: 12),
                            _buildField(Icons.badge, "First Name", firstNameController, false),
                            const SizedBox(height: 12),
                            _buildField(Icons.badge_outlined, "Last Name", lastNameController, false),
                            const SizedBox(height: 12),
                            _buildField(Icons.email, "Email", emailController, false, keyboardType: TextInputType.emailAddress),
                            const SizedBox(height: 12),
                            _buildField(Icons.phone, "Phone Number", phoneNumberController, false, keyboardType: TextInputType.phone),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.purpleAccent,
                                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: _isLoading
                                    ? null
                                    : () {
                                  if (!_formKey.currentState!.validate() || _imageUrl == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text("Por favor completa todos los campos")),
                                    );
                                    return;
                                  }
                                  setState(() => _isLoading = true);
                                  authController
                                      .register(
                                    RegisterRequestModel(
                                      username: usernameController.text,
                                      password: passwordController.text,
                                    ),
                                    UserinfoRequestModel(
                                      firstName: firstNameController.text,
                                      lastName: lastNameController.text,
                                      email: emailController.text,
                                      phoneNumber: phoneNumberController.text,
                                      photo: _imageUrl ?? "",
                                      userId: 0,
                                    ),
                                  )
                                      .then((value) => context.go("/home"))
                                      .catchError((error) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text("Error: $error")),
                                    );
                                  })
                                      .whenComplete(() {
                                    setState(() => _isLoading = false);
                                  });
                                },
                                child: _isLoading
                                    ? const CircularProgressIndicator(color: Colors.white)
                                    : const Text("Registrarse", style: TextStyle(fontSize: 16)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      context.push("/login");
                    },
                    child: const Text(
                      "¿Ya tienes una cuenta? Inicia sesión",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField(IconData icon, String label, TextEditingController controller, bool obscure,
      {TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Por favor completa este campo";
        }
        return null;
      },
    );
  }
}
