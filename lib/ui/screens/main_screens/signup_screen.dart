import 'package:beacon/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/assets_path.dart';
import '../../utils/page_switch.dart';
import '../../widgets/build_text_field.dart';
import 'login_screen.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final addressController = TextEditingController();
    final contactController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    final AuthController authController = Get.find();

    return Scaffold(
      backgroundColor: Colors.white70,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(AssetsPath.logo, height: 200, fit: BoxFit.cover),
                ),
                const SizedBox(height: 20),
                buildTextField(nameController, "NAME"),
                const SizedBox(height: 16),
                buildTextField(addressController, "ADDRESS"),
                const SizedBox(height: 16),
                buildTextField(contactController, "CONTACT"),
                const SizedBox(height: 16),
                buildTextField(emailController, "EMAIL"),
                const SizedBox(height: 16),
                buildTextField(passwordController, "PASSWORD", obscureText: true),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () async {
                    await authController.register(
                      emailController.text.trim(),
                      passwordController.text.trim(),
                      additionalData: {
                        "name": nameController.text.trim(),
                        "address": addressController.text.trim(),
                        "contact": contactController.text.trim(),
                      },
                    );
                    navigateAndClearStack(context, const LoginScreen());
                  },
                  child: const Text("SIGN UP"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
