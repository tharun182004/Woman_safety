import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:the_app/for api/api_services.dart';

Future<Position?> getCurrentLocation() async {
  // Handle location permissions and fetch current position
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) return null;

  try {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return null;
    }
    Position position = await Geolocator.getCurrentPosition();

    debugPrint(
        "User's Location: Latitude: ${position.latitude}, Longitude: ${position.longitude}");

    await LocationService().sendLocationToBackend(position);
    return position;
  } on Exception catch (e) {
    // TODO
    debugPrint("Error fetching location: $e");
  }
  return null;
}
