import 'package:beacon/controllers/auth_controller.dart';
import 'package:beacon/ui/screens/main_screens/login_screen.dart';
import 'package:beacon/ui/screens/others/about_us.dart';
import 'package:beacon/ui/screens/others/my_account.dart';
import 'package:beacon/ui/screens/others/settings.dart';
import 'package:beacon/ui/utils/page_switch.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 0, 12, 53),
            ),
            child: Container(
              width: double.infinity, // ensure full width
              alignment: Alignment.bottomLeft, // optional
              child: const Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
          ),

          // Main Menu Items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('My Account'),
                  onTap: () {
                    Navigator.pop(context);
                    navigateTo(context, MyAccountScreen());
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('Settings'),
                  onTap: () {
                    Navigator.pop(context);
                    navigateTo(context, SettingsScreen());
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.info),
                  title: const Text('About Us'),
                  onTap: () {
                    Navigator.pop(context);
                    navigateTo(context, AboutUsScreen());
                  },
                ),
                
              ],
            ),
          ),

          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout', style: TextStyle(color: Colors.red)),
            onTap: () async {
              await AuthController.instance.logout(); 
              Get.offAll(() => LoginScreen()); 
            },
          ),
        ],
      ),
    );
  }
}
