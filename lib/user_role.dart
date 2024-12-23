import 'package:flutter/material.dart';
import 'package:the_app/login_page.dart';

class role_based_login extends StatefulWidget {
  const role_based_login({super.key});

  @override
  State<role_based_login> createState() => role_based_loginState();
}

class role_based_loginState extends State<role_based_login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("Images/Splash Screen.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Curved top section with logo and app name
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.14),
                  child: Column(
                    children: [
                      Image.asset('Images/New_Logo.png', height: 200),
                      SizedBox(height: 20),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.60,
                        height: MediaQuery.of(context).size.height * 0.06,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => login_pg(),
                                ));
                          },
                          child: Container(
                            padding: EdgeInsets.all(13),
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 143, 53, 101),
                                borderRadius: BorderRadius.circular(8)),
                            child: Center(
                              child: Text(
                                "User",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 25),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.60,
                  height: MediaQuery.of(context).size.height * 0.06,
                  child: GestureDetector(
                    child: Container(
                      padding: EdgeInsets.all(13),
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 143, 53, 101),
                          borderRadius: BorderRadius.circular(8)),
                      child: Center(
                        child: Text(
                          "Admin",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
