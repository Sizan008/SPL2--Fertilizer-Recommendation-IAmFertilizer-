import 'package:flutter/material.dart';

// সব স্ক্রিন ইম্পোর্ট করা হলো
import '../screens/splash_screen.dart';
import '../screens/auth/login.dart';
import '../screens/auth/register.dart';
import '../screens/auth/verify_email.dart';
import '../screens/auth/forgot_password.dart';
import '../screens/home/home.dart';
import '../screens/upload/upload_photo.dart';

class AppRoutes {
  // রুট নেমগুলো কনস্ট্যান্ট হিসেবে রাখা ভালো যাতে স্পেলিং ভুল না হয়
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String verifyEmail = '/verify-email';
  static const String forgotPassword = '/forgot-password';
  static const String home = '/home';
  static const String upload = '/upload';

  // সব রুটকে একটি ম্যাপে সাজিয়ে মেইন ফাইলে পাঠানোর জন্য ফাংশন
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      splash: (context) => const SplashScreen(),
      login: (context) => const LoginScreen(),
      register: (context) => const RegisterScreen(),
      verifyEmail: (context) => const VerifyEmailScreen(),
      forgotPassword: (context) => const ForgotPasswordScreen(),
      home: (context) => const HomeScreen(),
      upload: (context) => const UploadPhotoScreen(),
    };
  }
}