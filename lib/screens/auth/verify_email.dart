import 'package:flutter/material.dart';

class VerifyEmailScreen extends StatelessWidget {
  const VerifyEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.mark_email_unread_rounded, size: 120, color: Color(0xff11998e)),
            const SizedBox(height: 30),
            const Text("Verify your Email", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            const Text(
              "We have sent a verification link to your email. Please check and click the link to continue.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xff11998e), padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15)),
              onPressed: () {}, // Trigger resend email
              child: const Text("Resend Email", style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Back to Login", style: TextStyle(color: Colors.grey)),
            )
          ],
        ),
      ),
    );
  }
}