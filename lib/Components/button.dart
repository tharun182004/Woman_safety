import 'package:flutter/material.dart';
import 'package:the_app/register_page.dart';

class login_button extends StatelessWidget {
  const login_button({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: SizedBox(
        width: 120,
        height: 50,
        child: GestureDetector(
          onTap: () {
            print("Button pressed");
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => register_pg()));
          },
          child: Container(
            padding: EdgeInsets.all(13),
            margin: EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 143, 53, 101),
                borderRadius: BorderRadius.circular(8)),
            child: Center(
              child: Text(
                "Login",
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
    );
  }
}
