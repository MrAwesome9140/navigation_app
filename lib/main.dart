import 'package:flutter/material.dart';
import 'package:navigation_app/UI/Views/Central_Screen.dart';
import 'package:navigation_app/UI/Views/Home_Screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CentralScreen(),
    );
  }
}