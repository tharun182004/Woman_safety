import 'package:flutter/material.dart';
import 'package:the_app/Components/button.dart';
import 'package:the_app/Components/text_fields.dart';
import 'package:the_app/login_page.dart';

class register_pg extends StatefulWidget {
  const register_pg({super.key});

  @override
  State<register_pg> createState() => _register_pgState();
}

class _register_pgState extends State<register_pg> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
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
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.35),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Sign Up",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 27,
                            )),
                        SizedBox(height: 10),
                        MyTextField(
                          controller: usernameController,
                          hintText: 'Full Name',
                          obsecureText: false,
                        ),
                        SizedBox(height: 10),
                        MyTextField(
                          controller: passwordController,
                          hintText: 'Email',
                          obsecureText: false,
                        ),
                        SizedBox(height: 10),
                        MyTextField(
                          controller: passwordController,
                          hintText: 'Password',
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
                  ),
                ),
                const SizedBox(height: 5),
                SizedBox(height: 15),
                login_button(targetPage: login_pg(), name: "Register"),
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
                          Navigator.push(
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
