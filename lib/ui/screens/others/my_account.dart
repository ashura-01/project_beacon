import 'package:beacon/controllers/auth_controller.dart';
import 'package:beacon/ui/screens/main_screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class MyAccountScreen extends StatelessWidget {
  const MyAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find();

    // Initial fetch of user data
    authController.refreshUserData();

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Account"),
        backgroundColor: const Color.fromARGB(255, 0, 12, 53),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () async {
              await authController.refreshUserData();
            },
            tooltip: "Reload",
          ),
        ],
      ),
      body: SafeArea(
        child: Obx(() {
          final user = authController.firebaseUser.value;
          final userData = authController.reactiveUserData.value;

          if (user == null) {
            return const Center(child: Text("User not logged in"));
          }

          if (userData == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.blueGrey,
                    child: Text(
                      (userData["name"] ?? "U")[0].toUpperCase(),
                      style: const TextStyle(fontSize: 40, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text("Name"),
                  subtitle: Text(userData["name"] ?? "-"),
                ),
                ListTile(
                  leading: const Icon(Icons.email),
                  title: const Text("Email"),
                  subtitle: Text(userData["email"] ?? "-"),
                ),
                ListTile(
                  leading: const Icon(Icons.location_on),
                  title: const Text("Address"),
                  subtitle: Text(userData["location"] ?? "-"), 
                ),
                ListTile(
                  leading: const Icon(Icons.phone),
                  title: const Text("Contact"),
                  subtitle: Text(userData["contact"] ?? "-"),
                ),
                const SizedBox(height: 30),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      await authController.logout();
                      Get.offAll(() => const LoginScreen());
                    },
                    icon: const Icon(Icons.logout, color: Colors.white),
                    label: const Text("Logout", style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 0, 12, 53),
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}



// class MyAccountScreen extends StatelessWidget {
//   const MyAccountScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final AuthController authController = Get.find();

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("My Account"),
//         backgroundColor: const Color.fromARGB(255, 0, 12, 53),
//         foregroundColor: Colors.white,
//       ),
//       body: SafeArea(
//         child: FutureBuilder<Map<String, dynamic>?>(
//           future: authController.getUserData(),
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Center(child: CircularProgressIndicator());
//             } else if (snapshot.hasError) {
//               return Center(child: Text("Error: ${snapshot.error}"));
//             } else if (!snapshot.hasData || snapshot.data == null) {
//               return const Center(child: Text("No user data found"));
//             }

//             final userData = snapshot.data!;
//             return Padding(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Center(
//                     child: CircleAvatar(
//                       radius: 50,
//                       backgroundColor: Colors.blueGrey,
//                       child: Text(
//                         (userData["name"] ?? "U")[0].toUpperCase(),
//                         style: const TextStyle(
//                           fontSize: 40,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   ListTile(
//                     leading: const Icon(Icons.person),
//                     title: const Text("Name"),
//                     subtitle: Text(userData["name"] ?? "-"),
//                   ),
//                   ListTile(
//                     leading: const Icon(Icons.email),
//                     title: const Text("Email"),
//                     subtitle: Text(userData["email"] ?? "-"),
//                   ),
//                   ListTile(
//                     leading: const Icon(Icons.location_on),
//                     title: const Text("Address"),
//                     subtitle: Text(userData["address"] ?? "-"),
//                   ),
//                   ListTile(
//                     leading: const Icon(Icons.phone),
//                     title: const Text("Contact"),
//                     subtitle: Text(userData["contact"] ?? "-"),
//                   ),
//                   const SizedBox(height: 30),
//                   Center(
//                     child: ElevatedButton.icon(
//                       onPressed: () async {
//                         await AuthController.instance.logout();
//                         Get.offAll(() => LoginScreen());
//                       },
//                       icon: const Icon(Icons.logout, color: Colors.white),
//                       label: const Text(
//                         "Logout",
//                         style: TextStyle(color: Colors.white),
//                       ),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: const Color.fromARGB(255, 0, 12, 53),
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 30,
//                           vertical: 15,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
