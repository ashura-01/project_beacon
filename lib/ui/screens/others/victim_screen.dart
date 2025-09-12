import 'package:beacon/ui/screens/main_screens/map_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  // Copy a number to clipboard and show Snackbar
  void _copyNumber(String number) {
    Clipboard.setData(ClipboardData(text: number));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Copied: $number"),
        duration: const Duration(seconds: 2),
      ),
    );
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
        onRefresh: _reloadAlerts,
        child:
            alerts.isEmpty
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
                        title: Row(
                          children: [
                            Expanded(child: Text("$name ($contact)",style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),)),
                            IconButton(
                              icon: const Icon(Icons.copy, size: 20),
                              onPressed: () => _copyNumber(contact),
                              tooltip: "Copy contact number",
                            ),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            if (emergencyContacts.isNotEmpty)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 4),
                                  if (emergencyContacts.isNotEmpty)
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text("Contacts of relative or friends:"),
                                        const SizedBox(height: 4),
                                        Wrap(
                                          spacing: 12,
                                          runSpacing: 4,
                                          children:
                                              emergencyContacts.map((num) {
                                                return ElevatedButton.icon(
                                                  onPressed:
                                                      () => _copyNumber(num),
                                                  icon: const Icon(
                                                    Icons.copy,
                                                    size: 16,
                                                    color: Color.fromARGB(255, 0, 0, 0),
                                                  ),
                                                  label: Text(num),
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        const Color.fromARGB(255, 146, 221, 202),
                                                    foregroundColor:
                                                        const Color.fromARGB(255, 0, 0, 0),
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 8,
                                                          vertical: 4,
                                                        ),
                                                    minimumSize: const Size(
                                                      0,
                                                      0,
                                                    ),
                                                    tapTargetSize:
                                                        MaterialTapTargetSize
                                                            .shrinkWrap,
                                                  ),
                                                );
                                              }).toList(),
                                        ),
                                      ],
                                    ),
                                ],
                              ),

                            const SizedBox(height: 4),
                            Row(
                              children: [
                                
                                const SizedBox(width: 4),
                                const Text("View Location"),
                                // const Spacer(),
                                IconButton(
                                  icon: const Icon(
                                    Icons.location_on,
                                    color: Color.fromARGB(255, 24, 0, 112),
                                    size: 28,
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (_) => MapScreen(
                                              destination: LatLng(
                                                latitude,
                                                longitude,
                                              ),
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
                              ? DateTime.parse(
                                timestamp,
                              ).toLocal().toString().substring(0, 19)
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
