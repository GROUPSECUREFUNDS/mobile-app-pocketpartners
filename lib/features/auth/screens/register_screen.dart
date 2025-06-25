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
      setState(() {
        _imageLoading = true;
      });
      String? urlImage = await uploadService.uploadImage(file);
      setState(() {
        _imageUrl = urlImage;
        _imageLoading = false;
      });
    } else {
      // Handle the case where no image was selected
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("No image selected")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ListView(
                children: [
                  const Text(
                    "Crea tu cuenta",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      // Circle avatar (150x150)
                      CircleAvatar(
                        radius: 75,
                        backgroundColor: Colors.grey[300],
                        backgroundImage: _imageUrl != null
                            ? NetworkImage(_imageUrl!)
                            : null,
                        child: _imageLoading
                            ? const CircularProgressIndicator()
                            : null,
                      ),

                      // Camera icon in the center
                      /*Positioned(
                        bottom: 0,

                        child: IconButton(
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.purple,
                            shape: CircleBorder(),
                          ),
                          icon: Icon(
                            Icons.photo_camera,
                            size: 20,
                            color: Colors.white,
                          ),
                          onPressed: () => _pickImage(ImageSource.camera),
                        ),
                      ),*/

                      // Gallery icon outside to the right
                      Positioned(
                        bottom: 0,
                        child: IconButton(
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.purple,
                            shape: CircleBorder(),
                          ),
                          icon: Icon(
                            Icons.photo_library,
                            size: 20,
                            color: Colors.white,
                          ),
                          onPressed: () => _pickImage(ImageSource.gallery),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  TextFormField(
                    controller: usernameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Por favor ingresa tu nombre de usuario";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(labelText: "Username"),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: passwordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Por favor ingresa tu contraseña";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(labelText: "Password"),
                    obscureText: true,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: firstNameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Por favor ingresa tu nombre";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(labelText: "First Name"),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: lastNameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Por favor ingresa tu apellido";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(labelText: "Last Name"),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Por favor ingresa tu correo electrónico";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(labelText: "Email"),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: phoneNumberController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Por favor ingresa tu número de teléfono";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: "Phone Number",
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.purpleAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                    ),
                    onPressed: () {
                      if (!_formKey.currentState!.validate() ||
                          _imageUrl == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Por favor completa todos los campos",
                            ),
                          ),
                        );
                        return; // If the form is not valid, do not proceed
                      }
                      setState(() {
                        _isLoading = true; // Show loading state
                      });

                      authController.register(
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
                          .then((value) {context.go("/home");})
                          .catchError((error) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Error: $error")),
                            );
                          })
                          .whenComplete(() {
                            setState(() {
                              _isLoading = false; // Hide loading state
                            });
                          });
                    },
                    child: Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "Registrarse",
                              style: TextStyle(fontSize: 16),
                            ),
                    ),
                  ),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      // Navigate to login screen
                      context.push("/login");
                    },
                    child: SizedBox(
                      width: double.infinity,
                      child: const Text(
                        "¿Ya tienes una cuenta? Inicia sesión",
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
