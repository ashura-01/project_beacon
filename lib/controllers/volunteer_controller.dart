import 'dart:async'; // for StreamSubscription
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

class VolunteerController extends GetxController {
  static VolunteerController get instance => Get.find();

  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  RxList<Map<String, dynamic>> volunteers = <Map<String, dynamic>>[].obs;
  RxBool isLoading = false.obs;

  StreamSubscription<DatabaseEvent>? _subscription;

  @override
  void onInit() {
    super.onInit();
    fetchVolunteers(); 
  }

  void fetchVolunteers() {
    isLoading.value = true;

    _subscription?.cancel();

    _subscription = _dbRef.child("blood_bank").onValue.listen((event) {
      volunteers.clear();

      if (event.snapshot.exists && event.snapshot.value != null) {
        final data = Map<String, dynamic>.from(event.snapshot.value as Map);

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

      isLoading.value = false;
    }, onError: (error) {
      isLoading.value = false;
      Get.snackbar("Error", error.toString());
    });
  }

  @override
  void onClose() {
    _subscription?.cancel(); // properly close the listener
    super.onClose();
  }
}
