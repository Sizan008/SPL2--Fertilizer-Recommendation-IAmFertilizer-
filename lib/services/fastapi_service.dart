import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FastApiService {
  static const String baseUrl = "http://10.0.2.2:8000";

  static Future<Map<String, dynamic>> uploadCropImage(String filePath) async {
    final url = Uri.parse('$baseUrl/predict');

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      var request = http.MultipartRequest('POST', url);
      request.headers['Authorization'] = 'Bearer $token';
      request.files.add(await http.MultipartFile.fromPath('file', filePath));

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        return {
          "success": true,
          "data": jsonDecode(response.body),
        };
      } else {
        final body = jsonDecode(response.body);
        return {
          "success": false,
          "message": body['detail'] ?? "Server Error"
        };
      }
    } catch (e) {
      return {
        "success": false,
        "message": "Connection error: $e"
      };
    }
  }
}