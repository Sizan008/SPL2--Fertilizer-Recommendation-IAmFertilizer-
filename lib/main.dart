
import 'package:flutter/material.dart';
import 'config/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'IAmFertilizer',

      // অ্যাপের মেইন থিম (সবুজ ও আধুনিক লুক)
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xff11998e),
          primary: const Color(0xff11998e),
          secondary: const Color(0xff38ef7d),
        ),
        // ইনপুট ফিল্ডের গ্লোবাল ডিজাইন
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
        ),
      ),

      // প্রথম কোন স্ক্রিনটি দেখাবে (Splash Screen)
      initialRoute: AppRoutes.splash,

      // সব রুট (পেইজ) এর লিস্ট
      routes: AppRoutes.getRoutes(),
    );
  }
}