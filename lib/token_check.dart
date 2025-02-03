import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_app/User_app/home_page.dart';
import 'package:the_app/User_app/user_role.dart';

class CheckToken extends StatelessWidget {
  const CheckToken({Key? key}) : super(key: key);

  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: getToken(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show loading indicator while waiting
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          // Handle error case
          return Scaffold(
            body: Center(child: Text('An error occurred: ${snapshot.error}')),
          );
        }

        if (snapshot.data != null && snapshot.data!.isNotEmpty) {
          // Token exists, navigate to Home Page
          print("tokenexists, ${snapshot.data}");
          Future.microtask(() {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => MainMenuPage()),
            );
          });
        } else {
          // Token does not exist, navigate to UserRoleBased page
          Future.microtask(() {
            print("Token does not exists");
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => role_based_login()),
            );
          });
        }

        // Return empty widget while navigation is handled
        return SizedBox.shrink();
      },
    );
  }
}
