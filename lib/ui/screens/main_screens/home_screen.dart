import 'package:beacon/ui/screens/main_screens/blu_messenger.dart';
import 'package:beacon/ui/screens/sub_screens/hospital_screen.dart';
import 'package:beacon/ui/utils/assets_path.dart';
import 'package:beacon/ui/utils/page_switch.dart';
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
        leading: Builder(
          builder:
              (context) => IconButton(
                icon: const Icon(Icons.menu, color: Colors.white),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
        ),
        title: const Text(
          "Beacon",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
      ),


      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Color.fromARGB(255, 0, 12, 53)),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('My Account'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('About Us'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.volunteer_activism),
              title: const Text('Join Volunteer'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),

      body: Stack(
        children: [
          ScreenBackground(
            child: Column(
              children: [
                const SizedBox(
                  height: kToolbarHeight + 80,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 20,
                      alignment: WrapAlignment.center,
                      children: [
                        ServiceButton(
                          onTap: () {
                            navigateTo(context, HospitalScreen());
                          },
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
                        const SizedBox(height: 160),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          Positioned(
            bottom: 160,
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
        onTap: onNavTap,
      ),

      floatingActionButton: SizedBox(
        width: 72,
        height: 72,
        child: FloatingActionButton(
          shape: const CircleBorder(),
          backgroundColor: const Color.fromARGB(255, 0, 12, 53),
          elevation: 6,
          child: const Icon(Icons.home, size: 32, color: Colors.white),
          onPressed: () => setState(() => currentIndex = 1),
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  void onNavTap(int index) {
    setState(() {
      currentIndex = index;
    });

    if (index == 0) {
      print("Location tapped");
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const BluMessenger()),
      ).then((_) {
        // Refresh home screen when coming back
        setState(() {});
      });
    }
  }
}
