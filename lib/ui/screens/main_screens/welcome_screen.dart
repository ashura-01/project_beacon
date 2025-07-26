import 'package:beacon/ui/screens/main_screens/login_screen.dart';
import 'package:beacon/ui/screens/main_screens/signup_screen.dart';
import 'package:beacon/ui/utils/assets_path.dart';
import 'package:beacon/ui/utils/page_switch.dart';
import 'package:flutter/material.dart';

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
                Text(
                  'WELCOME TO',
                  style: TextStyle(
                    color: const Color.fromARGB(255, 0, 12, 53),
                    fontSize: 20,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'BEACON',
                  style: TextStyle(
                    color: const Color.fromARGB(255, 0, 12, 53),
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'YOUR SAFETY OUR DESIRE',
                  style: TextStyle(
                    color: const Color.fromARGB(255, 0, 12, 53),
                    fontSize: 12,
                    letterSpacing: 1.2,
                  ),
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
                    onPressed: () {
                      navigateTo(context, LoginScreen());
                    },
                    child: const Text(
                      'GET STARTED',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.2,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    navigateTo(context, SignUpScreen());
                  },
                  child: RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        color: Color.fromARGB(255, 0, 12, 53),
                        fontSize: 13,
                      ),
                      children: [
                        TextSpan(text: "DON'T HAVE AN ACCOUNT? "),
                        TextSpan(
                          text: 'SIGN UP',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 0, 12, 53),
                          ),
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
