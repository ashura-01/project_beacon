import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_database/firebase_database.dart';

class BloodBankController extends GetxController {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref("blood_bank");

  final nameController = TextEditingController();
  final bloodGroupController = TextEditingController();
  final phoneController = TextEditingController();
  final locationController = TextEditingController();

  Future<void> submitForm() async {
    try {
      String id = DateTime.now().millisecondsSinceEpoch.toString();

      await _dbRef.child(id).set({
        "name": nameController.text,
        "bloodGroup": bloodGroupController.text,
        "phone": phoneController.text,
        "location": locationController.text,
        "createdAt": DateTime.now().toIso8601String(),
      });

      Get.snackbar("Success", "Blood donor info saved successfully!",
          snackPosition: SnackPosition.BOTTOM);

      clearForm();
    } catch (e) {
      Get.snackbar("Error", e.toString(),
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red);
    }
  }

  void clearForm() {
    nameController.clear();
    bloodGroupController.clear();
    phoneController.clear();
    locationController.clear();
  }
}

