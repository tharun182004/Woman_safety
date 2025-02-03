import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_app/User_app/Components/button.dart';
import 'package:the_app/User_app/home_page.dart';
import 'package:the_app/User_app/Components/text_fields.dart';
import 'package:the_app/User_app/register_page.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../for api/api_services.dart';

class login_pg extends StatefulWidget {
  login_pg({super.key});

  @override
  State<login_pg> createState() => _LoginPageState();
}

class _LoginPageState extends State<login_pg> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  bool _isLoading = false;
  Future<void> handleLogin() async {
    if (_isLoading) return; // Prevent multiple taps
    setState(() => _isLoading = true);

    try {
      final http.Response? response = await LoginService.login(
          usernameController.text, passwordController.text);

      if (!mounted) return;

      setState(() => _isLoading = false); // Reset loading state after response

      if (response != null) {
        final responseData = json.decode(response.body);
        print("trying");
        print(responseData['error']);
        if (response.statusCode == 200) {
          final token = responseData['token'] ?? responseData['access_token'];
          print("Token stored, token : $token");

          SharedPreferences pref = await SharedPreferences.getInstance();
          await pref.setString('token', token);
          if (token == null) {
            throw Exception('Neither token nor access_token found in response');
          }
          print("Token stored successfully");
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => MainMenuPage()),
          );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Login successful!')),
          );
        } else {
          if (responseData['error'] is Map) {
            // If 'error' is a Map, format it
            final errorMap = responseData['error'] as Map<String, dynamic>;
            String errorMessage = errorMap.entries.map((entry) {
              final key = entry.key;
              final value = entry.value;
              if (value is List) {
                return '$key: ${value.join(", ")}'; // Format the list of errors
              } else if (value is String) {
                return '$key: $value'; // Format string errors
              }
              return '$key: Unknown error'; // Fallback case
            }).join("\n");

            // Display formatted error message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(errorMessage)),
            );
          } else {
            // If 'error' is a single string, just use it
            final errorMessage =
                responseData['error'] ?? 'Login failed. Please try again.';
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(errorMessage)),
            );
          }
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
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Stack(children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                image: AssetImage("Images/Splash Screen.jpg"),
                fit: BoxFit.cover,
              )),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.25),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Login",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                              )),
                          SizedBox(height: 10),
                          MyTextField(
                            controller: usernameController,
                            hintText: 'Username',
                            obsecureText: false,
                          ),
                          SizedBox(height: 10),
                          MyTextField(
                            controller: passwordController,
                            hintText: 'Password',
                            obsecureText: true,
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
                    ),
                  ),
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                    child: Row(
                      children: [
                        Text(
                          "New Here?",
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
                                    builder: (context) => register_pg()));
                          },
                          child: Text(
                            "Register",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 15),
                  login_button(name: "Login", onTap: handleLogin),
                ],
              ),
            ),
          ]),
        ));
  }
}
