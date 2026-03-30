import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // আপনার পিসির IP (Localhost এ কাজ করলে 10.0.2.2 ব্যবহার করতে হয় অ্যান্ড্রয়েড এমুলেটরে)
  final String baseUrl = "http://10.0.2.2:8000/auth";

  // ১. রেজিস্ট্রেশন
  Future<String?> registerFarmer({
    required String name,
    required String location,
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": name,
        "location": location,
        "email": email,
        "password": password,
      }),
    );

    if (response.statusCode == 201) {
      return "success";
    } else {
      final error = jsonDecode(response.body);
      return error['detail'] ?? "Registration failed";
    }
  }

  // ২. লগইন (JWT Token সংগ্রহ করা)
  Future<String?> loginFarmer(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // টোকেনটি মোবাইলের লোকাল স্টোরেজে সেভ করা
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', data['access_token']);

      return "success";
    } else {
      return "Invalid email or password";
    }
  }

  // ৩. লগআউট
  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }
}