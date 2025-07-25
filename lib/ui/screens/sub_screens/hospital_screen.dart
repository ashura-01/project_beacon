import 'package:beacon/ui/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';

class HospitalScreen extends StatelessWidget{
  const HospitalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Nearby Hospitals"),
    );
  }
} 