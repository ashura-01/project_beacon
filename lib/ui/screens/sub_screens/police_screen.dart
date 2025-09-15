import 'dart:convert';
import 'package:beacon/ui/utils/map_api_key.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

import '../main_screens/map_screen.dart';

class PoliceStationScreen extends StatefulWidget {
  const PoliceStationScreen({super.key});

  @override
  State<PoliceStationScreen> createState() => _PoliceStationScreenState();
}

class _PoliceStationScreenState extends State<PoliceStationScreen> {
  final String apiKey = MapApiKey.api_1;
  List<dynamic> _policeStations = [];
  bool _loading = true;
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _fetchPoliceStations();
  }

  Future<void> _fetchPoliceStations() async {
    try {
      // Step 1: Get current location
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() => _currentPosition = position);

      // Step 2: Fetch nearby police stations
      final url =
          "https://api.geoapify.com/v2/places?categories=service.police"
          "&filter=circle:${position.longitude},${position.latitude},50000"
          "&limit=50&apiKey=$apiKey";

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final features = data["features"] as List;

        setState(() {
          _policeStations = features.map((f) {
            final props = f["properties"];
            final geometry = f["geometry"]["coordinates"];
            double distance = props["distance"]?.toDouble() ?? 0.0;

            return {
              "name": props["name"] ?? "Unnamed Police Station",
              "address": props["formatted"] ?? "No address",
              "distance": distance,
              "lat": geometry[1],
              "lon": geometry[0],
            };
          }).toList();

          // Sort by nearest first
          _policeStations.sort((a, b) => a["distance"].compareTo(b["distance"]));

          _loading = false;
        });
      } else {
        setState(() => _loading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Error fetching police stations: ${response.statusCode}",
            ),
          ),
        );
      }
    } catch (e) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching police stations: $e")),
      );
    }
  }

  String _formatDistance(double meters) {
    if (meters >= 1000) return "${(meters / 1000).toStringAsFixed(2)} km";
    return "${meters.toStringAsFixed(0)} m";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nearby Police Stations"),
        backgroundColor: const Color.fromARGB(255, 0, 12, 53),
        centerTitle: true,
        foregroundColor: Colors.white,
      ),
      body: RefreshIndicator(
        onRefresh: _fetchPoliceStations, // Pull-to-refresh callback
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : _policeStations.isEmpty
                ? ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: const [
                      SizedBox(height: 200),
                      Center(child: Text("No police stations found nearby.")),
                    ],
                  )
                : ListView.builder(
                    itemCount: _policeStations.length,
                    itemBuilder: (context, index) {
                      final station = _policeStations[index];
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
                            Icons.local_police,
                            color: Colors.blue,
                          ),
                          title: Text(
                            station["name"],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(station["address"]),
                          trailing: Text(
                            _formatDistance(station["distance"]),
                            style: const TextStyle(color: Colors.blueGrey),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MapScreen(
                                  destination: LatLng(
                                    station["lat"],
                                    station["lon"],
                                  ),
                                  destinationName: station["name"],
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
