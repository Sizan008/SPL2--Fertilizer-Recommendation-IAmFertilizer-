import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VerifyEmailScreen extends StatelessWidget {
  const VerifyEmailScreen({super.key});

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
          children: [
            const SizedBox(height: 100),
            const Icon(Icons.mark_email_unread_rounded, size: 100, color: Colors.white),
            const SizedBox(height: 20),
            const Text(
              "Verify Your Email",
              style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(30),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(50)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "A verification link has been sent to your email address. Please check your inbox and verify to complete registration.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    const Text(
                      "After complete the verification, Go to Login Page and Login to use the app",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.redAccent),
                    ),
                    const SizedBox(height: 40),

                    // ১. Back to Login Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff11998e),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        ),
                        onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false),
                        child: const Text("Go to Login Page", style: TextStyle(color: Colors.white, fontSize: 16)),
                      ),
                    ),
                    const SizedBox(height: 15),

                    // ২. Back to Register Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xff11998e)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        ),
                        onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/register', (route) => false),
                        child: const Text("Back to Register Page", style: TextStyle(color: Color(0xff11998e), fontSize: 16)),
                      ),
                    ),

                    const SizedBox(height: 30),
                    const Text(
                      "Didn't receive the email? Check your spam folder.",
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}