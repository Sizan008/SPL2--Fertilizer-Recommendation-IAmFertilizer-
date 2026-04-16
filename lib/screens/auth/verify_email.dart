import 'dart:async';
import 'package:flutter/material.dart';
import 'package:iamfertilizer/services/auth_service.dart';

class VerifyEmailScreen extends StatefulWidget {
  final String email;
  const VerifyEmailScreen({super.key, required this.email});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  Timer? _timer;
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    // ভেরিফিকেশন চেক করার জন্য টাইমার
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      bool isVerified = await _authService.checkVerificationStatus(widget.email);

      if (isVerified && mounted) {
        _timer?.cancel();
        // ভেরিফিকেশন সফল হলে লগইন পেজে রিডাইরেক্ট
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Email verified successfully! Please login."),
            backgroundColor: Colors.green,
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // মেমোরি লিক এড়াতে টাইমার ক্যানসেল করা
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              colors: [Color(0xff11998e), Color(0xff38ef7d)]
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 120),
            const Icon(Icons.mark_email_unread_rounded, size: 100, color: Colors.white),
            const SizedBox(height: 20),
            const Text(
                "Verify Your Email",
                style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.all(30),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(50))
              ),
              child: Column(
                children: [
                  Text(
                    "A verification link has been sent to ${widget.email}.\nPlease click the link in your email to continue.",
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 30),
                  const CircularProgressIndicator(color: Color(0xff11998e)),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/register', (route) => false),
                    child: const Text(
                        "Use different email? Register again",
                        style: TextStyle(color: Color(0xff11998e), fontWeight: FontWeight.w600)
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}