<<<<<<< HEAD
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String baseUrl = "http://10.0.2.2:8000";

  Future<Map<String, dynamic>> registerFarmer({
    required String name,
    required String location,
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": name,
          "location": location,
          "email": email,
          "password": password,
        }),
      );

      final data = jsonDecode(response.body);
      return {
        "success": response.statusCode == 201,
        "message": data['message'] ?? data['detail'] ?? "Registration failed"
      };
    } catch (e) {
      return {"success": false, "message": "Connection error: $e"};
    }
  }

  Future<Map<String, dynamic>> loginFarmer(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', data['access_token']);
        await prefs.setInt('user_id', data['user_id']);
        await prefs.setString('user_email', data['email']);

        return {
          "success": true,
          "message": data['message'] ?? "Login successful",
          "user_id": data['user_id'],
          "access_token": data['access_token'],
          "email": data['email'],
        };
      } else {
        return {
          "success": false,
          "message": data['detail'] ?? "Invalid credentials"
        };
      }
    } catch (e) {
      return {"success": false, "message": "Connection error: $e"};
    }
  }

  Future<bool> checkVerificationStatus(String email) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/auth/status?email=$email'));
      if (response.statusCode == 200) {
        return jsonDecode(response.body)['is_verified'] ?? false;
      }
    } catch (_) {}
    return false;
  }

  Future<Map<String, dynamic>> requestPasswordReset(String email) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/forgot-password'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email}),
      );

      final data = jsonDecode(response.body);
      return {
        "success": response.statusCode == 200,
        "message": data['message'] ?? "Failed to send reset link"
      };
    } catch (e) {
      return {"success": false, "message": "Connection error: $e"};
    }
  }

  Future<Map<String, dynamic>> resetPassword(String email, String newPassword) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/reset-password'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "new_password": newPassword}),
      );

      final data = jsonDecode(response.body);
      return {
        "success": response.statusCode == 200,
        "message": data['message'] ?? "Failed to update password"
      };
    } catch (e) {
      return {"success": false, "message": "Connection error: $e"};
    }
  }

  Future<Map<String, dynamic>> getMyProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final response = await http.get(
        Uri.parse('$baseUrl/auth/me'),
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        return {
          "success": true,
          "data": jsonDecode(response.body),
        };
      }

      final data = jsonDecode(response.body);
      return {"success": false, "message": data['detail'] ?? "Failed"};
    } catch (e) {
      return {"success": false, "message": "Connection error: $e"};
    }
  }

  Future<List<dynamic>> searchFarmers(String query, int currentUserId) async {
    final uri = Uri.parse('$baseUrl/farmers/search')
        .replace(queryParameters: {
      "q": query,
      "current_user_id": currentUserId.toString(),
    });

    final response = await http.get(uri);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return [];
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
=======
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // এমুলেটরের জন্য সঠিক আইপি
  final String baseUrl = "http://10.0.2.2:8000";

  // ১. রেজিস্ট্রেশন
  Future<Map<String, dynamic>> registerFarmer({
    required String name,
    required String location,
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": name,
          "location": location,
          "email": email,
          "password": password,
        }),
      );

      final data = jsonDecode(response.body);
      return {
        "success": response.statusCode == 201,
        "message": data['message'] ?? data['detail'] ?? "Registration failed"
      };
    } catch (e) {
      return {"success": false, "message": "Connection error: $e"};
    }
  }

  // ২. লগইন
  Future<Map<String, dynamic>> loginFarmer(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', data['access_token']);
        return {"success": true, "message": "Login successful!"};
      } else {
        return {"success": false, "message": data['detail'] ?? "Invalid credentials"};
      }
    } catch (e) {
      return {"success": false, "message": "Connection error: $e"};
    }
  }

  // ৩. ইমেইল ভেরিফিকেশন স্ট্যাটাস
  Future<bool> checkVerificationStatus(String email) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/auth/status?email=$email'));
      if (response.statusCode == 200) {
        return jsonDecode(response.body)['is_verified'] ?? false;
      }
    } catch (e) {
      print("Error checking status: $e");
    }
    return false;
  }

  // ৪. পাসওয়ার্ড রিসেট রিকোয়েস্ট (ইমেইল পাঠানোর জন্য)
  Future<Map<String, dynamic>> requestPasswordReset(String email) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/forgot-password'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email}),
      );

      final data = jsonDecode(response.body);
      return {
        "success": response.statusCode == 200,
        "message": data['message'] ?? "Failed to send reset link"
      };
    } catch (e) {
      return {"success": false, "message": "Connection error: $e"};
    }
  }

  // ৫. অ্যাপের ভেতরে পাসওয়ার্ড পরিবর্তন করার ফাংশন (নতুন)
  Future<Map<String, dynamic>> resetPassword(String email, String newPassword) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/reset-password'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "new_password": newPassword}),
      );

      final data = jsonDecode(response.body);
      return {
        "success": response.statusCode == 200,
        "message": data['message'] ?? "Failed to update password"
      };
    } catch (e) {
      return {"success": false, "message": "Connection error: $e"};
    }
  }

  // ৬. লগআউট
  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }
>>>>>>> 996fe64 (added schemas and configured database)
}