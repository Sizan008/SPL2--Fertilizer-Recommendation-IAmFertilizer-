import 'package:flutter/material.dart';
import 'package:iamfertilizer/services/auth_service.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  Future<void> _handleResetPassword() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please enter your email")));
      return;
    }

    setState(() => _isLoading = true);

    try {
      // AuthService এ এই ফাংশনটি কীভাবে কল করছেন তা নিশ্চিত করুন
      final result = await _authService.requestPasswordReset(email);

      if (mounted) {
        setState(() => _isLoading = false);
        // রেজাল্ট থেকে মেসেজ দেখাচ্ছি
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? "Check your email"),
            backgroundColor: (result['success'] ?? true) ? Colors.green : Colors.red,
          ),
        );

        if (result['success'] ?? false) {
          Navigator.pop(context);
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        // এরর এর বিস্তারিত দেখার জন্য এটা কাজে লাগবে
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    }
  }

  // বাকি বিল্ড মেথড আগের মতোই থাকবে...
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff11998e),
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, iconTheme: const IconThemeData(color: Colors.white)),
      body: Column(
        children: [
          const Icon(Icons.lock_reset, size: 80, color: Colors.white),
          const Text("Reset Password", style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 30),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(30),
              decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(50))),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const Text("Enter your email to receive a password reset link.", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
                    const SizedBox(height: 30),
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(hintText: "Email", prefixIcon: const Icon(Icons.email, color: Color(0xff11998e)), filled: true, fillColor: Colors.grey[100], border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none)),
                    ),
                    const SizedBox(height: 30),
                    MaterialButton(
                      onPressed: _isLoading ? null : _handleResetPassword,
                      height: 50,
                      minWidth: double.infinity,
                      color: const Color(0xff11998e),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                      child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text("Send Link", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}