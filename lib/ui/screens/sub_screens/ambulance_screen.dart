import 'dart:convert';
import 'package:beacon/ui/utils/map_api_key.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

import '../main_screens/map_screen.dart';

class AmbulanceScreen extends StatefulWidget {
  const AmbulanceScreen({super.key});

  @override
  State<AmbulanceScreen> createState() => _AmbulanceScreenState();
}

class _AmbulanceScreenState extends State<AmbulanceScreen> {
  final String apiKey = MapApiKey.api_1;
  List<dynamic> _ambulances = [];
  bool _loading = true;
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _fetchAmbulances();
  }

  Future<void> _fetchAmbulances() async {
    try {
      // 🔹 Step 1: Get current location
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() => _currentPosition = position);

      // 🔹 Step 2: Fetch nearby ambulance stations from Geoapify
      final url =
          "https://api.geoapify.com/v2/places?categories=service.ambulance_station"
          "&filter=circle:${position.longitude},${position.latitude},50000"
          "&limit=50&apiKey=$apiKey";

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final features = data["features"] as List;

        // 🔹 Step 3: Map ambulance data
        setState(() {
          _ambulances =
              features.map((f) {
                final props = f["properties"];
                final geometry = f["geometry"]["coordinates"]; // [lon, lat]
                double distance =
                    props["distance"] != null
                        ? props["distance"].toDouble()
                        : 0.0;

                return {
                  "name": props["name"] ?? "Unnamed Ambulance Station",
                  "address": props["formatted"] ?? "No address",
                  "distance": distance, // meters
                  "lat": geometry[1], // latitude
                  "lon": geometry[0], // longitude
                };
              }).toList();
          _loading = false;
        });
      } else {
        setState(() => _loading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error fetching ambulances: ${response.statusCode}"),
          ),
        );
      }
    } catch (e) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error fetching ambulances: $e")));
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
        title: const Text("Nearby Ambulance Stations"),
        backgroundColor: const Color.fromARGB(255, 0, 12, 53),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: _fetchAmbulances, // Pull-to-refresh reload
        child:
            _loading
                ? const Center(child: CircularProgressIndicator())
                : _ambulances.isEmpty
                ? ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: const [
                    SizedBox(height: 200),
                    Center(child: Text("No ambulance stations found nearby.")),
                  ],
                )
                : ListView.builder(
                  itemCount: _ambulances.length,
                  itemBuilder: (context, index) {
                    final ambulance = _ambulances[index];
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
                          color: Colors.orange,
                        ),
                        title: Text(
                          ambulance["name"],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(ambulance["address"]),
                        trailing: Text(
                          _formatDistance(ambulance["distance"]),
                          style: const TextStyle(color: Colors.blueGrey),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => MapScreen(
                                    destination: LatLng(
                                      ambulance["lat"],
                                      ambulance["lon"],
                                    ),
                                    destinationName: ambulance["name"],
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
