<<<<<<< HEAD
import 'package:flutter/material.dart';
import 'package:iamfertilizer/services/chat_service.dart';
import 'package:iamfertilizer/screens/chat/chat_room_screen.dart';

class ChatListScreen extends StatefulWidget {
  final int currentUserId;
  const ChatListScreen({super.key, required this.currentUserId});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> with SingleTickerProviderStateMixin {
  final ChatService _chatService = ChatService();
  late TabController _tabController;

  bool loadingChats = true;
  bool loadingRequests = true;
  List<dynamic> conversations = [];
  List<dynamic> requests = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadData();
  }

  Future<void> _loadData() async {
    final chats = await _chatService.getConversations(widget.currentUserId);
    final reqs = await _chatService.getReceivedRequests(widget.currentUserId);

    if (!mounted) return;
    setState(() {
      conversations = chats;
      requests = reqs;
      loadingChats = false;
      loadingRequests = false;
    });
  }

  Future<void> _accept(int id) async {
    final result = await _chatService.acceptRequest(id);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result['message']),
        backgroundColor: result['success'] == true ? Colors.green : Colors.red,
      ),
    );
    _loadData();
  }

  Future<void> _reject(int id) async {
    final result = await _chatService.rejectRequest(id);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result['message']),
        backgroundColor: result['success'] == true ? Colors.orange : Colors.red,
      ),
    );
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Community"),
        backgroundColor: const Color(0xff11998e),
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "Chats"),
            Tab(text: "Requests"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          loadingChats
              ? const Center(child: CircularProgressIndicator())
              : conversations.isEmpty
              ? const Center(child: Text("No active conversations"))
              : RefreshIndicator(
            onRefresh: _loadData,
            child: ListView.builder(
              itemCount: conversations.length,
              itemBuilder: (context, index) {
                final chat = conversations[index];
                return ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xff11998e),
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  title: Text(chat['partner_name']),
                  subtitle: Text(chat['last_message'] ?? "Start chatting"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChatRoomScreen(
                          senderId: widget.currentUserId,
                          receiverId: chat['partner_id'],
                          partnerName: chat['partner_name'],
                        ),
                      ),
                    ).then((_) => _loadData());
                  },
                );
              },
            ),
          ),
          loadingRequests
              ? const Center(child: CircularProgressIndicator())
              : requests.isEmpty
              ? const Center(child: Text("No requests"))
              : RefreshIndicator(
            onRefresh: _loadData,
            child: ListView.builder(
              itemCount: requests.length,
              itemBuilder: (context, index) {
                final req = requests[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text("${req['sender_name']} (ID: ${req['sender_id']})"),
                    subtitle: Text(req['sender_location'] ?? ""),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.check, color: Colors.green),
                          onPressed: () => _accept(req['id']),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.red),
                          onPressed: () => _reject(req['id']),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
=======
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
>>>>>>> 996fe64 (added schemas and configured database)
}