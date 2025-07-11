import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";
import "package:mobile_app_pocketpartners/core/controllers/auth_controller.dart";
import "package:mobile_app_pocketpartners/data/models/auth/login_request_model.dart";

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final authController = AuthController();

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _hidePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
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
                  const SizedBox(height: 40),
                  // Logo
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: AssetImage("assets/images/PPLogo.png"),
                    backgroundColor: Colors.transparent,
                  ),
                  const SizedBox(height: 30),
                  // Card con formulario
                  Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Form(
                        key: _formKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Column(
                          children: [
                            TextFormField(
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.person),
                                labelText: "Usuario",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              controller: _usernameController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Por favor ingresa tu nombre de usuario";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.lock),
                                labelText: "Contraseña",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _hidePassword
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _hidePassword = !_hidePassword;
                                    });
                                  },
                                ),
                              ),
                              obscureText: _hidePassword,
                              controller: _passwordController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Por favor ingresa tu contraseña";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 12),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  // Aquí iría lógica de "olvide contraseña"
                                },
                                child: const Text(
                                  "¿Olvidaste tu contraseña?",
                                  style: TextStyle(color: Colors.purpleAccent),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
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
                                    : () async {
                                  if (_formKey.currentState?.validate() ?? false) {
                                    setState(() => _isLoading = true);
                                    try {
                                      await authController.login(
                                        LoginRequestModel(
                                          username: _usernameController.text,
                                          password: _passwordController.text,
                                        ),
                                      );
                                      context.go("/home");
                                    } catch (e) {
                                      if (mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text("Error: $e")),
                                        );
                                      }
                                    } finally {
                                      if (mounted) {
                                        setState(() => _isLoading = false);
                                      }
                                    }
                                  }
                                },
                                child: _isLoading
                                    ? const CircularProgressIndicator(color: Colors.white)
                                    : const Text(
                                  "Iniciar sesión",
                                  style: TextStyle(fontSize: 16),
                                ),
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
                      context.push("/register");
                    },
                    child: const Text(
                      "¿Aún no tienes una cuenta? Regístrate aquí",
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
}
