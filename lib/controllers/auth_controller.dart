import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  static AuthController get instance => Get.find<AuthController>();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  // reactive user
  Rx<User?> firebaseUser = Rx<User?>(null);

  @override
  void onReady() {
    super.onReady();
    firebaseUser.bindStream(_auth.authStateChanges());

    ever(firebaseUser, (User? user) {
      if (user == null) {
        // Not logged in
      } else {
        // Logged in
      }
    });
  }

  // REGISTER / SIGN UP
  Future<void> register(String email, String password,
      {Map<String, dynamic>? additionalData}) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = userCredential.user!.uid;

      Map<String, dynamic> userData = {
        "uid": uid,
        "email": email,
        "createdAt": DateTime.now().toIso8601String(),
        ...?additionalData,
      };

      await _dbRef.child("users").child(uid).set(userData);

      Get.snackbar("Success", "Account created successfully");
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Auth Error", e.message ?? "Something went wrong");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  // LOGIN
  Future<void> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      Get.snackbar("✅ Success", "Logged in successfully");
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Auth Error", e.message ?? "Invalid credentials");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  // LOGOUT
  Future<void> logout() async {
    try {
      await _auth.signOut();
      Get.snackbar("Success", "Logged out successfully");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  // FETCH USER DATA
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
      Get.snackbar("Error", e.toString());
      return null;
    }
  }

  // UPDATE NAME (move this inside the class)
  Future<void> updateName(String uid, String newName) async {
    try {
      await _dbRef.child("users").child(uid).update({"name": newName});
      Get.snackbar("Success", "Name updated successfully");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }
}
