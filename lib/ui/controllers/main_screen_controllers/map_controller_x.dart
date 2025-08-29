import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:get/get.dart';

class MapControllerX extends GetxController with GetTickerProviderStateMixin {
  final String apiKey = "c8f4cd40553f42f59ddadb634adee401";

  late final AnimatedMapController mapController;

  // Reactive state
  var currentCenter = const LatLng(23.8103, 90.4125).obs; // Default Dhaka
  var myLocation = Rxn<LatLng>();
  var destination = Rxn<LatLng>();
  var routePoints = <LatLng>[].obs;
  var loadingRoute = false.obs;
  var routeSummary = RxnString();

  final searchController = TextEditingController();
  var suggestions = [].obs;
  Timer? _debounce;

  @override
  void onInit() {
    super.onInit();
    mapController = AnimatedMapController(vsync: this);
    _determinePosition().then((_) {
      if (destination.value != null && myLocation.value != null) {
        currentCenter.value = destination.value!;
        mapController.animateTo(
          dest: currentCenter.value,
          zoom: 14.0,
          curve: Curves.easeInOut,
          duration: const Duration(milliseconds: 600),
        );
        getRoute(myLocation.value!, destination.value!);
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
    myLocation.value = LatLng(pos.latitude, pos.longitude);
    currentCenter.value = myLocation.value!;

    mapController.animateTo(
      dest: currentCenter.value,
      zoom: 14.0,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 600),
    );
  }

  /// Debounced search
  void getSuggestionsDebounced(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      getSuggestions(query);
    });
  }

  Future<void> getSuggestions(String query) async {
    if (query.isEmpty) {
      suggestions.clear();
      return;
    }
    final url =
        "https://api.geoapify.com/v1/geocode/autocomplete?text=$query&apiKey=$apiKey";
    final res = await http.get(Uri.parse(url));
    if (res.statusCode == 200) {
      final data = json.decode(res.body);
      suggestions.value = data["features"];
    }
  }

  /// Fetch route between two points
  Future<void> getRoute(LatLng start, LatLng end) async {
    loadingRoute.value = true;
    routeSummary.value = null;

    final url =
        "https://api.geoapify.com/v1/routing?waypoints=${start.latitude},${start.longitude}|${end.latitude},${end.longitude}&mode=drive&apiKey=$apiKey";
    final res = await http.get(Uri.parse(url));

    if (res.statusCode == 200) {
      final data = json.decode(res.body);
      final coords =
          data["features"][0]["geometry"]["coordinates"][0] as List<dynamic>;
      final props = data["features"][0]["properties"];

      final points =
          coords.map((c) => LatLng(c[1].toDouble(), c[0].toDouble())).toList();

      routePoints.value = points;
      routeSummary.value =
          "${(props["time"] / 60).toStringAsFixed(0)} mins • ${(props["distance"] / 1000).toStringAsFixed(1)} km";
    } else {
      Get.snackbar("Error", "Failed to fetch route");
    }
    loadingRoute.value = false;
  }

  /// Select location from search
  void selectSuggestion(dynamic feature) {
    final coords = feature["geometry"]["coordinates"];
    final selected = LatLng(coords[1], coords[0]);

    destination.value = selected;
    suggestions.clear();
    searchController.clear();
    currentCenter.value = selected;

    mapController.animateTo(
      dest: selected,
      zoom: 14.0,
      curve: Curves.easeInOut,
      duration: const Duration(milliseconds: 600),
    );

    if (myLocation.value != null) {
      getRoute(myLocation.value!, selected);
    }
  }
}
