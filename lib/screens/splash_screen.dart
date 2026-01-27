import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // ৩ সেকেন্ড পর চেক করবে ইউজার লগইন কি না
    Timer(const Duration(seconds: 3), () {
      checkUserStatus();
    });
  }

  void checkUserStatus() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // ইউজার লগইন থাকলে হোমে যাবে (আপাতত লগইনে পাঠাচ্ছি যেহেতু হোম তৈরি হয়নি)
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      // লগইন না থাকলে লগইন স্ক্রিনে যাবে
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff11998e), Color(0xff38ef7d)],
          ),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.eco, size: 100, color: Colors.white),
            SizedBox(height: 20),
            Text(
              "IAmFertilizer",
              style: TextStyle(color: Colors.white, fontSize: 35, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}