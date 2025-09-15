import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class MapScreen extends StatefulWidget {
  final String apiKey = "c8f4cd40553f42f59ddadb634adee401";
  final LatLng? destination;
  final String? destinationName;

  const MapScreen({super.key, this.destination, this.destinationName});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with TickerProviderStateMixin {
  late final AnimatedMapController _mapController;
  LatLng _currentCenter = LatLng(23.8103, 90.4125); // Default Dhaka
  LatLng? _myLocation;
  LatLng? _destination;
  List<LatLng> _routePoints = [];
  bool _loadingRoute = false;
  String? _routeSummary;

  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _suggestions = [];
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _mapController = AnimatedMapController(vsync: this);
    _determinePosition().then((_) {
      if (widget.destination != null && _myLocation != null) {
        setState(() {
          _destination = widget.destination;
          _currentCenter = widget.destination!;
        });
        _mapController.animateTo(
          dest: _currentCenter,
          zoom: 14.0,
          curve: Curves.easeInOut,
          duration: const Duration(milliseconds: 600),
        );
        _getRoute(_myLocation!, _destination!);
      }
    });
  }

  /// Get current location
  Future<void> _determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }
    if (permission == LocationPermission.deniedForever) return;

    final pos = await Geolocator.getCurrentPosition();
    setState(() {
      _myLocation = LatLng(pos.latitude, pos.longitude);
      _currentCenter = _myLocation!;
    });

    _mapController.animateTo(
      dest: _currentCenter,
      zoom: 14.0,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 600),
    );
  }

  /// Fetch location suggestions with debounce
  void _getSuggestionsDebounced(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      _getSuggestions(query);
    });
  }

  Future<void> _getSuggestions(String query) async {
    if (query.isEmpty) {
      setState(() => _suggestions = []);
      return;
    }

    final url =
        "https://api.geoapify.com/v1/geocode/autocomplete?text=$query&apiKey=${widget.apiKey}";
    final res = await http.get(Uri.parse(url));
    if (res.statusCode == 200) {
      final data = json.decode(res.body);
      setState(() {
        _suggestions = data["features"];
      });
    }
  }

  /// Fetch route between two points
  Future<void> _getRoute(LatLng start, LatLng end) async {
    setState(() {
      _loadingRoute = true;
      _routeSummary = null;
    });

    final url =
        "https://api.geoapify.com/v1/routing?waypoints=${start.latitude},${start.longitude}|${end.latitude},${end.longitude}&mode=drive&apiKey=${widget.apiKey}";
    final res = await http.get(Uri.parse(url));

    if (res.statusCode == 200) {
      final data = json.decode(res.body);
      final coords =
          data["features"][0]["geometry"]["coordinates"][0] as List<dynamic>;
      final props = data["features"][0]["properties"];

      final points =
          coords.map((c) => LatLng(c[1].toDouble(), c[0].toDouble())).toList();

      setState(() {
        _routePoints = points;
        _routeSummary =
            "${(props["time"] / 60).toStringAsFixed(0)} mins • ${(props["distance"] / 1000).toStringAsFixed(1)} km";
      });
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Failed to fetch route")));
    }
    setState(() => _loadingRoute = false);
  }

  /// Select location from search
  void _selectSuggestion(dynamic feature) {
    final coords = feature["geometry"]["coordinates"];
    final selected = LatLng(coords[1], coords[0]);

    setState(() {
      _destination = selected;
      _suggestions = [];
      _searchController.clear();
      _currentCenter = selected;
    });

    _mapController.animateTo(
      dest: selected,
      zoom: 14.0,
      curve: Curves.easeInOut,
      duration: const Duration(milliseconds: 600),
    );

    if (_myLocation != null) {
      _getRoute(_myLocation!, selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            widget.destinationName != null
                ? Text("Route to ${widget.destinationName}")
                : TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: "Search location...",
                    border: InputBorder.none,
                    
                  ),
                  style: TextStyle(color: Colors.white),
                  onChanged: _getSuggestionsDebounced,
                ),
        backgroundColor: const Color.fromARGB(255, 0, 12, 53),
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController.mapController,
            options: MapOptions(
              initialCenter: _currentCenter,
              initialZoom: 13,
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.all,
              ),
            ),
            children: [
              TileLayer(
                urlTemplate:
                    "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: const ['a', 'b', 'c'],
              ),
              if (_myLocation != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _myLocation!,
                      width: 40,
                      height: 40,
                      child: const Icon(
                        Icons.my_location,
                        color: Colors.blue,
                        size: 30,
                      ),
                    ),
                  ],
                ),
              if (_destination != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _destination!,
                      width: 40,
                      height: 40,
                      child: const Icon(
                        Icons.location_on,
                        color: Colors.red,
                        size: 35,
                      ),
                    ),
                  ],
                ),
              if (_routePoints.isNotEmpty)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: _routePoints,
                      color: Colors.blue,
                      strokeWidth: 5.0,
                    ),
                  ],
                ),
            ],
          ),

          // Loader
          if (_loadingRoute) const Center(child: CircularProgressIndicator()),

          // Suggestions dropdown
          if (_suggestions.isNotEmpty && widget.destination == null)
            Positioned(
              top: 80,
              left: 15,
              right: 15,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _suggestions.length,
                  itemBuilder: (context, index) {
                    final s = _suggestions[index];
                    final props = s["properties"];
                    return ListTile(
                      title: Text(props["formatted"]),
                      onTap: () => _selectSuggestion(s),
                    );
                  },
                ),
              ),
            ),

          // Route summary like Google Maps
          if (_routeSummary != null)
            Positioned(
              bottom: 80,
              left: 20,
              right: 20,
              child: Card(
                color: Colors.white,
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.directions_car,
                        color: Colors.blue,
                        size: 28,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        _routeSummary!,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),

      // Floating buttons (like Google Maps)
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: "zoomIn",
            mini: true,
            child: const Icon(Icons.add),
            onPressed: () {
              _mapController.mapController.move(
                _mapController.mapController.camera.center,
                _mapController.mapController.camera.zoom + 1,
              );
            },
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            heroTag: "zoomOut",
            mini: true,
            child: const Icon(Icons.remove),
            onPressed: () {
              _mapController.mapController.move(
                _mapController.mapController.camera.center,
                _mapController.mapController.camera.zoom - 1,
              );
            },
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            heroTag: "myLocation",
            child: const Icon(Icons.my_location),
            onPressed: () {
              if (_myLocation != null) {
                _mapController.animateTo(
                  dest: _myLocation!,
                  zoom: 15.0,
                  curve: Curves.easeOut,
                  duration: const Duration(milliseconds: 600),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
