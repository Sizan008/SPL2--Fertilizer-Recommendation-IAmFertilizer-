import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../utils/validators.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // 1. AuthService এর ইন্সট্যান্স তৈরি
  final AuthService _authService = AuthService();

  // 2. লোডিং স্টেট (বাটনে চাকা ঘোরানোর জন্য)
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // রেজিস্ট্রেশন ফাংশন
  void _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true; // লোডিং শুরু
      });

      // 3. আসল সার্ভিস কল করা
      String? result = await _authService.registerFarmer(
        name: _nameController.text.trim(),
        location: _locationController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      setState(() {
        _isLoading = false; // লোডিং শেষ
      });

      if (result == "success") {
        // সফল হলে ভেরিফিকেশন পেইজে নিয়ে যাওয়া
        if (mounted) {
          Navigator.pushNamed(context, '/verify-email');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Account created! Please verify your email.")),
          );
        }
      } else {
        // ফেইল হলে এরর মেসেজ দেখানো
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result ?? "Registration failed"),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [Color(0xff11998e), Color(0xff38ef7d)],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 80),
            const Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Create Account", style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Text("Start your journey with IAmFertilizer by SIZAN & RIFAT", style: TextStyle(color: Colors.white, fontSize: 15)),
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(60), topRight: Radius.circular(60)),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(30),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 40),
                        _buildTextField("Name", Icons.person, _nameController, (val) => Validators.validateRequired(val, "Name")),
                        const SizedBox(height: 20),
                        _buildTextField("Location", Icons.location_on, _locationController, (val) => Validators.validateRequired(val, "Location")),
                        const SizedBox(height: 20),
                        _buildTextField("Email", Icons.email, _emailController, Validators.validateEmail),
                        const SizedBox(height: 20),
                        _buildTextField("Password", Icons.lock, _passwordController, Validators.validatePassword, isObscure: true),
                        const SizedBox(height: 40),

                        // Register Button with Loading logic
                        MaterialButton(
                          onPressed: _isLoading ? null : _handleRegister, // লোডিং চলাকালীন বাটন কাজ করবে না
                          height: 50,
                          minWidth: double.infinity,
                          color: const Color(0xff11998e),
                          disabledColor: Colors.grey, // ডিজেবল কালার
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                          child: _isLoading
                              ? const CircularProgressIndicator(color: Colors.white) // লোডিং হলে চাকা ঘুরবে
                              : const Text("Register", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                        ),

                        TextButton(
                          onPressed: () => Navigator.pushNamed(context, '/login'),
                          child: const Text("Already have an account? Login", style: TextStyle(color: Color(0xff11998e))),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String hint, IconData icon, TextEditingController controller, String? Function(String?)? validator, {bool isObscure = false}) {
    return TextFormField(
      controller: controller,
      obscureText: isObscure,
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: const Color(0xff11998e)),
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
      ),
    );
  }
}