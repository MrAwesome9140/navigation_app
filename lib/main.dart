import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:navigation_app/UI/Views/Central_Screen.dart';
import 'package:navigation_app/UI/Views/Home_Screen.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'Services/auth_service.dart';
import 'UI/Views/Login_Screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MultiProvider(
      providers: [
        Provider<AuthService>(
          create: (_) => AuthService(FirebaseAuth.instance),
        ),
        StreamProvider(
          create: (context) => context.read<AuthService>().authStateChanges,
          initialData: '',
        ),
      ],
      child: MaterialApp(
        home: LoginScreen(),
        theme: ThemeData(
          fontFamily: 'Gelasio',
        ),
      ),
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();

    if (firebaseUser != null) {
      return CentralScreen();
    }
    return LoginScreen();
  }
}
