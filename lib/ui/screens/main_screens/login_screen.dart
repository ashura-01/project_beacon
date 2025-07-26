import 'package:beacon/ui/screens/main_screens/home_screen.dart';
import 'package:beacon/ui/screens/main_screens/signup_screen.dart';
import 'package:beacon/ui/utils/assets_path.dart';
import 'package:beacon/ui/utils/page_switch.dart';
import 'package:beacon/ui/widgets/build_text_field.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.white70,
      body: SafeArea(
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
              const Text(
                "LOG IN",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text("PLEASE LOGIN TO CONTINUE USING OUR APP"),
              const SizedBox(height: 40),
              buildTextField(emailController, "EMAIL"),
              const SizedBox(height: 20),
              buildTextField(
                passwordController,
                "PASSWORD",
                obscureText: true,
              ),
              const Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.only(top: 4),
                  child: Text("FORGOT PASSWORD"),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  navigateAndClearStack(context, HomeScreen());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF0A1931),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 100,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "LOG IN",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  navigateTo(context, SignUpScreen());
                },
                child: const Text.rich(
                  TextSpan(
                    text: "DON'T HAVE AN ACCOUNT? ",
                    children: [
                      TextSpan(
                        text: "SIGN UP",
                        style: TextStyle(color: Colors.blue),
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
    );
  }
}

//   Widget buildTextField(
//     TextEditingController controller,
//     String label, {
//     bool obscureText = false,
//   }) {
//     return TextField(
//       controller: controller,
//       obscureText: obscureText,
//       decoration: InputDecoration(
//         labelText: label,
//         filled: true,
//         fillColor: Colors.indigo.shade100,
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//       ),
//     );
//   }
// }
