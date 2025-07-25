import 'package:beacon/ui/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';

class HospitalScreen extends StatefulWidget {
  const HospitalScreen({super.key});

  @override
  State<HospitalScreen> createState() => _HospitalScreenState();
}

class _HospitalScreenState extends State<HospitalScreen> {
  final List<String> _nameList = [
    "Apollo Hospital",
    "Square Hospital",
    "United Hospital",
    "Evercare Hospital",
    "Labaid Hospital",
    "Green Life Hospital",
    "Ibn Sina Hospital",
    "Dhaka Medical",
    "Popular Hospital",
    "CMH Dhaka",
  ];

  final List<String> _numberList = [
    "01711-123456",
    "01722-234567",
    "01733-345678",
    "01744-456789",
    "01755-567890",
    "01766-678901",
    "01777-789012",
    "01788-890123",
    "01799-901234",
    "01800-012345",
  ];

  final List<String> _locationList = [
    "Gulshan, Dhaka",
    "Panthapath, Dhaka",
    "Banani, Dhaka",
    "Bashundhara, Dhaka",
    "Dhanmondi, Dhaka",
    "Green Road, Dhaka",
    "Dhanmondi 12, Dhaka",
    "Azimpur, Dhaka",
    "Shyamoli, Dhaka",
    "Cantonment, Dhaka",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Nearby Hospitals"),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _nameList.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onLongPress: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Long pressed: ${_nameList[index]}"),
                      ),
                    );
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: ListTile(
                      title: Text(
                        _nameList[index],
                        style: const TextStyle(
                          color: Color.fromARGB(255, 0, 12, 53),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_numberList[index]),
                          const SizedBox(height: 4),
                          Text("Location: ${_locationList[index]}"),
                        ],
                      ),
                      leading: const Icon(
                        Icons.local_hospital_rounded,
                        size: 40,
                        color: Colors.green,
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.location_on,
                            color: Color.fromARGB(255, 0, 12, 53),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "5.6 km", // can be another dynamic list later
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      onTap: () {
                        print(_nameList[index]);
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
