import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

String baseUrl = 'http://192.168.0.113:8000/admin_app/';

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

class LocationFetch {
  Future<Object?> getLocationFromBackend() async {
    final String url =
        '${baseUrl}location-from-user/'; // Endpoint for fetching location
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('access_token');

      if (accessToken == null) {
        throw Exception('Access token not found. Please log in again.');
      }
      // Send the GET request
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken' // Optional: Set content type
        },
      );

      if (response.statusCode == 200) {
        // Parse the response body
        final List<dynamic> data = json.decode(response.body);

        // Return the location as LatLng object
        print(response.body);
        return data
            .map((item) => {
                  'Latitude': item['latitude'].toString(),
                  'Longitude': item['longitude'].toString(),
                  'updated': item['updated'].toString(),
                  'username': item['user'].toString(),
                })
            .toList();
      } else {
        print("Failed to fetch location. Status code: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error fetching location from backend: $e");
      return null;
    }
  }
}

class PostFetch {
  Future<List<Map<String, String>>> fetchpost() async {
    final String url =
        '${baseUrl}posts-from-user/'; // Endpoint for fetching location
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('access_token');

      if (accessToken == null) {
        throw Exception('Access token not found. Please log in again.');
      }

      // Send the GET request
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken'
        },
      );

      if (response.statusCode == 200) {
        // Parse the response body
        final List<dynamic> data = json.decode(response.body);

        // Return the location as LatLng object
        return data
            .map((item) => {
                  'title': item['title'].toString(),
                  'description': item['description'].toString()
                })
            .toList();
      } else {
        final errorResponse = json.decode(response.body);
        final errorMessage =
            errorResponse['error'] ?? 'An unknown error occurred.';
        throw Exception('Error: $errorMessage (Code: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Error fetching posts: $e');
    }
  }
}
