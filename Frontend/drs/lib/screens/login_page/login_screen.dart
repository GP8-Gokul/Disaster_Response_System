import 'package:drs/services/authorization/user.dart';
import 'package:flutter/material.dart';
import 'package:drs/services/api/demo_login_api.dart';
import 'package:drs/screens/main_menu_page/main_menu_screen.dart';
import 'dart:developer' as devtools show log;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static String routeName = 'login-screen';

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;
  userAuth user = userAuth();

  Future<void> login() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    String username = _usernameController.text;
    String password = _passwordController.text;

    try {
      var response = await loginUser(username, password);
      devtools.log(response.statusCode.toString());
      if (response.statusCode == 200) {
        user.setUser(username, password, 'admin', response.body);
        Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(
            builder: (context) => const MainMenuScreen(),
          ),
        );
      } else {
        setState(() {
          _errorMessage = 'Server error. Please try again later.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Positioned.fill(
        child: Image.asset(
          'assets/images/6113099.jpg',
          fit: BoxFit.cover,
        ),
      ),
      Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 30),
                  _buildTextField(
                    controller: _usernameController,
                    label: 'Username',
                    isPassword: false,
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: _passwordController,
                    label: 'Password',
                    isPassword: true,
                  ),
                  const SizedBox(height: 30),
                  _isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[700],
                            padding: const EdgeInsets.symmetric(
                              horizontal: 100,
                              vertical: 15,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Login',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                  const SizedBox(height: 30),
                  _isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MainMenuScreen(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[700],
                            padding: const EdgeInsets.symmetric(
                              horizontal: 63,
                              vertical: 15,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Login as Guest',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                  const SizedBox(height: 20),
                  if (_errorMessage != null)
                    _buildErrorNotification(_errorMessage!)
                ],
              ),
            ),
          ),
        ),
      ),
    ]);
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required bool isPassword,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white54),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white54),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(10),
        ),
        filled: true,
        fillColor: Colors.grey[800],
      ),
    );
  }

  Widget _buildErrorNotification(String errorMessage) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.only(top: 20),
        decoration: BoxDecoration(
          color: Colors.red[600],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          errorMessage,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
