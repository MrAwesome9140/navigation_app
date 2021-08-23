import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:navigation_app/Services/auth_service.dart';
import 'package:navigation_app/UI/Views/Central_Screen.dart';
import 'package:navigation_app/UI/Views/Register_Screen.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String _tempUName = '';
  String _tempPass = '';

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Container(
          width: size.width * 0.7,
          child: Form(
            key: _formKey,
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
                      height: size.height * 0.03,
                      child: Text(
                        'Email Address',
                        style: TextStyle(
                          fontSize: 20.0,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: size.height * 0.04),
                  child: Container(
                    height: size.height * 0.05,
                    child: TextFormField(
                      textCapitalization: TextCapitalization.none,
                      validator: (val) => val!.isEmpty || !EmailValidator.validate(val) ? "Please enter a valid email address" : null,
                      decoration: InputDecoration(
                        hintText: 'Enter your email...',
                      ),
                      controller: _usernameController,
                      onChanged: (val) {
                        setState(() {
                          _tempUName = val;
                        });
                      },
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.only(top: size.height * 0.05),
                    child: Container(
                      height: size.height * 0.03,
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
                  padding: EdgeInsets.only(top: size.height * 0.04),
                  child: Container(
                    height: size.height * 0.05,
                    child: TextFormField(
                      obscureText: true,
                      validator: (val) => val!.isEmpty ? 'Please enter a password' : null,
                      decoration: InputDecoration(hintText: 'Enter your password...'),
                      controller: _passwordController,
                      onChanged: (val) {
                        setState(() {
                          _tempPass = val;
                        });
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: size.height * 0.06),
                  child: Container(
                    width: size.width * 0.7,
                    child: Row(
                      children: [
                        Container(
                          height: size.height * 0.06,
                          width: size.width * 0.3,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(Colors.green),
                              elevation: MaterialStateProperty.all(10.0),
                            ),
                            child: Text(
                              'Login',
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                String result = await context.read<AuthService>().signIn(email: _tempUName.trim(), password: _tempPass.trim());
                                if (result == 'Signed In') {
                                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => CentralScreen()));
                                } else {
                                  showGeneralDialog(
                                    context: context,
                                    pageBuilder: (_, __, ___) {
                                      return Material(
                                        type: MaterialType.transparency,
                                        child: Center(
                                          child: Container(
                                            color: Colors.white,
                                            height: size.height * 0.25,
                                            width: size.width * 0.7,
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(top: size.height * 0.04),
                                                  child: Container(
                                                    height: size.height * 0.1,
                                                    width: size.width * 0.55,
                                                    child: Text(
                                                      "Sign-In Failed. Make sure you have a registered account and try again.",
                                                      style: TextStyle(fontSize: 16.0),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(top: size.height * 0.015),
                                                  child: Container(
                                                    height: size.height*0.05,
                                                    width: size.width*0.5,
                                                    child: ElevatedButton(
                                                      onPressed: () {
                                                        Navigator.of(context).pop();
                                                      },
                                                      child: Text('Close'),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                }
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          width: size.width * 0.05,
                        ),
                        Container(
                          height: size.height * 0.06,
                          width: size.width * 0.3,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(Colors.orange),
                              elevation: MaterialStateProperty.all(10.0),
                            ),
                            child: Text(
                              'Register',
                              style: TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(builder: (_) => RegisterScreen()));
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
