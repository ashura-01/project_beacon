import 'dart:convert';
import 'package:beacon/controllers/volunteer_controller.dart';
import 'package:beacon/ui/utils/map_api_key.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

import '../main_screens/map_screen.dart';

class VolunteerScreen extends StatelessWidget {
  const VolunteerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final VolunteerController controller = Get.put(VolunteerController());

    Future<void> _openLocationOnMap(String locationName, String name) async {
      if (locationName.isEmpty) return;

      try {
        final apiKey = MapApiKey.api_1;
        final url =
            "https://api.geoapify.com/v1/geocode/search?text=${Uri.encodeComponent(locationName)}&apiKey=$apiKey";

        final response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          if (data['features'] != null && data['features'].isNotEmpty) {
            final coords = data['features'][0]['geometry']['coordinates'];
            final lon = coords[0];
            final lat = coords[1];

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => MapScreen(
                  destination: LatLng(lat, lon),
                  destinationName: name,
                ),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Location not found on map")),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error fetching location: ${response.statusCode}")),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error fetching location: $e")),
        );
      }
    }

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
          return RefreshIndicator(
            onRefresh: () async {
              controller.fetchVolunteers(); // reload manually
              await Future.delayed(const Duration(seconds: 1));
            },
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: const [
                SizedBox(height: 200),
                Center(child: Text("No blood banks found")),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            controller.fetchVolunteers(); // reload manually
            await Future.delayed(const Duration(seconds: 1));
          },
          child: ListView.builder(
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
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Blood Group: ${volunteer['bloodGroup'] ?? '-'}",
                        style: const TextStyle(fontSize: 14),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Location: ${volunteer['location'] ?? '-'}",
                            style: const TextStyle(fontSize: 14),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.location_on,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              final location = volunteer['location'] ?? '';
                              final name = volunteer['name'] ?? 'Blood Bank';
                              _openLocationOnMap(location, name);
                            },
                          ),
                        ],
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(0, 0),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        onPressed: () {
                          final phone = volunteer['phone'] ?? '';
                          if (phone.isNotEmpty) {
                            Clipboard.setData(ClipboardData(text: phone));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Phone number copied'),
                              ),
                            );
                          }
                        },
                        child: Text(
                          "Number: ${volunteer['phone'] ?? '-'}",
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
