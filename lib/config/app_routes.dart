import 'package:flutter/material.dart';
import '../screens/splash_screen.dart';
import '../screens/auth/login.dart';
import '../screens/auth/register.dart';
import '../screens/auth/verify_email.dart';
import '../screens/auth/forgot_password.dart';
import '../screens/home/home.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String verifyEmail = '/verify-email';
  static const String forgotPassword = '/forgot-password';
  static const String home = '/home';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      splash: (context) => const SplashScreen(),
      login: (context) => const LoginScreen(),
      register: (context) => const RegisterScreen(),
      verifyEmail: (context) => const VerifyEmailScreen(),
      forgotPassword: (context) => const ForgotPasswordScreen(),
      home: (context) => const HomeScreen(), // হোম স্ক্রিন বানালে এটি আনকমেন্ট করবেন
      //upload: (context) => const UploadPhotoScreen(), // এটি পরে বানাবো, আপাতত এরর এড়াতে এটি কমেন্ট রাখতে পারেন অথবা ফাইলের নাম ঠিক থাকলে কাজ করবে।
    };
  }
}