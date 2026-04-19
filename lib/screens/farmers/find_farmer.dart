import 'package:flutter/material.dart';
import 'package:iamfertilizer/services/auth_service.dart';
import 'package:iamfertilizer/services/chat_service.dart';

class FindFarmerScreen extends StatefulWidget {
  final int currentUserId;
  const FindFarmerScreen({super.key, required this.currentUserId});

  @override
  State<FindFarmerScreen> createState() => _FindFarmerScreenState();
}

class _FindFarmerScreenState extends State<FindFarmerScreen> {
  final AuthService _authService = AuthService();
  final ChatService _chatService = ChatService();
  final TextEditingController _searchController = TextEditingController();

  bool isLoading = true;
  List<dynamic> farmers = [];

  @override
  void initState() {
    super.initState();
    _searchFarmers();
  }

  Future<void> _searchFarmers() async {
    setState(() => isLoading = true);
    final results = await _authService.searchFarmers(
      _searchController.text.trim(),
      widget.currentUserId,
    );

    if (!mounted) return;
    setState(() {
      farmers = results;
      isLoading = false;
    });
  }

  Future<void> _sendRequest(int receiverId) async {
    final result = await _chatService.sendRequest(widget.currentUserId, receiverId);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result['message'] ?? "Done"),
        backgroundColor: result['success'] == true ? Colors.green : Colors.red,
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Find Farmers"),
        backgroundColor: const Color(0xff11998e),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: "Search by id, name, location, email",
                      prefixIcon: Icon(Icons.search),
                    ),
                    onSubmitted: (_) => _searchFarmers(),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _searchFarmers,
                  child: const Text("Search"),
                ),
              ],
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : farmers.isEmpty
                ? const Center(child: Text("No farmers found"))
                : ListView.builder(
              itemCount: farmers.length,
              itemBuilder: (context, index) {
                final farmer = farmers[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Color(0xff11998e),
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                    title: Text("${farmer['name']} (ID: ${farmer['id']})"),
                    subtitle: Text("${farmer['location']}\n${farmer['email']}"),
                    isThreeLine: true,
                    trailing: ElevatedButton(
                      onPressed: () => _sendRequest(farmer['id']),
                      child: const Text("Request"),
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
}