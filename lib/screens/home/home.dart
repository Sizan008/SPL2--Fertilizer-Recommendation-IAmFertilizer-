import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:iamfertilizer/screens/chat/chat_list_screen.dart';
import 'package:iamfertilizer/screens/home/profile.dart';

// আপনার তৈরি করা অন্যান্য পেজগুলো ইমপোর্ট করুন
// import 'package:iamfertilizer/screens/home/history_screen.dart';
// import 'package:iamfertilizer/screens/home/analyze_screen.dart';

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

    // এখানে সব পেজগুলো লিস্টে রাখুন
    final List<Widget> pages = [
      const Center(child: Text("Home Dashboard")), // Home
      const Center(child: Text("History Section")), // History
      const Center(child: Text("Analyze Section")), // Analyze
      ChatListScreen(currentUserId: _userId!), // Chat
      const ProfileScreen(), // Profile
    ];

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // ৫টি আইটেমের জন্য এটি জরুরি
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        selectedItemColor: const Color(0xff11998e),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: "History"),
          BottomNavigationBarItem(icon: Icon(Icons.camera_alt), label: "Analyze"),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Chat"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}