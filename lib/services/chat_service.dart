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
}