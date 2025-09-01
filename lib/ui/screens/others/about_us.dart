import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About Us"),
        backgroundColor: const Color.fromARGB(255, 0, 12, 53),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              TeamCard(
                name: "MD. Fahim Moontashir",
                id: "20230204045",
              ),
              SizedBox(height: 20),
              TeamCard(
                name: "Farzan Rahman",
                id: "20230204046",
              ),
              SizedBox(height: 20),
              TeamCard(
                name: "Fahmida Afrin Nadia",
                id: "20230204047",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TeamCard extends StatelessWidget {
  final String name;
  final String id;

  const TeamCard({super.key, required this.name, required this.id});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: Colors.white,
      child: Container(
        width: 300,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Column(
          children: [
            Text(
              name,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              "ID: $id",
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
