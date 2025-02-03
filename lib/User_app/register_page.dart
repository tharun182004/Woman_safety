import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:the_app/User_app/Components/button.dart';
import 'package:the_app/User_app/Components/text_fields.dart';
import 'package:the_app/User_app/login_page.dart';
import '../for api/api_services.dart';

class register_pg extends StatefulWidget {
  const register_pg({super.key});

  @override
  State<register_pg> createState() => _register_pgState();
}

class _register_pgState extends State<register_pg> {
  final usernameController = TextEditingController();
  final fullnameController = TextEditingController();
  final emailController = TextEditingController();
  final password1Controller = TextEditingController();
  final password2Controller = TextEditingController();
  bool _isLoading = false;
  Future<void> handleregister() async {
    if (_isLoading) return; // Prevent multiple taps
    setState(() => _isLoading = true);
    print("handleLogin function triggered");

    final http.Response? response = await RegisterService.register(
        usernameController.text,
        emailController.text,
        password1Controller.text,
        password2Controller.text);

    if (!mounted) return;

    if (response != null) {
      //print("Request successful");
      final responseData = json.decode(response.body);
      print("Response data: $responseData");

      if (response.statusCode == 201) {
        print("Login successful, navigating to home page");

        if (!mounted) return; // Ensure widget is still in the tree
        final message = responseData['message'] ?? 'Registration successful';
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message)));

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => login_pg()),
        );
      } else {
        if (responseData['errors'] is Map) {
          // Extract error messages from the map
          final errors = responseData['errors'] as Map<String, dynamic>;
          String errorMessage = errors.entries.map((entry) {
            final key = entry.key;
            final value = entry.value;
            if (value is List) {
              return '$key: ${value.join(", ")}'; // Format list of errors
            } else if (value is String) {
              return '$key: $value'; // Handle string values
            }
            return '$key: Unknown error'; // Fallback for unexpected cases
          }).join("\n");

          // Display formatted error messages
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMessage)),
          );
        } else {
          // Fallback for unexpected error structure
          final errorMessage =
              responseData['message'] ?? 'Login failed. Please try again.';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMessage)),
          );
        }
      }
    } else {
      print("Error connecting to server");
      // Decode the response body to extract the actual error message
      String errorMessage = 'Failed to connect to the server';
      try {
        if (response != null && response.body.isNotEmpty) {
          final errorResponse = json.decode(response.body);
          if (errorResponse['errors'] != null &&
              errorResponse['errors']['error'] != null) {
            List<dynamic> errors = errorResponse['errors']['error'];
            if (errors.isNotEmpty) {
              errorMessage = errors[0]; // Get the first error message
            }
          }
        }
      } catch (e) {
        print("Error decoding response body: $e");
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("Images/Splash Screen.jpg"),
                  fit: BoxFit.cover)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.25),
                Container(
                  // Align all elements to the top
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.start,
                    //crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Sign Up",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 27,
                              )),
                          SizedBox(height: 30),
                          MyTextField(
                            controller: usernameController,
                            hintText: 'Username',
                            obsecureText: false,
                          ),
                          SizedBox(height: 10),
                          MyTextField(
                            controller: fullnameController,
                            hintText: 'Full Name',
                            obsecureText: false,
                          ),
                          SizedBox(height: 10),
                          MyTextField(
                            controller: emailController,
                            hintText: 'Email',
                            obsecureText: false,
                          ),
                          SizedBox(height: 10),
                          MyTextField(
                            controller: password1Controller,
                            hintText: 'Password',
                            obsecureText: false,
                          ),
                          SizedBox(height: 10),
                          MyTextField(
                            controller: password2Controller,
                            hintText: 'Confirm Password',
                            obsecureText: false,
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text("Forget Password?"),
                              SizedBox(height: 6),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Container(
                                child: Image.asset(
                                  "Images/google.png",
                                  height: 40,
                                ),
                              ),
                              SizedBox(width: 10),
                              Container(
                                child: Image.asset(
                                  "Images/facebook.png",
                                  height: 40,
                                ),
                              ),
                              SizedBox(width: 10),
                              Container(
                                child: Image.asset(
                                  "Images/apple.png",
                                  height: 40,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                login_button(name: "Register", onTap: handleregister),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                  child: Row(
                    children: [
                      Text(
                        "Already a Member?",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(width: 5),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => login_pg()));
                        },
                        child: Text(
                          "Login",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
