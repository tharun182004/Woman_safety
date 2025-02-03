import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';

import 'package:latlong2/latlong.dart';
import 'package:the_app/for api/api_services.dart';

final GlobalKey<_Map_PageState> mapPageKey = GlobalKey<_Map_PageState>();

class Map_Page extends StatefulWidget {
  const Map_Page({super.key});

  @override
  State<Map_Page> createState() => _Map_PageState();
}

class _Map_PageState extends State<Map_Page> {
  final MapController _mapController = MapController();
  LatLng? _mylocation;
  late DateTime pressStartTime;

  @override
  void initState() {
    super.initState();
    // Fetch and show the user's current location
    // _listenToVolumeButtons();
    _showCurrentLocation();
  }

  @override
  void dispose() {
    // Dispose listeners when the widget is removed
    super.dispose();
  }

  // Getting current position
  Future<Position> _determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showPermissionDialog("Enable location services to proceed.");
      throw Exception("Location services are disabled.");
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showPermissionDialog("Location permissions are required.");
        throw Exception("Location permissions are denied.");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _showPermissionDialog("Location permissions are permanently denied.");
      throw Exception("Location permissions are permanently denied.");
    }

    return await Geolocator.getCurrentPosition();
  }

  void _showPermissionDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Permission Required"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  // Show current location
  Future<LatLng?> fetchCurrentLocation() async {
    try {
      Position position = await _determinePosition();
      return LatLng(position.latitude, position.longitude);
    } catch (e) {
      print("Error fetching location: $e");
      return null;
    }
  }

  Future _triggerLocationFetchAndSend() async {
    try {
      LatLng? currentLocation = await fetchCurrentLocation();
      if (currentLocation != null) {
        setState(() => _mylocation = currentLocation);
        await LocationService()
            .sendLocationToBackend(currentLocation as Position);
        print("Location sent to backend successfully! $_mylocation");
      }
    } catch (e) {
      print("Error sending location: $e");
    }
  }

  void _showCurrentLocation() async {
    LatLng? location = await fetchCurrentLocation();
    if (location != null) {
      setState(() {
        _mylocation = location;
      });
      _mapController.move(location, 15.0); // Adjust zoom level
    } else {
      print("Could not fetch current location.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("User Location Map")),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter:
                  _mylocation ?? LatLng(13.0843, 80.2705), // Default location
              initialZoom: 13,
              onTap: (tapPosition, LatLng) {},
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              ),
              if (_mylocation != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      width: 80.0,
                      height: 80.0,
                      point: _mylocation!,
                      child: Builder(
                        builder: (context) => const Icon(
                          Icons.location_pin,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed:
                  _showCurrentLocation, // Re-center map on current location
              child: Icon(Icons.my_location),
            ),
          ),
        ],
      ),
    );
  }
}
