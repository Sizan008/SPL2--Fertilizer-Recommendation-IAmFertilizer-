import 'package:flutter/material.dart';
import 'package:iamfertilizer/services/chat_service.dart';
import 'package:iamfertilizer/screens/chat/chat_room_screen.dart';

class ChatListScreen extends StatefulWidget {
  final int currentUserId;
  const ChatListScreen({super.key, required this.currentUserId});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final ChatService _chatService = ChatService();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(length: 3, child: Scaffold(
      appBar: AppBar(title: const Text("Community"), bottom: const TabBar(tabs: [Tab(text: "Chats"), Tab(text: "Requests"), Tab(text: "Search")])),
      body: TabBarView(children: [
        const Center(child: Text("Active Conversations")),
        FutureBuilder<List<dynamic>>(
          future: _chatService.getReceivedRequests(widget.currentUserId),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
            return ListView.builder(itemCount: snapshot.data!.length, itemBuilder: (context, index) {
              var req = snapshot.data![index];
              return ListTile(
                title: Text("Request from Farmer ID: ${req['sender_id']}"),
                trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                  IconButton(icon: const Icon(Icons.check, color: Colors.green), onPressed: () async {
                    await _chatService.acceptRequest(req['id']);
                    setState(() {});
                  }),
                ]),
              );
            });
          },
        ),
        const Center(child: Text("Use Search Tab in Login logic")),
      ]),
    ));
  }
}