import 'package:beacon/ui/screens/main_screens/login_screen.dart';
import 'package:beacon/ui/utils/assets_path.dart';
import 'package:beacon/ui/utils/page_switch.dart';
import 'package:beacon/ui/widgets/build_text_field.dart';
import 'package:flutter/material.dart';


class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final addressController = TextEditingController();
    final contactController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

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
                  child: Image.asset(
                    AssetsPath.logo,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 20),
                const Text("SIGN UP", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                const SizedBox(height: 40),
                buildTextField(nameController, "NAME"),
                const SizedBox(height: 16),
                buildTextField(addressController, "ADDRESS"),
                const SizedBox(height: 16),
                buildTextField(contactController, "FAVOURITE CONTACTS"),
                const SizedBox(height: 16),
                buildTextField(emailController, "EMAIL"),
                const SizedBox(height: 16),
                buildTextField(passwordController, "PASSWORD", obscureText: true),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                      replaceWith(context, LoginScreen());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF0A1931),
                    padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(
                    "SIGN UP",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget _buildTextField(TextEditingController controller, String label,
  //     {bool obscureText = false}) {
  //   return TextField(
  //     controller: controller,
  //     obscureText: obscureText,
  //     decoration: InputDecoration(
  //       labelText: label,
  //       filled: true,
  //       fillColor: Colors.indigo.shade100,
  //       border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
  //     ),
  //   );
  // }
}