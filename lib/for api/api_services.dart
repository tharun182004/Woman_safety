import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

String baseUrl = 'http://172.15.22.3:8000/user_app/';

class LoginService {
  // Function for login
  static Future<http.Response?> login(String username, String password) async {
    final String url = '${baseUrl}login/';
    try {
      final response = await http
          .post(
            Uri.parse(url),
            headers: {
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              'username': username,
              'password': password,
            }),
          )
          .timeout(Duration(seconds: 10));
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");
      return response;
    } catch (e) {
      // TODO

      print('Error occurred: $e');
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

class LogoutService {
  static Future<http.Response?> logout() async {
    final String url = '${baseUrl}logout/';
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        throw Exception('No token found. User might already be logged out.');
      }

      // Send a POST request to the backend to invalidate the token
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $token',
        },
      );

      if (response.statusCode == 200) {
        print("Logout successful. Status code: ${response.statusCode}");
        // Clear the token from local storage
        await prefs.remove('token');
      } else {
        print("Failed to log out. Status code: ${response.statusCode}");
      }
      return response; // Return the HTTP response
    } catch (e) {
      print("Error during logout: $e");
      return null; // Return null if an error occurs
    }
  }
}

class LocationService {
  // Function to send the location to the backend
  Future<void> sendLocationToBackend(Position position) async {
    final String url = '${baseUrl}location/';
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final Token = prefs.getString('token');
      debugPrint(Token);

      if (Token == null) {
        throw Exception('Access token not found. Please log in again.');
      }
      // Prepare the data to be sent
      Map<String, dynamic> locationData = {
        'latitude': position.latitude,
        'longitude': position.longitude,
      };

      // Send the POST request
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $Token'
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
