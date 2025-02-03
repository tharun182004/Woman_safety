import 'dart:async';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:the_app/admin_app/google_map_admin_app.dart';
import 'package:the_app/for api/api_service_admin.dart';

class Home_Page extends StatefulWidget {
  const Home_Page({super.key});

  @override
  State<Home_Page> createState() => _Home_PageState();
}

class _Home_PageState extends State<Home_Page> {
  final LocationFetch apiService =
      LocationFetch(); // Create an instance of ApiService
  List<Map<String, String>> location = []; // List to store posts
  bool isLoading = true; // To manage loading state
  String errorMessage = ''; // To display error messages

  @override
  void initState() {
    super.initState();
    fetchlocation();
    Timer.periodic(Duration(minutes: 5), (Timer timer) {
      fetchlocation();
    }); // Fetch posts on page load
  }

  Future<void> requestPermissions() async {
    // Request location permission
    var locationStatus = await Permission.location.request();
    if (locationStatus.isGranted) {
      print("Location permission granted");
    } else {
      print("Location permission denied");
    }

    // Request notification permission
    var notificationStatus = await Permission.notification.request();
    if (notificationStatus.isGranted) {
      print("Notification permission granted");
    } else {
      print("Notification permission denied");
    }
  }

  Future<void> fetchlocation() async {
    try {
      final fetchedlocation = await apiService.getLocationFromBackend();

      if (fetchedlocation is List<Map<String, String>>) {
        setState(() {
          location = fetchedlocation;
          isLoading = false;
        });
      } else {
        throw Exception("Invalid data format received from the API");
      }
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Admin Control",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF080C25),
        actions: <Widget>[
          IconButton(onPressed: () {}, icon: Icon(Icons.menu_rounded, size: 30))
        ],
      ),
      body: RefreshIndicator(
        onRefresh: fetchlocation,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: isLoading
              ? Center(child: CircularProgressIndicator()) // Show loader
              : errorMessage.isNotEmpty
                  ? Center(child: Text(errorMessage)) // Show error message
                  : ListView.builder(
                      itemCount: location.length,
                      itemBuilder: (context, index) {
                        final post = location[index];
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            title: RichText(
                              text: TextSpan(
                                text: "Username: ${post['username']}\n",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  height: 1.5,
                                ),
                                children: [
                                  TextSpan(
                                    text: "Latitude: ${post['Latitude']}",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                      height: 1.5,
                                    ),
                                  ),
                                  TextSpan(
                                    text: "Longitude: ${post['Longitude']}",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                      height: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                              child: Text(
                                "Updated: ${post['updated']}",
                                style: TextStyle(),
                              ),
                            ),
                            trailing: IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MapScreen(
                                      latitude: double.parse(post['Latitude']!),
                                      longitude:
                                          double.parse(post['Longitude']!),
                                    ),
                                  ),
                                );
                              },
                              icon: Icon(Icons.arrow_forward_ios_rounded),
                            ),
                          ),
                        );
                      },
                    ),
        ),
      ),
    );
  }
}
