import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'signup_screen.dart';
import '../../utils/assets_path.dart';
import '../../utils/page_switch.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    AssetsPath.logo,
                    width: 300,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  'WELCOME TO',
                  style: TextStyle(fontSize: 20, letterSpacing: 1.5),
                ),
                const SizedBox(height: 4),
                const Text(
                  'BEACON',
                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, letterSpacing: 2),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF0A1931),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: () => navigateTo(context, LoginScreen()),
                    child: const Text('GET STARTED', style: TextStyle(fontSize: 16, color: Colors.white)),
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () => navigateTo(context, SignUpScreen()),
                  child: const Text.rich(
                    TextSpan(
                      text: "DON'T HAVE AN ACCOUNT? ",
                      children: [
                        TextSpan(
                          text: 'SIGN UP',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Color.fromARGB(255, 12, 0, 119)),
                        ),
                      ],
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
}
