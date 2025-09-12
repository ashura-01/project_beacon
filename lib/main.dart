import 'package:beacon/controllers/auth_controller.dart';
import 'package:beacon/controllers/sos_controller.dart';
import 'package:beacon/firebase_options.dart';
import 'package:beacon/my_app.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

 
  Get.put(AuthController());
  Get.put(SosController());

  
  final currentUser = FirebaseAuth.instance.currentUser;

  runApp(MyApp(isLoggedIn: currentUser != null));
}