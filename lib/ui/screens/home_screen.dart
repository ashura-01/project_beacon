import 'dart:ui';
import 'package:beacon/ui/utils/assets_path.dart';
import 'package:beacon/ui/widgets/service_button.dart';
import 'package:beacon/ui/widgets/sos_progress_button.dart';
import 'package:flutter/material.dart';
import 'package:beacon/ui/widgets/custom_bottom_nav_bar.dart';
import 'package:beacon/ui/widgets/screen_background.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 0, 12, 53),
        elevation: 0,
        centerTitle: true,

        // Hamburger menu
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            
          },
        ),

        // Title
        title: const Text(
          "Beacon",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
      ),

      body: Stack(
        children: [
          
          ScreenBackground(
            child: Column(
              children: [
                const SizedBox(
                  height: kToolbarHeight + 80,
                ), // space below app bar
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Wrap(
                      spacing: 40,
                      runSpacing: 20,
                      alignment: WrapAlignment.center,
                      children: [
                        ServiceButton(
                          onTap: () {},
                          title: "Hospital",
                          imagePath: AssetsPath.hospitalIcon,
                        ),
                        ServiceButton(
                          onTap: () {},
                          title: "Ambulance",
                          imagePath: AssetsPath.ambulanceIcon,
                        ),
                        ServiceButton(
                          onTap: () {},
                          title: "Blood Bank",
                          imagePath: AssetsPath.bloodIcon,
                        ),
                        ServiceButton(
                          onTap: () {},
                          title: "Pharmacy",
                          imagePath: AssetsPath.pharmacyIcon,
                        ),
                        ServiceButton(
                          onTap: () {},
                          title: "Fire Service",
                          imagePath: AssetsPath.fireIcon,
                        ),
                        ServiceButton(
                          onTap: () {},
                          title: "Police",
                          imagePath: AssetsPath.policeIcon,
                        ),
                        const SizedBox(height: 160), // space for SOS button
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // SOS Button Floating Above Bottom Navigation
          Positioned(
            bottom: 180, 
            left: 0,
            right: 0,
            child: Center(
              child: SosProgressButton(
                size: 160,
                strokeWidth: 8,
                color: const Color.fromARGB(255, 0, 12, 53),
                onComplete: () {
                  print('Button fully pressed!');
                },
              ),
            ),
          ),
        ],
      ),

      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: currentIndex,
        onTap: (index) => setState(() => currentIndex = index),
      ),

      floatingActionButton: SizedBox(
        width: 72,
        height: 72,
        child: FloatingActionButton(
          shape: const CircleBorder(),
          backgroundColor: const Color.fromARGB(255, 0, 12, 53),
          elevation: 6,
          child: const Icon(
            Icons.home,
            size: 32, 
            color: Colors.white,
          ),
          onPressed: () => setState(() => currentIndex = 1),
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
