import 'package:beacon/controllers/volunteer_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VolunteerScreen extends StatelessWidget {
  const VolunteerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final VolunteerController controller = Get.put(VolunteerController());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Blood Bank Details"),
        backgroundColor: const Color.fromARGB(255, 0, 12, 53),
        foregroundColor: Colors.white,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.volunteers.isEmpty) {
          return const Center(child: Text("No blood banks found"));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(10),
          itemCount: controller.volunteers.length,
          itemBuilder: (context, index) {
            final volunteer = controller.volunteers[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      volunteer['name'] ?? "Unknown",
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Blood Group: ${volunteer['bloodGroup'] ?? '-'}",
                      style: const TextStyle(fontSize: 14),
                    ),
                    Text(
                      "Location: ${volunteer['location'] ?? '-'}",
                      style: const TextStyle(fontSize: 14),
                    ),
                    Text(
                      "Number: ${volunteer['phone'] ?? '-'}",
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
