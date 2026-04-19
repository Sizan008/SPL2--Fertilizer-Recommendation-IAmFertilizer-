import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:iamfertilizer/screens/chat/chat_list_screen.dart';
import 'package:iamfertilizer/screens/farmers/find_farmer.dart';
import 'package:iamfertilizer/screens/history/history_screen.dart';
import 'package:iamfertilizer/screens/home/profile.dart';
import 'package:iamfertilizer/screens/upload/upload_photo.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  int? _userId;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userId = prefs.getInt('user_id');
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_userId == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final pages = [
      _Dashboard(
        onAnalyzeTap: () => setState(() => _selectedIndex = 2),
        onHistoryTap: () => setState(() => _selectedIndex = 1),
        onFarmersTap: () => setState(() => _selectedIndex = 3),
        onChatTap: () => setState(() => _selectedIndex = 4),
      ),
      const HistoryScreen(),
      const UploadPhotoScreen(),
      FindFarmerScreen(currentUserId: _userId!),
      ChatListScreen(currentUserId: _userId!),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        selectedItemColor: const Color(0xff11998e),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: "History"),
          BottomNavigationBarItem(icon: Icon(Icons.camera_alt), label: "Analyze"),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: "Farmers"),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Chat"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}

class _Dashboard extends StatelessWidget {
  final VoidCallback onAnalyzeTap;
  final VoidCallback onHistoryTap;
  final VoidCallback onFarmersTap;
  final VoidCallback onChatTap;

  const _Dashboard({
    required this.onAnalyzeTap,
    required this.onHistoryTap,
    required this.onFarmersTap,
    required this.onChatTap,
  });

  Widget buildCard(String title, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 5),
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 38, color: const Color(0xff11998e)),
            const SizedBox(height: 12),
            Text(title, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff6fbfa),
      appBar: AppBar(
        title: const Text("IAmFertilizer"),
        backgroundColor: const Color(0xff11998e),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xff11998e), Color(0xff38ef7d)],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Smart Fertilizer Recommendation",
                    style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Capture or upload rice leaf image, get fertilizer suggestion, save history, and connect with farmers.",
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                children: [
                  buildCard("Analyze Crop", Icons.camera_alt, onAnalyzeTap),
                  buildCard("View History", Icons.history, onHistoryTap),
                  buildCard("Find Farmers", Icons.people, onFarmersTap),
                  buildCard("Open Chat", Icons.chat, onChatTap),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}