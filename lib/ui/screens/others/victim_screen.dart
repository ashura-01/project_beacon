import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

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

  void _listenToSOS() {
    _dbRef.child("sos_alerts").onChildAdded.listen((event) {
      final data = Map<String, dynamic>.from(event.snapshot.value as Map);
      setState(() {
        alerts.insert(0, data); // show newest at top
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Victim Alerts")),
      body: alerts.isEmpty
          ? const Center(child: Text("No SOS alerts yet"))
          : ListView.builder(
              itemCount: alerts.length,
              itemBuilder: (context, index) {
                final alert = alerts[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text("${alert['name']} (${alert['contact']})"),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            "Emergency Contacts: ${List<String>.from(alert['emergencyContacts']).join(', ')}"),
                        Text(
                            "Location: https://www.google.com/maps/search/?api=1&query=${alert['latitude']},${alert['longitude']}"),
                      ],
                    ),
                    trailing: Text(
                      DateTime.parse(alert['timestamp'])
                          .toLocal()
                          .toString()
                          .substring(0, 19),
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
