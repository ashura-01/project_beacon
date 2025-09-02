import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../widgets/custom_appbar.dart';

class BluMessenger extends StatefulWidget {
  const BluMessenger({super.key});
  @override
  State<BluMessenger> createState() => _BluMessengerState();
}

class _BluMessengerState extends State<BluMessenger> {
  final Strategy strategy = Strategy.P2P_CLUSTER;
  final List<String> messages = [];
  final TextEditingController _controller = TextEditingController();

  String? connectedId;
  String? connectedDeviceName;

  @override
  void initState() {
    super.initState();
    _initNearby();
  }

  Future<void> _initNearby() async {
    // Request permissions
    await [
      Permission.bluetooth,
      Permission.location,
      Permission.bluetoothAdvertise,
      Permission.bluetoothConnect,
      Permission.bluetoothScan,
      Permission.nearbyWifiDevices,
    ].request();

    final deviceName = Platform.localHostname.isNotEmpty
        ? 'Device_${Platform.localHostname}'
        : 'Device_${DateTime.now().millisecondsSinceEpoch}';

    // Start advertising
    try {
      await Nearby().startAdvertising(
        deviceName,
        strategy,
        onConnectionInitiated: _onConnectionInit,
        onConnectionResult: (id, status) {
          print("Advertiser Connection Result: $status");
          if (status == Status.CONNECTED && mounted) {
            setState(() => connectedId = id);
          }
        },
        onDisconnected: (id) {
          print("Disconnected from: $id");
          if (mounted) {
            setState(() {
              connectedId = null;
              connectedDeviceName = null;
            });
          }
        },
      );
    } catch (e) {
      print('Error starting advertising: $e');
    }

    // Start discovery
    try {
      await Nearby().startDiscovery(
        deviceName,
        strategy,
        onEndpointFound: (id, name, serviceId) {
          print("Found endpoint: $name");
          Nearby().requestConnection(
            deviceName,
            id,
            onConnectionInitiated: _onConnectionInit,
            onConnectionResult: (id, status) {
              print("Discovery Connection Result: $status");
              if (status == Status.CONNECTED && mounted) {
                setState(() => connectedId = id);
              }
            },
            onDisconnected: (id) {
              print("Disconnected from: $id");
              if (mounted) {
                setState(() {
                  connectedId = null;
                  connectedDeviceName = null;
                });
              }
            },
          );
        },
        onEndpointLost: (id) => print("Lost endpoint: $id"),
      );
    } catch (e) {
      print('Error starting discovery: $e');
    }
  }

  void _onConnectionInit(String id, ConnectionInfo info) {
    print("Connecting to ${info.endpointName}");

    if (mounted) {
      setState(() {
        connectedDeviceName = info.endpointName;
      });
    }

    Nearby().acceptConnection(
      id,
      onPayLoadRecieved: (endid, payload) {
        if (payload.type == PayloadType.BYTES) {
          String msg = String.fromCharCodes(payload.bytes!);
          if (mounted) {
            setState(() => messages.add("🟢 ${connectedDeviceName ?? 'Friend'}: $msg"));
          }
        }
      },
      onPayloadTransferUpdate: (endid, update) {},
    );
  }

