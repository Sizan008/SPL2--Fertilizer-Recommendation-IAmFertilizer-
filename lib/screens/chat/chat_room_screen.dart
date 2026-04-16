import 'package:flutter/material.dart';
import 'package:iamfertilizer/services/chat_service.dart';

class ChatRoomScreen extends StatefulWidget {
  final int senderId;
  final int receiverId;
  const ChatRoomScreen({super.key, required this.senderId, required this.receiverId});

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final ChatService _chatService = ChatService();
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chat Room")),
      body: Column(children: [
        Expanded(child: FutureBuilder<List<dynamic>>(
          future: _chatService.getMessages(widget.senderId, widget.receiverId),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const CircularProgressIndicator();
            return ListView.builder(itemCount: snapshot.data!.length, itemBuilder: (context, index) =>
                ListTile(title: Text(snapshot.data![index]['content']), subtitle: Text(snapshot.data![index]['sender_id'] == widget.senderId ? "Me" : "Farmer")));
          },
        )),
        Padding(padding: const EdgeInsets.all(8.0), child: Row(children: [
          Expanded(child: TextField(controller: _controller, decoration: const InputDecoration(hintText: "Message..."))),
          IconButton(icon: const Icon(Icons.send), onPressed: () async {
            await _chatService.sendMessage(widget.senderId, widget.receiverId, _controller.text);
            _controller.clear();
            setState(() {});
          })
        ])),
      ]),
    );
  }
}