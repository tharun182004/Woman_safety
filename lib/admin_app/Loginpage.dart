import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_app/for api/api_service_admin.dart';
import 'package:the_app/admin_app/home_page.dart';
import 'package:http/http.dart' as http;

class loginpage extends StatefulWidget {
  loginpage({super.key});

  @override
  State<loginpage> createState() => _loginpageState();
}

class _loginpageState extends State<loginpage> {
  final usernamecontroller = TextEditingController();

  final passwordcontroller = TextEditingController();

  bool _isLoading = false;

  Future<void> handleLogin() async {
    if (_isLoading) return; // Prevent multiple taps
    setState(() => _isLoading = true);

    try {
      final http.Response? response = await LoginService.login(
          usernamecontroller.text, passwordcontroller.text);
      print("Username: ${usernamecontroller.text}");
      print("Password: ${passwordcontroller.text}");

      if (!mounted) return;

      setState(() => _isLoading = false); // Reset loading state after response

      if (response != null) {
        final responseData = json.decode(response.body);
        if (response.statusCode == 200) {
          final accesstoken = responseData['access_token'];
          final refreshtoken = responseData['refresh_token'];

          SharedPreferences pref = await SharedPreferences.getInstance();
          await pref.setString('access_token', accesstoken);
          print("Token stored successfully");
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => Home_Page()),
          );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Login successful!')),
          );
        } else {
          final errorMessage =
              responseData['message'] ?? 'Login failed. Please try again.';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMessage)),
          );
        }
      } else {
        final errorResponse =
            response != null ? json.decode(response.body) : null;
        String errorMessage = "Error connecting to the server";
        if (errorResponse is Map) {
          errorMessage = errorResponse.values
              .map((value) =>
                  value is List ? value.join(", ") : value.toString())
              .join("\n");
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
    return Scaffold(
      backgroundColor: Colors.deepPurple[900],
      body: SafeArea(
        child: Center(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(15)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    "Login",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 15, 15, 10),
                  child: TextField(
                    controller: usernamecontroller,
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 10, 9, 9)),
                            borderRadius: BorderRadius.circular(10)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.black)),
                        fillColor: Color.fromARGB(255, 203, 180, 240),
                        filled: true,
                        hintText: "Username",
                        hintStyle: TextStyle(fontSize: 15)),
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 15, 15, 10),
                  child: TextField(
                    controller: passwordcontroller,
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 10, 9, 9)),
                            borderRadius: BorderRadius.circular(10)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.black)),
                        fillColor: const Color.fromARGB(255, 203, 180, 240),
                        filled: true,
                        hintText: 'Password',
                        hintStyle: TextStyle(fontSize: 15)),
                    obscureText: true,
                  ),
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: GestureDetector(
                        onTap: () {
                          print("Button clicked");
                          handleLogin();
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          height: 50,
                          width: 80,
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 157, 151, 202),
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10, left: 10),
                            child: Text(
                              "SignIn",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
