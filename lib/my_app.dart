import 'package:beacon/ui/screens/main_screens/home_screen.dart';
import 'package:beacon/ui/screens/main_screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // <-- import GetX

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: isLoggedIn ? const HomeScreen() : const WelcomeScreen(),
    );
  }
}
