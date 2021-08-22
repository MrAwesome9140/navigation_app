import 'package:flutter/material.dart';
import 'package:navigation_app/UI/Views/Central_Screen.dart';
import 'package:navigation_app/UI/Views/Home_Screen.dart';
import 'package:flutter/services.dart';

import 'UI/Views/Login_Screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      home: LoginScreen(),
      theme: ThemeData(
        fontFamily: 'Gelasio',
      ),
    );
  }
}
