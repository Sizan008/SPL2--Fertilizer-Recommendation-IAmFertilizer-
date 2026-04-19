import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatService {
  final String baseUrl = "http://10.0.2.2:8000";

  Future<Map<String, dynamic>> sendRequest(int senderId, int receiverId) async {
    final uri = Uri.parse('$baseUrl/chat/send-request').replace(
      queryParameters: {
        "sender_id": senderId.toString(),
        "receiver_id": receiverId.toString(),
      },
    );

    final response = await http.post(uri);
    final data = jsonDecode(response.body);

    return {
      "success": response.statusCode == 200,
      "message": data['message'] ?? data['detail'] ?? "Failed"
    };
  }

  Future<List<dynamic>> getReceivedRequests(int userId) async {
    final uri = Uri.parse('$baseUrl/chat/received-requests').replace(
      queryParameters: {"user_id": userId.toString()},
    );

    final response = await http.get(uri);
    return response.statusCode == 200 ? jsonDecode(response.body) : [];
  }

  Future<Map<String, dynamic>> acceptRequest(int reqId) async {
    final uri = Uri.parse('$baseUrl/chat/accept-request').replace(
      queryParameters: {"req_id": reqId.toString()},
    );

    final response = await http.post(uri);
    final data = jsonDecode(response.body);
    return {
      "success": response.statusCode == 200,
      "message": data['message'] ?? "Failed"
    };
  }

  Future<Map<String, dynamic>> rejectRequest(int reqId) async {
    final uri = Uri.parse('$baseUrl/chat/reject-request').replace(
      queryParameters: {"req_id": reqId.toString()},
    );

    final response = await http.post(uri);
    final data = jsonDecode(response.body);
    return {
      "success": response.statusCode == 200,
      "message": data['message'] ?? "Failed"
    };
  }

  Future<List<dynamic>> getConversations(int userId) async {
    final uri = Uri.parse('$baseUrl/chat/conversations').replace(
      queryParameters: {"user_id": userId.toString()},
    );

    final response = await http.get(uri);
    return response.statusCode == 200 ? jsonDecode(response.body) : [];
  }

  Future<Map<String, dynamic>> sendMessage(int senderId, int receiverId, String content) async {
    final uri = Uri.parse('$baseUrl/chat/send-message').replace(
      queryParameters: {
        "sender_id": senderId.toString(),
        "receiver_id": receiverId.toString(),
        "content": content,
      },
    );

    final response = await http.post(uri);
    final data = jsonDecode(response.body);

    return {
      "success": response.statusCode == 200,
      "message": data['message'] ?? data['detail'] ?? "Failed"
    };
  }

  Future<List<dynamic>> getMessages(int user1Id, int user2Id) async {
    final uri = Uri.parse('$baseUrl/chat/messages').replace(
      queryParameters: {
        "user1_id": user1Id.toString(),
        "user2_id": user2Id.toString(),
      },
    );

    final response = await http.get(uri);
    return response.statusCode == 200 ? jsonDecode(response.body) : [];
  }
}