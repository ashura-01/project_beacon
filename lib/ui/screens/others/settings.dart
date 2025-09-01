import 'package:beacon/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find();

    final nameController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: const Color.fromARGB(255, 0, 12, 53),
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: FutureBuilder<Map<String, dynamic>?>(
          future: authController.getUserData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (!snapshot.hasData || snapshot.data == null) {
              return const Center(child: Text("No user data found"));
            }

            final userData = snapshot.data!;
            nameController.text = userData["name"] ?? "";

            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: "Name",
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: passwordController,
                    decoration: const InputDecoration(
                      labelText: "New Password",
                      prefixIcon: Icon(Icons.lock),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () async {
                      // Update name in Firebase Realtime Database
                      if (nameController.text.trim().isNotEmpty) {
                        final user = authController.firebaseUser.value;
                        if (user != null) {
                          await authController
                              .updateName(user.uid, nameController.text.trim());
                        }
                      }

                      // Update password in Firebase Auth
                      if (passwordController.text.trim().isNotEmpty) {
                        final user = authController.firebaseUser.value;
                        if (user != null) {
                          try {
                            await user.updatePassword(passwordController.text.trim());
                            Get.snackbar("✅ Success", "Password updated successfully");
                          } catch (e) {
                            Get.snackbar("Error", e.toString());
                          }
                        }
                      }

                      Get.snackbar("✅ Success", "Profile updated successfully");
                      passwordController.clear();
                    },
                    child: const Text("Save Changes"),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
