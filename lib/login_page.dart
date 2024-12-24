import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_app/Components/button.dart';
import 'package:the_app/home_page.dart';
import 'package:the_app/Components/text_fields.dart';
import 'package:the_app/Components/button.dart';
import 'package:the_app/register_page.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'for api/api_services.dart';

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

      if (response != null && response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['status'] == 'Success') {
          final token = responseData['token'];
          print("Token stored, token : $token");

          SharedPreferences pref = await SharedPreferences.getInstance();
          await pref.setString('auth_token', token);
          print("Token stored successfully");
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => MainMenuPage()),
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
        String errorMessage = "Invalid login details";
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
        backgroundColor: Colors.transparent,
        body: Stack(children: [
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
        ]));
  }
}
