import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:navigation_app/UI/Views/Home_Screen.dart';
import 'package:navigation_app/UI/Views/Route_Screen.dart';
import 'package:navigation_app/UI/Views/Search_Screen.dart';
import 'package:navigation_app/UI/Views/Settings_Screen.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class CentralScreen extends StatefulWidget {
  const CentralScreen({Key? key}) : super(key: key);

  @override
  _CentralScreenState createState() => _CentralScreenState();
}

class _CentralScreenState extends State<CentralScreen> {
  late PersistentTabController _controller;
  late bool _hideNavBar;
  int _curIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = PersistentTabController(initialIndex: 0);
    _hideNavBar = false;
  }

  List<Widget> _buildScreens() {
    return [
      HomeScreen(),
      RouteScreen(),
      SettingsScreen(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        textStyle: TextStyle(fontSize: 15.0),
        iconSize: 32.0,
        icon: Icon(Icons.home),
        title: 'Home',
        activeColorPrimary: Colors.white,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        textStyle: TextStyle(fontSize: 15.0),
        iconSize: 32.0,
        icon: Icon(Icons.location_pin),
        title: 'Create Route',
        activeColorPrimary: Colors.white,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        textStyle: TextStyle(fontSize: 15.0),
        iconSize: 32.0,
        icon: Icon(Icons.settings),
        title: 'Settings',
        activeColorPrimary: Colors.white,
        inactiveColorPrimary: Colors.grey,
      ),
    ];
  }

  List<BottomNavigationBarItem> _navItems() {
    return [
      BottomNavigationBarItem(
        label: '',
        icon: Icon(Icons.home),
        activeIcon: Icon(Icons.home_filled),
      ),
      BottomNavigationBarItem(
        label: '',
        icon: Icon(Icons.settings),
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Navigation App",
          style: TextStyle(
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      // body: _buildScreens()[_curIndex],
      // bottomNavigationBar: BottomNavigationBar(
      //   type: BottomNavigationBarType.shifting,
      //   selectedItemColor: Colors.green,
      //   unselectedItemColor: Colors.grey,
      //   items: _navItems(),
      //   onTap: (index) {
      //     setState(() {
      //       _curIndex = index;
      //     });
      //   },
      // ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {},
      // ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: PersistentTabView(
        context,
        controller: _controller,
        screens: _buildScreens(),
        items: _navBarsItems(),
        confineInSafeArea: true,
        backgroundColor: Colors.white,
        handleAndroidBackButtonPress: true,
        resizeToAvoidBottomInset: true,
        stateManagement: true,
        navBarHeight: size.height * 0.1,
        hideNavigationBarWhenKeyboardShows: true,
        margin: EdgeInsets.all(0.0),
        bottomScreenMargin: 0.0,
        onWillPop: (cont) async {
          await showDialog(
            context: context,
            useSafeArea: true,
            builder: (con) => Container(
              height: 50.0,
              width: 50.0,
              color: Colors.white,
              child: ElevatedButton(
                child: Text("Close"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          );
          return false;
        },
        selectedTabScreenContext: (context) {},
        hideNavigationBar: _hideNavBar,
        decoration: NavBarDecoration(
          gradient: LinearGradient(
              colors: [Color(0xffee0290), Color(0xfff186c0)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter),
          borderRadius: BorderRadius.circular(20.0),
        ),
        popAllScreensOnTapOfSelectedTab: true,
        itemAnimationProperties: ItemAnimationProperties(
          duration: Duration(milliseconds: 400),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: ScreenTransitionAnimation(
            animateTabTransition: true,
            curve: Curves.ease,
            duration: Duration(milliseconds: 200)),
        navBarStyle: NavBarStyle.style9,
      ),
    );
  }
}
