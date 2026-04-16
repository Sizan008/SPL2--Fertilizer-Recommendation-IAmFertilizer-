// lib/screens/reset_password_screen.dart
import 'package:flutter/material.dart';
import 'package:iamfertilizer/services/auth_service.dart';
import 'dart:convert'; // jsonEncode এর জন্য এটি জরুরি
import 'package:http/http.dart' as http;

class ResetPasswordScreen extends StatefulWidget {
  final String email; // ইমেইলটি পাস করে আনতে হবে
  const ResetPasswordScreen({super.key, required this.email});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  Future<void> _submitNewPassword() async {
    // এখানে POST রিকোয়েস্ট যাবে backend এর /auth/reset-password এ
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8000/auth/reset-password'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": widget.email,
        "new_password": _passwordController.text
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Password Updated!")));
      Navigator.pop(context); // লগইন স্ক্রিনে ফিরে যাওয়া
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextField(controller: _passwordController, decoration: InputDecoration(hintText: "New Password")),
          MaterialButton(onPressed: _submitNewPassword, child: const Text("Update Password")),
        ],
      ),
    );
  }
}