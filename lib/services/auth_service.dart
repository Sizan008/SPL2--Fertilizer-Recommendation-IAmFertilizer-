import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ১. রেজিস্ট্রেশন (Email, Password + Name & Location)
  Future<String?> registerFarmer({
    required String name,
    required String location,
    required String email,
    required String password,
  }) async {
    try {
      // Firebase Auth-এ ইউজার তৈরি
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = result.user;

      if (user != null) {
        // ইউজারের নাম এবং লোকেশন Firestore-এ সেভ করা
        await _firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'name': name,
          'location': location,
          'email': email,
          'createdAt': DateTime.now(),
        });

        // ভেরিফিকেশন ইমেইল পাঠানো
        await user.sendEmailVerification();
      }
      return "success";
    } catch (e) {
      return e.toString();
    }
  }

  // ২. লগইন
  // lib/services/auth_service.dart এর ভেতর loginFarmer ফাংশনটি এভাবে আপডেট করুন

  Future<String?> loginFarmer(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;

      if (user != null) {
        // ৩. চেক করছি ইউজার ইমেইল ভেরিফাই করেছে কি না
        if (!user.emailVerified) {
          await _auth.signOut(); // ভেরিফাই না করলে লগআউট করিয়ে দেব
          return "Please verify your email before logging in.";
        }
      }
      return "success";
    } catch (e) {
      return e.toString();
    }
  }

  // ৩. পাসওয়ার্ড রিসেট ইমেইল
  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  // ৪. লগআউট
  Future<void> logout() async {
    await _auth.signOut();
  }

  // ৫. কারেন্ট ইউজার চেক (লগইন আছে কি নেই)
  User? get currentUser => _auth.currentUser;
}