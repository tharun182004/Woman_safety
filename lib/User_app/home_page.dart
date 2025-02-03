import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:the_app/User_app/Components/drawer_appbar.dart';
import 'package:the_app/User_app/Components/foreground_service.dart';
import 'package:the_app/User_app/Main%20Page%20Items/location/location_map.dart';
import 'package:the_app/User_app/Main%20Page%20Items/people%20page/people_page.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(MainMenuPage());
}

class MainMenuPage extends StatefulWidget {
  @override
  State<MainMenuPage> createState() => _MainMenuPageState();
}

class _MainMenuPageState extends State<MainMenuPage> {
  @override
  void initState() {
    super.initState();
    _initializeServices();
    _requestLocationPermission();
  }

  Future<void> _initializeServices() async {
    // Initialize notification service
    await NotificationService.initializeNotification();
    await NotificationService.createSOSNotification();

    // Initialize background service
    // Ensure the background service is only initialized here

    print("Services initialized.");
  }

  Future<void> _requestLocationPermission() async {
    var status = await Permission.location.status;

    if (status.isDenied) {
      // Request permission
      if (await Permission.location.request().isGranted) {
        print("Location permission granted!");
        _checkLocationServices();
      } else {
        print("Location permission denied!");
        _showPermissionDeniedDialog();
      }
    } else if (status.isPermanentlyDenied) {
      print("Location permission permanently denied!");
      _showSettingsDialog();
    } else {
      print("Location permission already granted!");
      _checkLocationServices();
    }
  }

  Future<void> _checkLocationServices() async {
    bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isLocationEnabled) {
      _showEnableLocationDialog();
    } else {
      print("Location services are enabled.");
    }
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Permission Denied"),
        content: Text(
          "Location permission is required for this feature. Please enable it in your device settings.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Permission Required"),
        content: Text(
          "Location permission is permanently denied. Open settings to enable it.",
        ),
        actions: [
          TextButton(
            onPressed: () {
              openAppSettings();
              Navigator.pop(context);
            },
            child: Text("Open Settings"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
        ],
      ),
    );
  }

  void _showEnableLocationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Enable Location Services"),
        content: Text(
          "Location services are turned off. Please enable them to proceed.",
        ),
        actions: [
          TextButton(
            onPressed: () {
              Geolocator.openLocationSettings();
              Navigator.pop(context);
            },
            child: Text("Open Settings"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
        ],
      ),
    );
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        drawer: drawer_list(),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
        ),
        extendBodyBehindAppBar: true,
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('Images/Splash Screen.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "Main Menu",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SingleChildScrollView(
                    child: Container(
                      height: MediaQuery.of(context).size.height *
                          0.4, // Reduced height
                      padding:
                          EdgeInsets.all(15), // Padding inside the main box
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.grey.shade300,
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                        gradient: LinearGradient(
                          colors: [Colors.white, Colors.grey.shade100],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              buildMenuBox(
                                  context, Icons.phone, 'Helpline', () {}),
                              buildMenuBox(
                                  context, Icons.camera_alt, 'Camera', () {}),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              buildMenuBox(
                                  context, Icons.location_on, 'Location', () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Map_Page()));
                              }),
                              buildMenuBox(context, Icons.people, 'People', () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => PeoplePage()));
                              }),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMenuBox(
      BuildContext context, IconData icon, String label, Function() onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.35, // Reduced box width
        height: MediaQuery.of(context).size.height * 0.15, // Reduced box height
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey.shade300, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30, color: Colors.purple), // Adjusted icon size
            SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                  fontSize: 14, color: Colors.black), // Adjusted text size
            ),
          ],
        ),
      ),
    );
  }
}
