import 'dart:convert';
import 'package:beacon/ui/utils/map_api_key.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

import '../main_screens/map_screen.dart';

class FireServiceScreen extends StatefulWidget {
  const FireServiceScreen({super.key});

  @override
  State<FireServiceScreen> createState() => _FireServiceScreenState();
}

class _FireServiceScreenState extends State<FireServiceScreen> {
  final String apiKey = MapApiKey.api_1;
  List<dynamic> _fireStations = [];
  bool _loading = true;
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _fetchFireStations();
  }

  Future<void> _fetchFireStations() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() => _currentPosition = position);

      final url =
          "https://api.geoapify.com/v2/places?categories=service.fire_station	"
          "&filter=circle:${position.longitude},${position.latitude},50000"
          "&limit=50&apiKey=$apiKey";

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final features = data["features"] as List;

        setState(() {
          _fireStations =
              features.map((f) {
                final props = f["properties"];
                final geometry = f["geometry"]["coordinates"];
                double distance = props["distance"]?.toDouble() ?? 0.0;

                return {
                  "name": props["name"] ?? "Unnamed Fire Station",
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
            content: Text(
              "Error fetching fire stations: ${response.statusCode}",
            ),
          ),
        );
      }
    } catch (e) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching fire stations: $e")),
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
        title: const Text("Nearby Fire Stations"),
        backgroundColor: const Color.fromARGB(255, 0, 12, 53),
        foregroundColor: Colors.white,
        centerTitle: true,

      ),
      body: RefreshIndicator(
        onRefresh: _fetchFireStations, // Pull-to-refresh callback
        child:
            _loading
                ? const Center(child: CircularProgressIndicator())
                : _fireStations.isEmpty
                ? ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: const [
                    SizedBox(height: 200),
                    Center(child: Text("No fire stations found nearby.")),
                  ],
                )
                : ListView.builder(
                  itemCount: _fireStations.length,
                  itemBuilder: (context, index) {
                    final station = _fireStations[index];
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
                          Icons.local_fire_department,
                          color: Colors.red,
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
                              builder:
                                  (context) => MapScreen(
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
