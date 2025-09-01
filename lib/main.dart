import 'package:beacon/controllers/auth_controller.dart';
import 'package:beacon/firebase_options.dart';
import 'package:beacon/my_app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Get.put(AuthController()); // <-- Important
  runApp(const MyApp());
}