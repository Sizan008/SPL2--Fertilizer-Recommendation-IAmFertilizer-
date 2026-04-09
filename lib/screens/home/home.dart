import 'package:flutter/material.dart';
import '../history/history_screen.dart';
import '../chat/chat_list_screen.dart';
import '../upload/upload_photo.dart';
import 'profile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // স্ক্রিন লিস্ট
  final List<Widget> _pages = [
    const DashboardTab(),      // ইডেক্স ০: ড্যাশবোর্ড
    const HistoryScreen(),      // ইডেক্স ১: ইতিহাস
    const UploadPhotoScreen(),  // ইডেক্স ২: আপলোড (সরাসরি এখানে আনা হয়েছে)
    const ChatListScreen(),     // ইডেক্স ৩: চ্যাট
    const ProfileScreen(),      // ইডেক্স ৪: প্রোফাইল
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xff11998e),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: "History"),
          BottomNavigationBarItem(icon: Icon(Icons.add_a_photo), label: "Analyze"),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: "Chat"),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "Profile"),
        ],
      ),
    );
  }
}

// হোম পেজের মূল কন্টেন্ট (Dashboard)
class DashboardTab extends StatelessWidget {
  const DashboardTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("IAmFertilizer", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: const Color(0xff11998e),
        elevation: 0,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none, color: Colors.white))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // টপ ব্যানার
            Container(
              padding: const EdgeInsets.all(20),
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xff11998e),
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Welcome Farmer!", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  const Text("Let's check your crop health today.", style: TextStyle(color: Colors.white70, fontSize: 16)),
                  const SizedBox(height: 20),
                ],
              ),
            ),

            // কুইক স্ট্যাটাস বা ফিচার কার্ড
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildFeatureCard(
                      context,
                      "Latest Analysis",
                      "Rice Leaf Blast detected 2 days ago",
                      Icons.analytics_outlined,
                      Colors.orange
                  ),
                  const SizedBox(height: 15),
                  _buildFeatureCard(
                      context,
                      "Expert Tip",
                      "Use organic fertilizers for better soil health.",
                      Icons.lightbulb_outline,
                      Colors.blue
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard(BuildContext context, String title, String desc, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: Row(
        children: [
          CircleAvatar(backgroundColor: color.withOpacity(0.1), radius: 25, child: Icon(icon, color: color)),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text(desc, style: const TextStyle(color: Colors.grey, fontSize: 14)),
              ],
            ),
          )
        ],
      ),
    );
  }
}