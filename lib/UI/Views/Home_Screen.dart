import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:navigation_app/Services/location_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:navigation_app/UI/Views/Route_Screen.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  LocationService _locationService = LocationService();
  Completer<GoogleMapController> _controller = Completer();
  late Future<Position> _curLoc;

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  void initState() {
    _curLoc = getLocation();
    super.initState();
  }

  Future<Position> getLocation() async {
    var loc = await _locationService.determinePosition();
    return loc;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _curLoc,
        builder: (context, data) {
          if (data.hasData) {
            return Scaffold(
              body: Stack(
                children: [
                  Map(data),
                ],
              ),
              // floatingActionButtonLocation:
              //     FloatingActionButtonLocation.centerDocked,
              // floatingActionButton: FloatingActionButton.extended(
              //     shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.all(Radius.circular(30.0))),
              //     onPressed: () {
              //       Navigator.of(context).push(_createRoute());
              //     },
              //     label: Text(
              //       "Create Route",
              //       style: TextStyle(fontSize: 20.0),
              //     ),
              // ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
    );
  }

  Route _createRoute() {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => RouteScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = Offset(0.0, 1.0);
          var end = Offset.zero;
          var curve = Curves.easeOutCubic;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
              position: animation.drive(tween), child: child);
        });
  }

  Widget Map(AsyncSnapshot<Object?> data) {
    var loc = data.data as Position;
    return GoogleMap(
      onMapCreated: (controller) {
        _controller.complete(controller);
      },
      initialCameraPosition:
          CameraPosition(target: LatLng(loc.latitude, loc.longitude), zoom: 14),
    );
  }

  // Future<void> _goToCurrentLocation() async {
  //   final GoogleMapController controller = await _controller.future;
  //   controller
  // }
}
