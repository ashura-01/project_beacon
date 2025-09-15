import 'dart:convert';
import 'package:beacon/ui/utils/map_api_key.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

import '../main_screens/map_screen.dart';

class HospitalScreen extends StatefulWidget {
  const HospitalScreen({super.key});

  @override
  State<HospitalScreen> createState() => _HospitalScreenState();
}

class _HospitalScreenState extends State<HospitalScreen> {
  final String apiKey = MapApiKey.api_1;
  List<dynamic> _hospitals = [];
  bool _loading = true;
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _fetchHospitals();
  }

  Future<void> _fetchHospitals() async {
    try {
      // Step 1: Get current location
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() => _currentPosition = position);

      // Step 2: Fetch nearby hospitals
      final url =
          "https://api.geoapify.com/v2/places?categories=healthcare.hospital"
          "&filter=circle:${position.longitude},${position.latitude},5000"
          "&bias=proximity:${position.longitude},${position.latitude}"
          "&limit=20&apiKey=$apiKey";

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final features = data["features"] as List;

        // Map hospital data
        setState(() {
          _hospitals =
              features.map((f) {
                final props = f["properties"];
                final geometry = f["geometry"]["coordinates"];
                double distance =
                    props["distance"] != null
                        ? props["distance"].toDouble()
                        : 0.0;

                return {
                  "name": props["name"] ?? "Unnamed Hospital",
                  "address": props["formatted"] ?? "No address",
                  "distance": distance,
                  "lat": geometry[1],
                  "lon": geometry[0],
                };
              }).toList();
          _loading = false;
        });
      } else {
        setState(() => _loading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error fetching hospitals: ${response.statusCode}"),
          ),
        );
      }
    } catch (e) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error fetching hospitals: $e")));
    }
  }

  String _formatDistance(double meters) {
    if (meters >= 1000) {
      return "${(meters / 1000).toStringAsFixed(2)} km";
    } else {
      return "${meters.toStringAsFixed(0)} m";
    }
  }
 
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nearby Hospitals"),
        backgroundColor: const Color.fromARGB(255, 0, 12, 53),
        foregroundColor: Colors.white,
        centerTitle: true,

      ),
      body: RefreshIndicator(
        onRefresh: _fetchHospitals, // Pull-to-refresh reloads hospitals
        child:
            _loading
                ? const Center(child: CircularProgressIndicator())
                : _hospitals.isEmpty
                ? ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: const [
                    SizedBox(height: 200),
                    Center(child: Text("No hospitals found nearby.")),
                  ],
                )
                : ListView.builder(
                  itemCount: _hospitals.length,
                  itemBuilder: (context, index) {
                    final hospital = _hospitals[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: const Icon(
                          Icons.local_hospital,
                          color: Colors.red,
                        ),
                        title: Text(
                          hospital["name"],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(hospital["address"]),
                        trailing: Text(
                          _formatDistance(hospital["distance"]),
                          style: const TextStyle(color: Colors.blueGrey),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => MapScreen(
                                    destination: LatLng(
                                      hospital["lat"],
                                      hospital["lon"],
                                    ),
                                    destinationName: hospital["name"],
                                  ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
      ),
    );
  }
}
