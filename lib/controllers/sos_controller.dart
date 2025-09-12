import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'auth_controller.dart';

class SosController extends GetxController {
  static SosController get instance => Get.find();

  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  /// Get current location
  Future<Position?> getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        Get.snackbar(
          'Location Disabled',
          'Please enable location services',
          snackPosition: SnackPosition.BOTTOM,
        );
        return null;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return null;
      }
      if (permission == LocationPermission.deniedForever) return null;

      return await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
    } catch (e) {
      Get.snackbar('Error', 'Failed to get location: $e',
          snackPosition: SnackPosition.BOTTOM);
      return null;
    }
  }

  /// Send SOS to other users in Firebase
  Future<void> sendSos() async {
    try {
      final userData = await AuthController.instance.getUserData();
      if (userData == null) return;

      final position = await getCurrentLocation();
      if (position == null) return;

      final sosData = {
        "name": userData["name"] ?? "",
        "contact": userData["contact"] ?? "",
        "emergencyContacts": userData["emergencyContacts"] ?? [],
        "latitude": position.latitude,
        "longitude": position.longitude,
        "timestamp": DateTime.now().toIso8601String(),
      };

      // Push to a common "sos_alerts" node in Firebase
      await _dbRef.child("sos_alerts").push().set(sosData);

      Get.snackbar(
        "SOS Sent",
        "Your location has been sent to other users",
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to send SOS: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> sendSosAlert() async {}
}
