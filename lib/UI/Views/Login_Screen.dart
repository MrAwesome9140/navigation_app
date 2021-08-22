import 'package:flutter/material.dart';
import 'package:navigation_app/UI/Views/Central_Screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  String _tempUName = '';
  String _tempPass = '';

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Container(
          width: size.width * 0.7,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: size.height * 0.15),
                child: Container(
                  height: size.height * 0.1,
                  child: Text(
                    'OptiRouter',
                    style: TextStyle(
                      fontSize: 40.0,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.only(top: size.height * 0.05),
                  child: Container(
                    height: size.height * 0.05,
                    child: Text(
                      'Username',
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: size.height * 0),
                child: Container(
                  height: size.height * 0.05,
                  child: TextFormField(
                    controller: _usernameController,
                    onChanged: (val) {
                      _tempUName = val;
                    },
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.only(top: size.height * 0.05),
                  child: Container(
                    height: size.height * 0.05,
                    child: Text(
                      'Password',
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: size.height * 0),
                child: Container(
                  height: size.height * 0.05,
                  child: TextFormField(
                    controller: _passwordController,
                    onChanged: (val) {
                      _tempPass = val;
                    },
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: size.height * 0.07),
                child: Container(
                  height: size.height * 0.06,
                  width: size.width * 0.5,
                  child: ElevatedButton(
                    child: Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (_) => CentralScreen()));
                    },
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: size.height * 0.03),
                child: Container(
                  height: size.height * 0.05,
                  width: size.width * 0.6,
                  child: Text(
                    'Create an account',
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.blue,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
