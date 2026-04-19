<<<<<<< HEAD
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
=======
import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatService {
  final String baseUrl = "http://10.0.2.2:8000";

  Future<void> sendRequest(int senderId, int receiverId) async {
    final response = await http.post(Uri.parse('$baseUrl/chat/send-request?sender_id=$senderId&receiver_id=$receiverId'));
    if (response.statusCode != 200) throw Exception("Error");
  }

  Future<List<dynamic>> getReceivedRequests(int userId) async {
    final response = await http.get(Uri.parse('$baseUrl/chat/received-requests?user_id=$userId'));
    return response.statusCode == 200 ? jsonDecode(response.body) : [];
  }

  Future<void> acceptRequest(int reqId) async {
    await http.post(Uri.parse('$baseUrl/chat/accept-request?req_id=$reqId'));
  }

  Future<void> rejectRequest(int reqId) async {
    await http.post(Uri.parse('$baseUrl/chat/reject-request?req_id=$reqId'));
  }

  Future<void> sendMessage(int senderId, int receiverId, String content) async {
    await http.post(Uri.parse('$baseUrl/chat/send-message?sender_id=$senderId&receiver_id=$receiverId&content=$content'));
  }

  Future<List<dynamic>> getMessages(int user1Id, int user2Id) async {
    final response = await http.get(Uri.parse('$baseUrl/chat/messages?user1_id=$user1Id&user2_id=$user2Id'));
    return response.statusCode == 200 ? jsonDecode(response.body) : [];
  }
>>>>>>> 996fe64 (added schemas and configured database)
}