  void _sendMessage(String msg) async {
    if (connectedId != null && msg.isNotEmpty) {
      try {
        await Nearby().sendBytesPayload(
          connectedId!,
          Uint8List.fromList(msg.codeUnits),
        );
        if (mounted) {
          setState(() => messages.add("🔵 Me: $msg"));
        }
      } catch (e) {
        print('Send message error: $e');
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    Nearby().stopAdvertising();
    Nearby().stopDiscovery();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: const CustomAppBar(title: "Blu Message"),
        body: Column(
          children: [
            if (connectedDeviceName != null)
              Container(
                width: double.infinity,
                color: Colors.black12,
                padding: const EdgeInsets.all(12),
                child: Text(
                  "🔗 Connected to: $connectedDeviceName",
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                ),
              ),
            Expanded(
              child: ListView.builder(
                itemCount: messages.length,
                padding: const EdgeInsets.all(10),
                itemBuilder: (_, i) => Container(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  alignment: messages[i].startsWith("🔵")
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: messages[i].startsWith("🔵")
                          ? Colors.blue[100]
                          : Colors.green[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(messages[i].replaceFirst(RegExp(r'^🔵 |^🟢 '), '')),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: "Enter message",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    _sendMessage(_controller.text.trim());
                    _controller.clear();
                  },
                ),
              ]),
            ),
          ],
        ),
      );
}






// import 'dart:io';
// import 'dart:typed_data';

// import 'package:flutter/material.dart';
// import 'package:nearby_connections/nearby_connections.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:beacon/ui/widgets/custom_appbar.dart'; // Adjust path if needed

// class BluMessenger extends StatefulWidget {
//   const BluMessenger({super.key});

//   @override
//   State<BluMessenger> createState() => _BluMessengerState();
// }

// class _BluMessengerState extends State<BluMessenger> {
//   final Strategy strategy = Strategy.P2P_CLUSTER;
//   final List<String> messages = [];
//   final TextEditingController _controller = TextEditingController();

//   String? connectedId;
//   String? connectedDeviceName;

//   @override
//   void initState() {
//     super.initState();
//     _startScan();
//   }

//   /// Restarts Nearby Connections (clears previous connections)
//   Future<void> _startScan() async {
//     await Nearby().stopAllEndpoints();
//     await Nearby().stopAdvertising();
//     await Nearby().stopDiscovery();

//     await _requestPermissions();
//     await _initNearby();
//   }

//   /// Requests necessary permissions
//   Future<void> _requestPermissions() async {
//     await [
//       Permission.bluetooth,
//       Permission.location,
//       Permission.bluetoothAdvertise,
//       Permission.bluetoothConnect,
//       Permission.bluetoothScan,
//       Permission.nearbyWifiDevices, // For Android 12+
//     ].request();
//   }

//   /// Initializes Nearby Connections
//   Future<void> _initNearby() async {
//     final deviceName =
//         Platform.localHostname.isNotEmpty
//             ? 'Device_${Platform.localHostname}'
//             : 'Device_${DateTime.now().millisecondsSinceEpoch}';

//     try {
//       await Nearby().startAdvertising(
//         deviceName,
//         strategy,
//         onConnectionInitiated: _onConnectionInit,
//         onConnectionResult: (id, status) {
//           print("Advertiser Connection Result: $status");
//           if (status == Status.CONNECTED) {
//             setState(() => connectedId = id);
//           }
//         },
//         onDisconnected: (id) {
//           print("Disconnected from: $id");
//           setState(() {
//             connectedId = null;
//             connectedDeviceName = null;
//           });
//         },
//       );
//     } catch (e) {
//       print('Error starting advertising: $e');
//     }

//     try {
//       await Nearby().startDiscovery(
//         deviceName,
//         strategy,
//         onEndpointFound: (id, name, serviceId) {
//           print("Found endpoint: $name");
//           Nearby().requestConnection(
//             deviceName,
//             id,
//             onConnectionInitiated: _onConnectionInit,
//             onConnectionResult: (id, status) {
//               print("Discovery Connection Result: $status");
//               if (status == Status.CONNECTED) {
//                 setState(() => connectedId = id);
//               }
//             },
//             onDisconnected: (id) {
//               print("Disconnected from: $id");
//               setState(() {
//                 connectedId = null;
//                 connectedDeviceName = null;
//               });
//             },
//           );
//         },
//         onEndpointLost: (id) => print("Lost endpoint: $id"),
//       );
//     } catch (e) {
//       print('Error starting discovery: $e');
//     }
//   }

//   /// Handles new connections
//   void _onConnectionInit(String id, ConnectionInfo info) {
//     print("Connecting to ${info.endpointName}");
//     setState(() => connectedDeviceName = info.endpointName);

//     Nearby().acceptConnection(
//       id,
//       onPayLoadRecieved: (endid, payload) {
//         if (payload.type == PayloadType.BYTES) {
//           String msg = String.fromCharCodes(payload.bytes!);
//           setState(
//             () => messages.add("🟢 ${connectedDeviceName ?? 'Friend'}: $msg"),
//           );
//         }
//       },
//       onPayloadTransferUpdate: (endid, update) {},
//     );
//   }

//   /// Sends a message over the connection
//   void _sendMessage(String msg) async {
//     if (connectedId != null && msg.isNotEmpty) {
//       try {
//         await Nearby().sendBytesPayload(
//           connectedId!,
//           Uint8List.fromList(msg.codeUnits),
//         );
//         setState(() => messages.add("🔵 Me: $msg"));
//       } catch (e) {
//         print('Send message error: $e');
//       }
//     }
//   }

//   /// Clean up
//   @override
//   void dispose() {
//     _controller.dispose();
//     Nearby().stopAllEndpoints();
//     Nearby().stopAdvertising();
//     Nearby().stopDiscovery();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) => Scaffold(
//     appBar: CustomAppBar(title: "Blu Message"),
//     body: Column(
//       children: [
//         if (connectedDeviceName != null)
//           Container(
//             width: double.infinity,
//             color: Colors.black12,
//             padding: const EdgeInsets.all(12),
//             child: Text(
//               "🔗 Connected to: $connectedDeviceName",
//               style: const TextStyle(
//                 fontWeight: FontWeight.bold,
//                 color: Colors.green,
//               ),
//             ),
//           ),
//         Expanded(
//           child: ListView.builder(
//             itemCount: messages.length,
//             padding: const EdgeInsets.all(10),
//             itemBuilder:
//                 (_, i) => Container(
//                   margin: const EdgeInsets.symmetric(vertical: 4),
//                   alignment:
//                       messages[i].startsWith("🔵")
//                           ? Alignment.centerRight
//                           : Alignment.centerLeft,
//                   child: Container(
//                     padding: const EdgeInsets.all(10),
//                     decoration: BoxDecoration(
//                       color:
//                           messages[i].startsWith("🔵")
//                               ? Colors.blue[100]
//                               : Colors.green[100],
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: Text(
//                       messages[i].replaceFirst(RegExp(r'^🔵 |^🟢 '), ''),
//                     ),
//                   ),
//                 ),
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Row(
//             children: [
//               Expanded(
//                 child: TextField(
//                   controller: _controller,
//                   decoration: const InputDecoration(
//                     hintText: "Enter message",
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//               ),
//               IconButton(
//                 icon: const Icon(Icons.send),
//                 onPressed: () {
//                   _sendMessage(_controller.text.trim());
//                   _controller.clear();
//                 },
//               ),
//             ],
//           ),
//         ),
//       ],
//     ),
//   );
// }
