import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:permission_handler/permission_handler.dart';

class BluMessenger extends StatefulWidget {
  const BluMessenger({super.key});

  @override
  State<BluMessenger> createState() => _BluMessengerState();
}

class _BluMessengerState extends State<BluMessenger> {
  final Strategy strategy = Strategy.P2P_STAR;

  String deviceName = '';
  String? connectedId;
  String? connectedDeviceName;

  bool isAdvertising = false;
  bool isDiscovering = false;

  List<Endpoint> discoveredDevices = [];
  List<String> messages = [];
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    deviceName =
        Platform.localHostname.isNotEmpty
            ? 'Device_${Platform.localHostname}'
            : 'Device_${DateTime.now().millisecondsSinceEpoch}';
  }

  Future<void> _requestPermissions() async {
    await [
      Permission.bluetooth,
      Permission.bluetoothAdvertise,
      Permission.bluetoothConnect,
      Permission.bluetoothScan,
      Permission.location,
      Permission.nearbyWifiDevices,
    ].request();
  }

  /// Start advertising
  Future<void> startAdvertising() async {
    await _requestPermissions();
    try {
      await Nearby().startAdvertising(
        deviceName,
        strategy,
        onConnectionInitiated: _onConnectionInit,
        onConnectionResult: (id, status) {
          if (status == Status.CONNECTED && mounted) {
            setState(() => connectedId = id);
          }
        },
        onDisconnected: (id) {
          if (mounted) {
            setState(() {
              connectedId = null;
              connectedDeviceName = null;
            });
          }
        },
      );
      setState(() => isAdvertising = true);
    } catch (e) {
      print('Advertising Error: $e');
    }
  }

  /// Stop advertising
  Future<void> stopAdvertising() async {
    await Nearby().stopAdvertising();
    setState(() => isAdvertising = false);
  }

  /// Start discovery
  Future<void> startDiscovery() async {
    await _requestPermissions();
    discoveredDevices.clear();
    try {
      await Nearby().startDiscovery(
        deviceName,
        strategy,
        onEndpointFound: (id, name, serviceId) {
          if (!discoveredDevices.any((e) => e.id == id)) {
            setState(() {
              discoveredDevices.add(Endpoint(id: id, name: name));
            });
          }
        },
        onEndpointLost: (id) {
          setState(() {
            discoveredDevices.removeWhere((e) => e.id == id);
          });
        },
      );
      setState(() => isDiscovering = true);
    } catch (e) {
      print('Discovery Error: $e');
    }
  }

  /// Stop discovery
  Future<void> stopDiscovery() async {
    await Nearby().stopDiscovery();
    setState(() => isDiscovering = false);
  }

  /// Connection callback
  void _onConnectionInit(String id, ConnectionInfo info) {
    setState(() => connectedDeviceName = info.endpointName);

    Nearby().acceptConnection(
      id,
      onPayLoadRecieved: (endid, payload) {
        if (payload.type == PayloadType.BYTES) {
          String msg = String.fromCharCodes(payload.bytes!);
          setState(() {
            messages.add("🟢 ${connectedDeviceName ?? 'Friend'}: $msg");
          });
        }
      },
      onPayloadTransferUpdate: (endid, update) {},
    );
  }

  /// Request connection to selected device
  Future<void> connectToDevice(Endpoint device) async {
    try {
      await Nearby().requestConnection(
        deviceName,
        device.id,
        onConnectionInitiated: _onConnectionInit,
        onConnectionResult: (id, status) {
          if (status == Status.CONNECTED && mounted) {
            setState(() => connectedId = id);
          }
        },
        onDisconnected: (id) {
          setState(() {
            connectedId = null;
            connectedDeviceName = null;
          });
        },
      );
    } catch (e) {
      print('Connection Error: $e');
    }
  }

  void _sendMessage(String msg) async {
    if (connectedId != null && msg.isNotEmpty) {
      try {
        await Nearby().sendBytesPayload(
          connectedId!,
          Uint8List.fromList(msg.codeUnits),
        );
        setState(() => messages.add("🔵 Me: $msg"));
      } catch (e) {
        print('Send Message Error: $e');
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    Nearby().stopAdvertising();
    Nearby().stopDiscovery();
    Nearby().stopAllEndpoints();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Blu Messenger"),
        actions: [
          IconButton(
            icon: Icon(isAdvertising ? Icons.stop : Icons.campaign),
            tooltip: isAdvertising ? 'Stop Advertising' : 'Start Advertising',
            onPressed:
                () => isAdvertising ? stopAdvertising() : startAdvertising(),
          ),
          IconButton(
            icon: Icon(isDiscovering ? Icons.stop_circle : Icons.search),
            tooltip: isDiscovering ? 'Stop Discovery' : 'Start Discovery',
            onPressed: () => isDiscovering ? stopDiscovery() : startDiscovery(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Connected info
          if (connectedDeviceName != null)
            Container(
              width: double.infinity,
              color: Colors.black12,
              padding: const EdgeInsets.all(12),
              child: Text(
                "🔗 Connected to: $connectedDeviceName",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ),
          // Device selection
          if (connectedId == null && discoveredDevices.isNotEmpty)
            Container(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: discoveredDevices.length,
                itemBuilder: (context, index) {
                  final device = discoveredDevices[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () => connectToDevice(device),
                      child: Text(device.name),
                    ),
                  );
                },
              ),
            ),
          // Chat messages
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              padding: const EdgeInsets.all(10),
              itemBuilder: (_, i) {
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  alignment:
                      messages[i].startsWith("🔵")
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color:
                          messages[i].startsWith("🔵")
                              ? Colors.blue[100]
                              : Colors.green[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      messages[i].replaceFirst(RegExp(r'^🔵 |^🟢 '), ''),
                    ),
                  ),
                );
              },
            ),
          ),
          // Input
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Helper class for discovered device
class Endpoint {
  final String id;
  final String name;

  Endpoint({required this.id, required this.name});
}
