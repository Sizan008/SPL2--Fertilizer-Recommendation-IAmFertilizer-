import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  // লগইন স্ট্যাটাস চেক করার ফাংশন
  void _checkAuthStatus() async {
    // ২ সেকেন্ড ওয়েট করবে (অ্যানিমেশন বা লোগো দেখানোর জন্য)
    await Future.delayed(const Duration(seconds: 2));

    // Shared Preferences থেকে টোকেন চেক করা
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (mounted) {
      if (token != null) {
        // টোকেন থাকলে সরাসরি হোম পেজে
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        // টোকেন না থাকলে লগইন পেজে
        Navigator.pushReplacementNamed(context, '/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xff11998e),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.eco, size: 100, color: Colors.white),
            SizedBox(height: 20),
            Text(
              "IAmFertilizer",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}