import 'package:flutter/material.dart';
import 'package:the_app/login_page.dart';

void main() {
  runApp(const My_App());
}

class My_App extends StatelessWidget {
  const My_App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: login_pg(),
    );
  }
}
