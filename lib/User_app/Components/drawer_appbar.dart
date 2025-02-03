import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_app/for api/api_services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:the_app/User_app/user_role.dart';

class drawer_list extends StatefulWidget {
  const drawer_list({super.key});

  @override
  State<drawer_list> createState() => _drawer_listState();
}

class _drawer_listState extends State<drawer_list> {
  Future<void> handleLogout() async {
    bool _isLoading = false;

    if (_isLoading) return; // Prevent multiple taps
    setState(() => _isLoading = true);

    try {
      final http.Response? response =
          await LogoutService.logout(); // Call your logout API

      if (!mounted) return;

      setState(() => _isLoading = false); // Reset loading state after response

      if (response != null && response.statusCode == 200) {
        // Successful logout
        SharedPreferences pref = await SharedPreferences.getInstance();
        await pref.remove('token'); // Clear the token from storage
        print("Logout successful, token removed");

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => role_based_login()),
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Logout successful!')),
        );
      } else {
        // Handle failure
        final errorResponse =
            response != null ? json.decode(response.body) : null;
        String errorMessage = "Logout failed. Please try again.";

        if (errorResponse is Map && errorResponse['error'] != null) {
          errorMessage = errorResponse['error'];
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            Container(
                height: MediaQuery.of(context).size.height * 0.30,
                width: double.infinity,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("Images/New_Logo.png"),
                        fit: BoxFit.fill))),
            Expanded(
              child: Container(
                color: Colors.white,
                child: ListView(
                  children: [
                    ListTile(
                      leading: Icon(Icons.home,
                          color: Color.fromARGB(255, 143, 53, 101)),
                      title: Text(
                        "Home",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Color.fromARGB(255, 143, 53, 101)),
                      ),
                      onTap: () {
                        print("home button");
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.settings_outlined,
                          color: Color.fromARGB(255, 143, 53, 101)),
                      title: Text("Settings",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Color.fromARGB(255, 143, 53, 101))),
                      onTap: () {
                        print("Settings button");
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.person,
                          color: Color.fromARGB(255, 143, 53, 101)),
                      title: Text("About US",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Color.fromARGB(255, 143, 53, 101))),
                      onTap: () {
                        print("About us button");
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.notifications,
                          color: Color.fromARGB(255, 143, 53, 101)),
                      title: Text("Notification",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Color.fromARGB(255, 143, 53, 101))),
                      onTap: () {
                        print("Notification button");
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.lock_rounded,
                          color: Color.fromARGB(255, 143, 53, 101)),
                      title: Text("Logout",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Color.fromARGB(255, 143, 53, 101))),
                      onTap: () {
                        print("Logout button");
                        handleLogout();
                      },
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
