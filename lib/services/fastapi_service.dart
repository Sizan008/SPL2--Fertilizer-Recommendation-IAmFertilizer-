import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class FastApiService {
  // এমুলেটর থেকে লোকাল পিসি কানেক্ট করার জন্য এই আইপি ব্যবহার হয়
  static const String baseUrl = "http://10.0.2.2:8000";

  // --- রেজিস্ট্রেশন ফাংশন ---
  static Future<Map<String, dynamic>> register(
      String name, String email, String password, String location) async {
    final url = Uri.parse('$baseUrl/auth/register');

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": name,
          "email": email,
          "password": password,
          "location": location,
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return {"success": true, "data": jsonDecode(response.body)};
      } else {
        final error = jsonDecode(response.body);
        return {"success": false, "message": error['detail'] ?? "Registration failed"};
      }
    } catch (e) {
      return {"success": false, "message": "Connection error: $e"};
    }
  }

  // --- ইমেজ আপলোড এবং প্রেডিকশন ফাংশন (Updated) ---
  static Future<Map<String, dynamic>> uploadCropImage(String filePath) async {
    final url = Uri.parse('$baseUrl/predict');

    try {
      var request = http.MultipartRequest('POST', url);

      // ফাইলটি রিকোয়েস্টে যোগ করা
      request.files.add(
        await http.MultipartFile.fromPath('file', filePath),
      );

      // রিকোয়েস্ট পাঠানো
      var streamedResponse = await request.send();

      // রেসপন্স গ্রহণ করা
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        return {
          "success": true,
          "data": jsonDecode(response.body)
        };
      } else {
        return {
          "success": false,
          "message": "Server Error: ${response.statusCode}"
        };
      }
    } catch (e) {
      return {
        "success": false,
        "message": "Connection error: $e"
      };
    }
  }

  // এটি আপনার আগের ফাংশন, চাইলে এটিও রাখতে পারেন (একই কাজ করে)
  static Future<Map<String, dynamic>> predictCropDisease(File imageFile) async {
    return await uploadCropImage(imageFile.path);
  }
}