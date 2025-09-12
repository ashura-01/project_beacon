import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  static AuthController get instance => Get.find<AuthController>();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  // Reactive user
  Rx<User?> firebaseUser = Rx<User?>(null);

  @override
  void onReady() {
    super.onReady();
    firebaseUser.bindStream(_auth.authStateChanges());

    ever(firebaseUser, (User? user) {
      if (user == null) {
        // User not logged in
      } else {
        // User logged in
      }
    });
  }

  /// REGISTER / SIGN UP
  Future<void> register(
    String email,
    String password, {
    required Map<String, dynamic> additionalData,
  }) async {
    try {
      // Validate personal contact
      final personalContact = additionalData["contact"]?.trim();
      if (personalContact == null || personalContact.isEmpty) {
        Get.snackbar(
          "Error",
          "Please provide your personal contact",
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      // Validate emergency contacts
      final List<String> emergencyContacts = List<String>.from(
        additionalData["emergencyContacts"] ?? [],
      );
      if (emergencyContacts.length != 3 ||
          emergencyContacts.any((c) => c.trim().isEmpty)) {
        Get.snackbar(
          "Error",
          "Please provide 3 valid emergency contacts",
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      // Create user in Firebase Auth
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      final uid = userCredential.user!.uid;

      // Prepare user data
      Map<String, dynamic> userData = {
        "uid": uid,
        "email": email,
        "createdAt": DateTime.now().toIso8601String(),
        "contact": personalContact,
        "emergencyContacts": emergencyContacts,
        ...additionalData
          ..remove("contact")
          ..remove("emergencyContacts"),
      };

      // Save to Realtime Database
      await _dbRef.child("users").child(uid).set(userData);

      Get.snackbar(
        "Success",
        "Account created successfully",
        snackPosition: SnackPosition.BOTTOM,
      );
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        "Auth Error",
        e.message ?? "Something went wrong",
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar("Error", e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
  }

  /// LOGIN
  Future<bool> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      Get.snackbar(
        "✅ Success",
        "Logged in successfully",
        snackPosition: SnackPosition.BOTTOM,
      );
      return true; // success
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        "Auth Error",
        e.message ?? "Invalid credentials",
        snackPosition: SnackPosition.BOTTOM,
      );
      return false; // failed
    } catch (e) {
      Get.snackbar("Error", e.toString(), snackPosition: SnackPosition.BOTTOM);
      return false; // failed
    }
  }

  /// LOGOUT
  Future<void> logout() async {
    try {
      await _auth.signOut();
      Get.snackbar(
        "Success",
        "Logged out successfully",
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar("Error", e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
  }

  /// FETCH USER DATA
  Future<Map<String, dynamic>?> getUserData() async {
    try {
      final user = firebaseUser.value;
      if (user != null) {
        final snapshot = await _dbRef.child("users").child(user.uid).get();
        if (snapshot.exists && snapshot.value != null) {
          return Map<String, dynamic>.from(snapshot.value as Map);
        }
      }
      return null;
    } catch (e) {
      Get.snackbar("Error", e.toString(), snackPosition: SnackPosition.BOTTOM);
      return null;
    }
  }

  /// UPDATE NAME
  Future<void> updateName(String uid, String newName) async {
    try {
      await _dbRef.child("users").child(uid).update({"name": newName});
      Get.snackbar(
        "Success",
        "Name updated successfully",
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar("Error", e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
  }

  /// UPDATE PERSONAL CONTACT
  Future<void> updatePersonalContact(String uid, String contact) async {
    if (contact.trim().isEmpty) {
      Get.snackbar(
        "Error",
        "Contact cannot be empty",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    try {
      await _dbRef.child("users").child(uid).update({"contact": contact});
      Get.snackbar(
        "Success",
        "Personal contact updated successfully",
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar("Error", e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
  }

  /// UPDATE EMERGENCY CONTACTS
  Future<void> updateEmergencyContacts(
    String uid,
    List<String> contacts,
  ) async {
    if (contacts.length != 3 || contacts.any((c) => c.trim().isEmpty)) {
      Get.snackbar(
        "Error",
        "Please provide 3 valid emergency contacts",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    try {
      await _dbRef.child("users").child(uid).update({
        "emergencyContacts": contacts,
      });
      Get.snackbar(
        "Success",
        "Emergency contacts updated successfully",
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar("Error", e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
  }
}
