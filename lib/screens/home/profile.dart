import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final User? user = FirebaseAuth.instance.currentUser;
  final AuthService _authService = AuthService();

  // ইউজার ডেটা ফেচ করার ফিউচার ফাংশন
  Future<DocumentSnapshot<Map<String, dynamic>>> getUserData() async {
    return await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: getUserData(),
        builder: (context, snapshot) {
          // 1. Loading State
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Color(0xff11998e)));
          }

          // 2. Error State
          if (snapshot.hasError) {
            return const Center(child: Text("Something went wrong!"));
          }

          // 3. Data Loaded State
          if (snapshot.hasData && snapshot.data!.exists) {
            Map<String, dynamic> data = snapshot.data!.data()!;

            return SingleChildScrollView(
              child: Column(
                children: [
                  // Header Section
                  Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      Container(
                        height: 200,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xff11998e), Color(0xff38ef7d)],
                          ),
                          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
                        ),
                      ),
                      Positioned(
                        bottom: -50,
                        child: CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius: 55,
                            backgroundColor: Colors.grey[200],
                            backgroundImage: const AssetImage('assets/images/farmer_placeholder.png'), // Add an image to assets if you have one, or use Icon
                            child: data['photoUrl'] == null
                                ? const Icon(Icons.person, size: 60, color: Colors.grey)
                                : null, // If you implement photo upload for profile later
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 60),

                  // User Info
                  Text(
                    data['name'] ?? "Unknown Farmer",
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    data['email'] ?? "",
                    style: const TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                  const SizedBox(height: 20),

                  // Info Cards
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        _buildProfileCard(Icons.location_on, "Location", data['location'] ?? "Not set"),
                        const SizedBox(height: 10),
                        _buildProfileCard(Icons.verified_user, "Status", user!.emailVerified ? "Verified User" : "Unverified"),
                        const SizedBox(height: 30),

                        // Logout Button
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            ),
                            onPressed: () async {
                              await _authService.logout();
                              if (context.mounted) {
                                // লগআউটের পর লগইন স্ক্রিনে ফিরিয়ে নেওয়া এবং পিছনের সব রুট মুছে ফেলা
                                Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                              }
                            },
                            icon: const Icon(Icons.logout, color: Colors.white),
                            label: const Text("Log Out", style: TextStyle(color: Colors.white, fontSize: 16)),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          }

          return const Center(child: Text("User not found"));
        },
      ),
    );
  }

  Widget _buildProfileCard(IconData icon, String title, String value) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: const Color(0xff11998e).withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: const Color(0xff11998e)),
        ),
        title: Text(title, style: const TextStyle(fontSize: 14, color: Colors.grey)),
        subtitle: Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }
}