import 'package:flutter/material.dart';
import '../screens/splash_screen.dart';
import '../screens/auth/login.dart';
import '../screens/auth/register.dart';
import '../screens/auth/forgot_password.dart';
import '../screens/home/home.dart';
import '../screens/upload/upload_photo.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String home = '/home';
  static const String upload = '/upload';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      splash: (context) => const SplashScreen(),
      login: (context) => const LoginScreen(),
      register: (context) => const RegisterScreen(),
      forgotPassword: (context) => const ForgotPasswordScreen(),
      home: (context) => const HomeScreen(),
      upload: (context) => const UploadPhotoScreen(),
    };
  }
}