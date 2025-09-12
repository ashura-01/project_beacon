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
        child: SingleChildScrollView(
          // prevents overflow when keyboard appears
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    AssetsPath.logo,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 20),
                buildTextField(emailController, "EMAIL"),
                const SizedBox(height: 20),
                buildTextField(
                  passwordController,
                  "PASSWORD",
                  obscureText: true,
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 0, 12, 53),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 6),
                    ),
                    
                    onPressed: () async {
                      bool success = await authController.login(
                        emailController.text.trim(),
                        passwordController.text.trim(),
                      );
                      if (success) {
                        navigateAndClearStack(context, const HomeScreen());
                      }
                    },

                    child: const Text("LOG IN"),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: GestureDetector(
                    onTap: () => navigateTo(context, const SignUpScreen()),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have an account? "),
                        Text(
                          "SIGN UP",
                          style: TextStyle(
                            color: const Color.fromARGB(255, 0, 12, 53),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
