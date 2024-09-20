import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class Map_Page extends StatefulWidget {
  const Map_Page({super.key});

  @override
  State<Map_Page> createState() => _Map_PageState();
}

class _Map_PageState extends State<Map_Page> {
  final MapController _mapController = MapController();
  LatLng? _mylocation;

  // Getting current position
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error("Location services are disabled");
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error("Location permissions are denied");
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error("Location permissions are permanently denied");
    }
    return await Geolocator.getCurrentPosition();
  }

  // Show current location
  void _showCurrentLocation() async {
    try {
      Position position = await _determinePosition();
      LatLng currentLatLng = LatLng(position.latitude, position.longitude);
      _mapController.move(currentLatLng, 13);
      setState(() {
        _mylocation = currentLatLng;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    // Fetch and show the user's current location
    _showCurrentLocation();
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
                                ))),
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
