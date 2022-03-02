import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:navigation_app/Services/auth_service.dart';
import 'package:navigation_app/UI/Views/Login_Screen.dart';
import 'package:navigation_app/UI/Views/Register_Screen.dart';
import 'package:settings_ui/settings_ui.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Container(
        height: size.height * 0.9,
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.only(top: size.height * 0.04),
          child: StreamBuilder(
            initialData: null,
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.data is User) {
                return Container(
                  width: size.width,
                  child: Column(
                    children: profSetsLoggedIn(snapshot.data as User),
                  ),
                );
              } else {
                return Container(
                  width: size.width,
                  child: Column(
                    children: profSetsNotLoggedIn(),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  List<Widget> profSetsLoggedIn(User user) {
    var size = MediaQuery.of(context).size;
    return [
      Text(
        'Profile',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20.0,
        ),
      ),
      Container(
        height: size.height * 0.15,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: size.width * 0.05),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  height: size.height * 0.1,
                  child: CircleAvatar(
                    child: Icon(Icons.person),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: size.width * 0.05),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  height: size.height * 0.05,
                  child: Text(
                    "Email: " + user.email.toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      GestureDetector(
        onTap: () {
          AuthService(FirebaseAuth.instance).signOut();
        },
        child: Column(
          children: [
            Divider(
              thickness: 1.0,
              color: Colors.black,
            ),
            Padding(
              padding: EdgeInsets.only(top: size.height * 0.02, bottom: size.height * 0.02),
              child: Container(
                height: size.height * 0.03,
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: size.width * 0.05),
                      child: Container(
                        width: size.width * 0.8,
                        child: Text('Log Out'),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(),
                      child: Container(
                        width: size.width * 0.1,
                        child: Icon(Icons.arrow_forward),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Divider(
              thickness: 1.0,
              color: Colors.black,
            ),
          ],
        ),
      ),
    ];
  }

  List<Widget> profSetsNotLoggedIn() {
    var size = MediaQuery.of(context).size;
    return [
      Text(
        'Profile',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20.0,
        ),
      ),
      GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) => LoginScreen()));
        },
        child: Container(
          height: size.height * 0.04,
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: size.width * 0.05),
                child: Container(
                  width: size.width * 0.8,
                  child: Text('Login'),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(),
                child: Container(
                  width: size.width * 0.1,
                  child: Icon(Icons.arrow_forward),
                ),
              ),
            ],
          ),
        ),
      ),
      // Container(
      //   width: size.width * 1,
      //   child: Divider(
      //     thickness: 1.0,
      //     color: Colors.black,
      //   ),
      // ),
      // GestureDetector(
      //   onTap: () {
      //     Navigator.of(context).push(MaterialPageRoute(builder: (_) => RegisterScreen()));
      //   },
      //   child: Container(
      //     height: size.height * 0.04,
      //     child: Row(
      //       children: [
      //         Padding(
      //           padding: EdgeInsets.only(left: size.width * 0.05),
      //           child: Container(
      //             width: size.width * 0.8,
      //             child: Text('Register'),
      //           ),
      //         ),
      //         Padding(
      //           padding: EdgeInsets.only(),
      //           child: Container(
      //             width: size.width * 0.1,
      //             child: Icon(Icons.arrow_forward),
      //           ),
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
      // Container(
      //   width: size.width * 1,
      //   child: Divider(
      //     thickness: 1.0,
      //     color: Colors.black,
      //   ),
      // ),
    ];
  }
}
