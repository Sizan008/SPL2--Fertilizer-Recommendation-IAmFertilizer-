import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HistoryService {
  final String baseUrl = "http://10.0.2.2:8000/history";

  Future<List<dynamic>> getCropHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token'); // লগইন করার সময় সেভ করা টোকেন

    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        "Authorization": "Bearer $token", // সার্ভারকে জানানো যে আমি বৈধ ইউজার
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load history");
    }
  }
}