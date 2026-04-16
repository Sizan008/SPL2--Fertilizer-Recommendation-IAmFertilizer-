import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // সিস্টেম বার কন্ট্রোলের জন্য
import 'config/app_routes.dart';

void main() async {
  // Flutter বাইন্ডিং নিশ্চিত করা
  WidgetsFlutterBinding.ensureInitialized();

  // অ্যাপের ওরিয়েন্টেশন পোর্ট্রেটে লক করে দেওয়া (ভালো ইউজার এক্সপেরিয়েন্সের জন্য)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'IAmFertilizer',

      // থিম কনফিগারেশন
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto', // আপনি চাইলে গুগল ফন্টস ব্যবহার করতে পারেন
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xff11998e),
          primary: const Color(0xff11998e),
          secondary: const Color(0xff38ef7d),
        ),
        // গ্লোবাল ইনপুট ডেকোরেশন
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey[100],
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Color(0xff11998e), width: 2),
          ),
        ),
      ),

      // রাউটিং কনফিগারেশন
      initialRoute: AppRoutes.splash,
      routes: AppRoutes.getRoutes(),
    );
  }
}