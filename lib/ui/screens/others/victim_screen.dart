import 'package:beacon/ui/screens/main_screens/map_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class VictimScreen extends StatefulWidget {
  const VictimScreen({super.key});

  @override
  State<VictimScreen> createState() => _VictimScreenState();
}

class _VictimScreenState extends State<VictimScreen> {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();
  List<Map<String, dynamic>> alerts = [];

  @override
  void initState() {
    super.initState();
    _listenToSOS();
  }

  // Listen for new SOS alerts in real-time
  void _listenToSOS() {
    _dbRef.child("sos_alerts").onChildAdded.listen((event) {
      if (event.snapshot.value != null) {
        final data = Map<String, dynamic>.from(
          Map<String, dynamic>.from(event.snapshot.value as Map),
        );
        setState(() {
          alerts.insert(0, data); // newest at top
        });
      }
    });
  }

  // Manual reload when user pulls down
  Future<void> _reloadAlerts() async {
    final snapshot = await _dbRef.child("sos_alerts").get();
    if (snapshot.exists) {
      final newAlerts = <Map<String, dynamic>>[];
      (snapshot.value as Map).forEach((key, value) {
        newAlerts.add(Map<String, dynamic>.from(value));
      });

      // Sort by timestamp descending
      newAlerts.sort((a, b) {
        final aTime = DateTime.tryParse(a['timestamp'] ?? '') ?? DateTime.now();
        final bTime = DateTime.tryParse(b['timestamp'] ?? '') ?? DateTime.now();
        return bTime.compareTo(aTime);
      });

      setState(() {
        alerts = newAlerts;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Victim Alerts"),
        backgroundColor: const Color.fromARGB(255, 0, 12, 53),
        foregroundColor: Colors.white,
      ),
      body: RefreshIndicator(
        onRefresh: _reloadAlerts, // Pull-to-refresh action
        child: alerts.isEmpty
            ? ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 200),
                  Center(child: Text("No SOS alerts yet")),
                ],
              )
            : ListView.builder(
                itemCount: alerts.length,
                itemBuilder: (context, index) {
                  final alert = alerts[index];

                  final name = alert['name'] ?? "Unknown";
                  final contact = alert['contact'] ?? "Unknown";
                  final emergencyContacts = List<String>.from(
                    alert['emergencyContacts'] ?? <String>[],
                  );
                  final latitude = alert['latitude'] ?? 0.0;
                  final longitude = alert['longitude'] ?? 0.0;
                  final timestamp = alert['timestamp'] ?? "";

                  return Card(
                    margin: const EdgeInsets.all(8),
                    child: ListTile(
                      title: Text("$name ($contact)"),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Emergency Contacts: ${emergencyContacts.join(', ')}",
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.location_on, color: Colors.red),
                              const SizedBox(width: 4),
                              const Text("View Location"),
                              const Spacer(),
                              IconButton(
                                icon: const Icon(Icons.map, color: Colors.blue),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => MapScreen(
                                        destination: LatLng(latitude, longitude),
                                        destinationName: name,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      trailing: Text(
                        timestamp.isNotEmpty
                            ? DateTime.parse(timestamp)
                                .toLocal()
                                .toString()
                                .substring(0, 19)
                            : "",
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
