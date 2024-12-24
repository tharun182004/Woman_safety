import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hardware_button_listener/hardware_button_listener.dart';
import 'package:latlong2/latlong.dart';
import 'package:the_app/for api/api_services.dart';

class Map_Page extends StatefulWidget {
  const Map_Page({super.key});

  @override
  State<Map_Page> createState() => _Map_PageState();
}

class _Map_PageState extends State<Map_Page> {
  final MapController _mapController = MapController();
  LatLng? _mylocation;
  late Stream<HardwareButtonListener> _volumeButtonStream;

  @override
  void initState() {
    super.initState();
    // Fetch and show the user's current location
    _volumeButtonStream =
        HardwareButtonListener() as Stream<HardwareButtonListener>;
    _listenToVolumeButtons();
    _showCurrentLocation();
  }

  @override
  void dispose() {
    // Dispose listeners when the widget is removed
    super.dispose();
  }

  void _listenToVolumeButtons() {
    _volumeButtonStream.listen((event) {
      if (event.name == "VOLUME_DOWN") {
        print("Volume Down button pressed. Triggering location fetch...");
        _triggerLocationFetchAndSend();
      }
    });
  }

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
  Future<LatLng?> fetchCurrentLocation() async {
    try {
      Position position = await _determinePosition();
      return LatLng(position.latitude, position.longitude);
    } catch (e) {
      print("Error fetching location: $e");
      return null;
    }
  }

  void _triggerLocationFetchAndSend() async {
    try {
      LatLng? currentLocation = await fetchCurrentLocation();
      if (currentLocation != null) {
        print("Current Location: $currentLocation");
        setState(() {
          _mylocation = currentLocation;
        });
        await LocationService().sendLocationToBackend(currentLocation);
        print("Location sent to backend successfully!");
      } else {
        print("Failed to fetch location.");
      }
    } catch (e) {
      print("Error in trigger process: $e");
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

extension on HardwareButtonListener {
  get name => null;
}
