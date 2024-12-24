import 'package:flutter/material.dart';
import 'package:the_app/register_page.dart';
import '../home_page.dart';

class login_button extends StatelessWidget {
  final String name;
  final VoidCallback onTap;
  const login_button({super.key, required this.name, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: SizedBox(
        width: 120,
        height: 50,
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.all(13),
            margin: EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 143, 53, 101),
                borderRadius: BorderRadius.circular(8)),
            child: Center(
              child: Text(
                name,
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
