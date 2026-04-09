import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  // লগআউট ফাংশন
  void _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token'); // টোকেন ডিলিট করা হলো
    if (context.mounted) {
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          // প্রোফাইল হেডার
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 60, bottom: 30),
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [Color(0xff11998e), Color(0xff38ef7d)]),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
            ),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 50, color: Color(0xff11998e)),
                ),
                const SizedBox(height: 15),
                const Text("Farmer Name", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                const Text("Dhaka, Bangladesh", style: TextStyle(color: Colors.white70, fontSize: 16)),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // সেটিংস অপশন
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                _buildProfileItem(Icons.email, "Email", "farmer@example.com"),
                _buildProfileItem(Icons.phone, "Phone", "+880 123456789"),
                _buildProfileItem(Icons.security, "Privacy Policy", ""),
                const Divider(),

                // লগআউট বাটন
                ListTile(
                  onTap: () => _logout(context),
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: const Text("Logout", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileItem(IconData icon, String title, String value) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xff11998e)),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: value.isNotEmpty ? Text(value) : null,
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
    );
  }
}