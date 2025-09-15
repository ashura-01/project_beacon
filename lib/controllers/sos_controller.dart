import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'auth_controller.dart';

class SosController extends GetxController {
  static SosController get instance => Get.find();

  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  /// Get current location of the user
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

  /// Send SOS to other users via Firebase
  Future<void> sendSos() async {
    try {
      // Get current user data
      final userData = await AuthController.instance.getUserData();
      if (userData == null) {
        Get.snackbar(
          'Error',
          'User data not found',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      // Get current location
      final position = await getCurrentLocation();
      if (position == null) return;

      // Prepare SOS data
      final sosData = {
        "name": userData["name"] ?? "",
        "contact": userData["contact"] ?? "",
        "emergencyContacts": userData["emergencyContacts"] ?? [],
        "latitude": position.latitude,
        "longitude": position.longitude,
        "timestamp": DateTime.now().toIso8601String(),
        "uid": AuthController.instance.currentUserId, // <-- Add UID here
      };

      // Push to Firebase under "sos_alerts"
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
}




// import 'package:firebase_database/firebase_database.dart';
// import 'package:get/get.dart';
// import 'package:geolocator/geolocator.dart';
// import 'auth_controller.dart';

// class SosController extends GetxController {
//   static SosController get instance => Get.find();

//   final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

//   /// Get current location of the user
//   Future<Position?> getCurrentLocation() async {
//     try {
//       bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//       if (!serviceEnabled) {
//         Get.snackbar(
//           'Location Disabled',
//           'Please enable location services',
//           snackPosition: SnackPosition.BOTTOM,
//         );
//         return null;
//       }

//       LocationPermission permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//         if (permission == LocationPermission.denied) return null;
//       }
//       if (permission == LocationPermission.deniedForever) return null;

//       return await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.high);
//     } catch (e) {
//       Get.snackbar('Error', 'Failed to get location: $e',
//           snackPosition: SnackPosition.BOTTOM);
//       return null;
//     }
//   }

//   /// Send SOS to other users via Firebase
//   Future<void> sendSos() async {
//     try {
//       // Get current user data
//       final userData = await AuthController.instance.getUserData();
//       if (userData == null) {
//         Get.snackbar(
//           'Error',
//           'User data not found',
//           snackPosition: SnackPosition.BOTTOM,
//         );
//         return;
//       }

//       // Get current location
//       final position = await getCurrentLocation();
//       if (position == null) return;

//       // Prepare SOS data
//       final sosData = {
//         "name": userData["name"] ?? "",
//         "contact": userData["contact"] ?? "",
//         "emergencyContacts": userData["emergencyContacts"] ?? [],
//         "latitude": position.latitude,
//         "longitude": position.longitude,
//         "timestamp": DateTime.now().toIso8601String(),
//       };

//       // Push to Firebase under "sos_alerts"
//       await _dbRef.child("sos_alerts").push().set(sosData);

//       Get.snackbar(
//         "SOS Sent",
//         "Your location has been sent to other users",
//         snackPosition: SnackPosition.BOTTOM,
//       );
//     } catch (e) {
//       Get.snackbar('Error', 'Failed to send SOS: $e',
//           snackPosition: SnackPosition.BOTTOM);
//     }
//   }
// }

