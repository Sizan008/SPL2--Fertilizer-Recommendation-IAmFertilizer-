import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'profile.dart'; // Profile Page import
import '../upload/upload_photo.dart'; // Upload Page import (Next step)

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final User? user = FirebaseAuth.instance.currentUser;

  // এই লিস্টে আপনার অ্যাপের ৫টি মেইন পেজ থাকবে
  final List<Widget> _pages = [
    const DashboardTab(),      // 0. Home/Dashboard
    const Center(child: Text("History Page (Coming Soon)")), // 1. History
    const Center(child: Text("Find Farmers (Coming Soon)")), // 2. Farmers
    const Center(child: Text("Chat List (Coming Soon)")),    // 3. Chat
    const ProfileScreen(),     // 4. Profile
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar শুধু ড্যাশবোর্ড বাদে অন্য পেজে দেখানো যেতে পারে, অথবা গ্লোবালি অফ রাখতে পারেন
      appBar: _currentIndex == 0
          ? AppBar(
        title: const Text("IAmFertilizer", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xff11998e),
        elevation: 0,
        automaticallyImplyLeading: false, // ব্যাক বাটন লুকানো
      )
          : null,

      body: _pages[_currentIndex],

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed, // ৫টি আইকনের জন্য এটি জরুরি
          selectedItemColor: const Color(0xff11998e),
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
            BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Farmers'),
            BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}

// --- Dashboard Tab Design (Index 0) ---
class DashboardTab extends StatelessWidget {
  const DashboardTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background Green Header
        Container(
          height: 150,
          decoration: const BoxDecoration(
            color: Color(0xff11998e),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
        ),

        // Main Content
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(height: 10),
              // Welcome Card
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      const Icon(Icons.eco, size: 50, color: Color(0xff11998e)),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text("Check Your Crop", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            Text("Take a photo to get fertilizer recommendation.", style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Big Upload Button
              Expanded(
                child: InkWell(
                  onTap: () {
                    // নেভিগেট টু আপলোড পেজ
                    Navigator.pushNamed(context, '/upload');
                  },
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: const Color(0xff11998e), width: 2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.camera_alt_rounded, size: 80, color: Color(0xff11998e)),
                        SizedBox(height: 10),
                        Text("Tap to Analyze Crop", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xff11998e))),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ],
    );
  }
}