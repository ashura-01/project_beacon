import 'package:beacon/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/assets_path.dart';
import '../../utils/page_switch.dart';
import '../../widgets/build_text_field.dart';
import 'signup_screen.dart';
import 'home_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final AuthController authController = Get.find();

    return Scaffold(
      backgroundColor: Colors.white70,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 30),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(AssetsPath.logo, height: 200, fit: BoxFit.cover),
              ),
              const SizedBox(height: 20),
              buildTextField(emailController, "EMAIL"),
              const SizedBox(height: 20),
              buildTextField(passwordController, "PASSWORD", obscureText: true),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () async {
                  await authController.login(
                    emailController.text.trim(),
                    passwordController.text.trim(),
                  );
                  navigateAndClearStack(context, const HomeScreen());
                },
                child: const Text("LOG IN"),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () => navigateTo(context, const SignUpScreen()),
                child: const Text("Don't have an account? SIGN UP"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

