import 'package:beacon/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find();

    final nameController = TextEditingController();
    final contactController = TextEditingController();
    final locationController = TextEditingController();
    final emergency1Controller = TextEditingController();
    final emergency2Controller = TextEditingController();
    final emergency3Controller = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

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
            contactController.text = userData["contact"] ?? "";
            locationController.text = userData["location"] ?? "";

            if (userData["emergencyContacts"] != null &&
                userData["emergencyContacts"] is List) {
              final contacts = List<String>.from(userData["emergencyContacts"]);
              if (contacts.isNotEmpty) emergency1Controller.text = contacts[0];
              if (contacts.length > 1) emergency2Controller.text = contacts[1];
              if (contacts.length > 2) emergency3Controller.text = contacts[2];
            }

            return SingleChildScrollView(
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
                  const SizedBox(height: 15),
                  TextField(
                    controller: contactController,
                    decoration: const InputDecoration(
                      labelText: "Personal Contact",
                      prefixIcon: Icon(Icons.phone),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: locationController,
                    decoration: const InputDecoration(
                      labelText: "Location",
                      prefixIcon: Icon(Icons.location_on),
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "Emergency Contacts (3 required)",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: emergency1Controller,
                    decoration: const InputDecoration(
                      labelText: "Emergency Contact 1",
                      prefixIcon: Icon(Icons.phone_in_talk),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: emergency2Controller,
                    decoration: const InputDecoration(
                      labelText: "Emergency Contact 2",
                      prefixIcon: Icon(Icons.phone_in_talk),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: emergency3Controller,
                    decoration: const InputDecoration(
                      labelText: "Emergency Contact 3",
                      prefixIcon: Icon(Icons.phone_in_talk),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 25),
                  TextField(
                    controller: newPasswordController,
                    decoration: const InputDecoration(
                      labelText: "New Password",
                      prefixIcon: Icon(Icons.lock),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: confirmPasswordController,
                    decoration: const InputDecoration(
                      labelText: "Confirm Password",
                      prefixIcon: Icon(Icons.lock_outline),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () async {
                      final user = authController.firebaseUser.value;
                      if (user == null) return;

                      try {
                        if (nameController.text.trim().isNotEmpty) {
                          await authController.updateName(
                            user.uid,
                            nameController.text.trim(),
                          );
                        }

                        if (contactController.text.trim().isNotEmpty) {
                          await authController.updatePersonalContact(
                            user.uid,
                            contactController.text.trim(),
                          );
                        }

                        if (locationController.text.trim().isNotEmpty) {
                          await authController.updateLocation(
                            user.uid,
                            locationController.text.trim(),
                          );
                        }

                        final emergencyContacts = [
                          emergency1Controller.text.trim(),
                          emergency2Controller.text.trim(),
                          emergency3Controller.text.trim(),
                        ];
                        await authController.updateEmergencyContacts(
                          user.uid,
                          emergencyContacts,
                        );

                        if (newPasswordController.text.trim().isNotEmpty &&
                            confirmPasswordController.text.trim().isNotEmpty) {
                          if (newPasswordController.text.trim() ==
                              confirmPasswordController.text.trim()) {
                            await user.updatePassword(
                              newPasswordController.text.trim(),
                            );
                          } else {
                            Get.snackbar(
                              "Error",
                              "Passwords do not match",
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                            );
                            return;
                          }
                        }

                        newPasswordController.clear();
                        confirmPasswordController.clear();

                        Get.snackbar(
                          "✅ Success",
                          "Profile updated successfully",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: const Color.fromARGB(
                            255,
                            31,
                            31,
                            31,
                          ),
                          colorText: const Color.fromARGB(255, 0, 238, 255),
                        );
                      } catch (e) {
                        Get.snackbar(
                          "Error",
                          e.toString(),
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 15,
                      ),
                    ),
                    child: const Text("Save Changes"),
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
