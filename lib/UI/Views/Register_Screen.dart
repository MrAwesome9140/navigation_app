import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:navigation_app/Services/auth_service.dart';
import 'package:navigation_app/UI/Views/Central_Screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _passCont = TextEditingController();
  final _userCont = TextEditingController();
  final _rePaCont = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var _tempPass = "";
  var _tempUName = "";
  var _tempRePass = '';

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
                  padding: EdgeInsets.only(top: size.height * 0.1),
                  child: Container(
                    height: size.height * 0.1,
                    width: size.width * 0.7,
                    child: Center(
                      child: Text(
                        'Registration',
                        style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
                      controller: _userCont,
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
                      validator: (val) => val!.isEmpty && val.length < 6 ? 'Password must be at least 6 characters long' : null,
                      decoration: InputDecoration(hintText: 'Enter your password...'),
                      controller: _passCont,
                      onChanged: (val) {
                        setState(() {
                          _tempPass = val;
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
                        'Re-enter Password',
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
                      validator: (val) => val != _tempPass ? 'Please re-enter a password' : null,
                      decoration: InputDecoration(hintText: 'Enter your password...'),
                      controller: _rePaCont,
                      onChanged: (val) {
                        setState(() {
                          _tempRePass = val;
                        });
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: size.height * 0.06),
                  child: Container(
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
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          var reg = await AuthService(FirebaseAuth.instance).signUp(email: _tempUName.trim(), password: _tempPass.trim());
                          if (reg == 'Signed Up') {
                            Future(
                              () {
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
                                                child: Center(
                                                  child: Container(
                                                    height: size.height * 0.15,
                                                    width: size.width * 0.6,
                                                    child: Center(
                                                      child: Text(
                                                        "You are registered! You will now be logged in",
                                                        style: TextStyle(
                                                          fontSize: 16.0,
                                                        ),
                                                      ),
                                                    ),
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
                              },
                            ).then(
                              (value) => Future.delayed(
                                Duration(seconds: 2),
                                () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            );
                          } else {
                            Future(
                              () {
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
                                                child: Center(
                                                  child: Container(
                                                    height: size.height * 0.15,
                                                    width: size.width * 0.6,
                                                    child: Center(
                                                      child: Text(
                                                        "Registration failed. Please try again.",
                                                        style: TextStyle(
                                                          fontSize: 16.0,
                                                        ),
                                                      ),
                                                    ),
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
                              },
                            ).then(
                              (value) => Future.delayed(
                                Duration(seconds: 2),
                                () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            );
                          }
                        }
                      },
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
