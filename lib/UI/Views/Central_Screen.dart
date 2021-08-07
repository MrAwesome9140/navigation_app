import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:navigation_app/Services/location_service.dart';
import 'package:navigation_app/State/route_store.dart';
import 'package:navigation_app/UI/Views/Home_Screen.dart';
import 'package:navigation_app/UI/Views/Route_Screen.dart';
import 'package:navigation_app/UI/Views/Settings_Screen.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class CentralScreen extends StatefulWidget {
  const CentralScreen({Key? key}) : super(key: key);

  @override
  _CentralScreenState createState() => _CentralScreenState();
}

class _CentralScreenState extends State<CentralScreen> {
  late PersistentTabController _controller;
  late bool _hideNavBar;
  int _curIndex = 0;
  final _locationService = LocationService();
  final RouteStore _routeStore = new RouteStore();

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
        iconSize: 28.0,
        icon: Icon(Icons.home),
        title: 'Home',
        activeColorPrimary: Colors.green,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        textStyle: TextStyle(fontSize: 15.0),
        iconSize: 27.0,
        icon: Icon(Icons.location_pin),
        title: 'Route',
        activeColorPrimary: Colors.green,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        textStyle: TextStyle(fontSize: 15.0),
        iconSize: 28.0,
        icon: Icon(Icons.settings),
        title: 'Settings',
        activeColorPrimary: Colors.green,
        inactiveColorPrimary: Colors.grey,
      ),
    ];
  }

  List<BottomNavigationBarItem> _navItems() {
    return [
      BottomNavigationBarItem(
        label: '',
        icon: Icon(
          Icons.home,
          size: 10.0,
        ),
        activeIcon: Icon(Icons.home_filled),
      ),
      BottomNavigationBarItem(
        label: '',
        icon: Icon(Icons.settings),
      )
    ];
  }

  Future<Location> getLocation() async {
    Geolocator.getPositionStream().listen((event) {
      _routeStore.curLoc = Location(timestamp: DateTime.now(), latitude: event.latitude, longitude: event.longitude);
    });
    var locs = await _locationService.determinePosition();
    var loc = Location(
      timestamp: DateTime.now(),
      latitude: locs.latitude,
      longitude: locs.longitude,
    );
    _routeStore.curLoc = loc;
    return loc;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Stack(
      children: [
        FutureBuilder(
          future: getLocation(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Scaffold(
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
                  navBarHeight: size.height * 0.07,
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
                    colorBehindNavBar: Colors.white,
                  ),
                  popAllScreensOnTapOfSelectedTab: true,
                  itemAnimationProperties: ItemAnimationProperties(
                    duration: Duration(milliseconds: 400),
                    curve: Curves.ease,
                  ),
                  screenTransitionAnimation: ScreenTransitionAnimation(animateTabTransition: true, curve: Curves.ease, duration: Duration(milliseconds: 200)),
                  navBarStyle: NavBarStyle.style9,
                ),
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ],
    );
  }
}
