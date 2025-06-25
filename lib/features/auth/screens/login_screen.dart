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
      body: SafeArea(
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage("assets/images/PPLogo.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                TextFormField(
                  decoration: const InputDecoration(labelText: "Username"),
                  controller: _usernameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Por favor ingresa tu nombre de usuario";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: "Password",
                    suffixIcon: IconButton(
                      icon: Icon(
                        _hidePassword ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: (){
                        setState(() {
                          _hidePassword=!_hidePassword;
                        });
                      },
                    ),                    ),
                  obscureText: _hidePassword,
                  controller: _passwordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Por favor ingresa tu contraseña";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    // Navigate to sign up screen
                  },
                  child: SizedBox(
                    width: double.infinity,
                    child: const Text(
                      "¿Olvidaste tu contraseña?",
                      textAlign: TextAlign.end,
                      style: TextStyle(color: Colors.purpleAccent),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.purpleAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                  ),
                  onPressed: () async {
                    // Handle login logic
                    if (_formKey.currentState?.validate() ?? false) {
                      setState(() {
                        _isLoading = true; // Show loading state
                      });
                      // If the form is valid, proceed with login
                      try {
                        // Attempt to login using the auth provider
                        //show dialog while logging in
                        await authController.login(
                          LoginRequestModel(
                            username: _usernameController.text,
                            password: _passwordController.text,
                          )
                        );
                        // If login is successful, navigate to home screen
                        context.go("/home");
                      } catch (e) {
                        // Handle any errors that occur during login
                        if (mounted) {
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text("Error: $e")));
                        }
                      } finally {
                        if (mounted) {
                          setState(() {
                            _isLoading = false; // Hide loading state
                          });
                        }

                      }
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: _isLoading
                        ? CircularProgressIndicator()
                        : const Text("Iniciar sesión"),
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    context.pushReplacement("/auth/register");
                  },
                  child: SizedBox(
                    width: double.infinity,
                    child: const Text(
                      "¿Aún no tienes una cuenta? Regístrate aquí",
                      textAlign: TextAlign.end,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
