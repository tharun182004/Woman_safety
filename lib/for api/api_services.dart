import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

String baseUrl = 'http://10.0.2.2:8000/user_app/';

class LoginService {
  // Function for login
  static Future<http.Response?> login(String username, String password) async {
    final String url = '${baseUrl}login/';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");
      return response;
    } catch (e) {
      // TODO

      print('Error: $e');
      return null;
    }
  }
}

class RegisterService {
  // Function for login
  static Future<http.Response?> register(
      String username, String email, String password1, String password2) async {
    final String url = '${baseUrl}register/';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'username': username,
          'email': email,
          'password1': password1,
          'password2': password2,
        }),
      );
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");
      print(password1);
      print(password2);
      return response;
    } catch (e) {
      // TODO

      print('Error: $e');
      return null;
    }
  }
}

class LocationService {
  // Function to send the location to the backend
  Future<void> sendLocationToBackend(LatLng location) async {
    try {
      // Prepare the data to be sent
      Map<String, dynamic> locationData = {
        'latitude': location.latitude,
        'longitude': location.longitude,
      };

      // Send the POST request
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json', // Set appropriate content type
        },
        body: json.encode(locationData), // Convert the location data to JSON
      );

      if (response.statusCode == 200) {
        print("Location sent to backend successfully!");
      } else {
        print("Failed to send location. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error sending location to backend: $e");
    }
  }
}
