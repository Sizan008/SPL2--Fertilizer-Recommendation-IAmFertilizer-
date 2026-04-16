import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:iamfertilizer/services/auth_service.dart';
import 'package:iamfertilizer/utils/validators.dart';
import 'package:iamfertilizer/screens/auth/register.dart'; // রেজিস্টার পেজ ইমপোর্ট

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      var result = await _authService.loginFarmer(_emailController.text.trim(), _passwordController.text.trim());
      setState(() => _isLoading = false);

      if (result['success'] == true) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_email', _emailController.text.trim());
        await prefs.setInt('user_id', result['user_id'] ?? 1);
        if (mounted) Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result['message'] ?? "Login failed"), backgroundColor: Colors.red));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topRight, colors: [Color(0xff11998e), Color(0xff38ef7d)])),
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.eco, size: 80, color: Colors.white),
              const SizedBox(height: 20),
              Form(key: _formKey, child: Column(children: [
                TextFormField(controller: _emailController, validator: Validators.validateEmail, decoration: const InputDecoration(labelText: "Email", filled: true, fillColor: Colors.white, border: OutlineInputBorder())),
                const SizedBox(height: 20),
                TextFormField(controller: _passwordController, obscureText: true, decoration: const InputDecoration(labelText: "Password", filled: true, fillColor: Colors.white, border: OutlineInputBorder())),
              ])),
              Align(alignment: Alignment.centerRight, child: TextButton(onPressed: () => Navigator.pushNamed(context, '/forgot-password'), child: const Text("Forgot Password?", style: TextStyle(color: Colors.white)))),
              ElevatedButton(onPressed: _isLoading ? null : _handleLogin, child: _isLoading ? const CircularProgressIndicator() : const Text("LOGIN")),
              TextButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterScreen())), child: const Text("Don't have an account? Register Now", style: TextStyle(color: Colors.white))),
            ],
          ),
        ),
      ),
    );
  }
}