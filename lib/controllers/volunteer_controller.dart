import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

class VolunteerController extends GetxController {
  static VolunteerController get instance => Get.find();

  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  RxList<Map<String, dynamic>> volunteers = <Map<String, dynamic>>[].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchVolunteers();
  }

  void fetchVolunteers() async {
    isLoading.value = true;

    try {
      final snapshot = await _dbRef.child("blood_bank").get();

      volunteers.clear();

      if (snapshot.exists && snapshot.value != null) {
        final data = Map<String, dynamic>.from(snapshot.value as Map);

        data.forEach((key, value) {
          if (value != null && value is Map) {
            Map<String, dynamic> bloodBank = {
              "id": key, // Firebase key
              ...Map<String, dynamic>.from(value),
            };
            volunteers.add(bloodBank);
          }
        });
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
