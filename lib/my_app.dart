import 'package:beacon/ui/screens/main_screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // <-- import GetX

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: const WelcomeScreen(),
    );
  }
}
