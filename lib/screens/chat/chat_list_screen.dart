import 'package:flutter/material.dart';
import 'chat_room_screen.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Agri-Messages", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView.separated(
        itemCount: 3,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            leading: const CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage('https://via.placeholder.com/150'),
            ),
            title: const Text("Dr. Rahim Ahmed", style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text("Your crop needs more nitrogen...", maxLines: 1, overflow: TextOverflow.ellipsis),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text("10:30 AM", style: TextStyle(fontSize: 12, color: Colors.grey)),
                SizedBox(height: 5),
                CircleAvatar(radius: 8, backgroundColor: Color(0xff11998e), child: Text("1", style: TextStyle(fontSize: 10, color: Colors.white))),
              ],
            ),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const ChatRoomScreen()));
            },
          );
        },
      ),
    );
  }
}