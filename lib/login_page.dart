import 'package:flutter/material.dart';
import 'package:the_app/Components/button.dart';
import 'package:the_app/home_page.dart';
import 'package:the_app/Components/text_fields.dart';
import 'package:the_app/Components/button.dart';
import 'package:the_app/register_page.dart';

class login_pg extends StatefulWidget {
  login_pg({super.key});

  @override
  State<login_pg> createState() => _LoginPageState();
}

class _LoginPageState extends State<login_pg> {
  @override
  Widget build(BuildContext context) {
    final usernameController = TextEditingController();
    final passwordController = TextEditingController();
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
                          Navigator.push(
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
                login_button(targetPage: MainMenuPage(), name: "Login"),
              ],
            ),
          ),
        ]));
  }
}
