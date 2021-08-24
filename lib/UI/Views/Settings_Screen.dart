import 'package:flutter/material.dart';
import 'package:navigation_app/UI/Views/Login_Screen.dart';
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
          child: SettingsList(
            darkBackgroundColor: Colors.white24,
            lightBackgroundColor: Colors.white,
            sections: [
              SettingsSection(
                title: 'Profile',
                titleTextStyle: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                tiles: [
                  SettingsTile(
                    title: 'Login',
                    leading: Icon(Icons.login),
                    onPressed: (context) {
                      Navigator.of(context).push(MaterialPageRoute(builder: (_) => LoginScreen()));
                    },
                  ),
                  SettingsTile(
                    title: '',
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
