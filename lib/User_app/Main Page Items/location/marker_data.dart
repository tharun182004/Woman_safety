import 'package:latlong2/latlong.dart';

class MarkerData {
  final LatLng position;
  final LatLng title;
  final LatLng description;

  MarkerData(
      {required this.position, required this.title, required this.description});
}
