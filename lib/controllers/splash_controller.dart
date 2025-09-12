import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../ui/screens/main_screens/welcome_screen.dart';

class SplashController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    _startDelay();
  }

  void _startDelay() {
    Timer(const Duration(seconds: 3), () {
      Navigator.of(Get.context!).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 1000), // slow Hero
          pageBuilder: (context, animation, secondaryAnimation) =>
          const WelcomeScreen(),
        ),
      );
    });
  }
}