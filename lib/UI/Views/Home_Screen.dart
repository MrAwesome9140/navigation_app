import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:navigation_app/Services/location_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:navigation_app/State/route_store.dart';
import 'package:navigation_app/UI/Views/Route_Screen.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  LocationService _locationService = LocationService();
  Completer<GoogleMapController> _controller = Completer();
  late Future<Position> _curLoc;
  RouteStore _routeStore = RouteStore();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // return FutureBuilder(
    //   future: _curLoc,
    //   builder: (context, data) {
    //     if (data.hasData) {
          return Scaffold(
            body: Stack(
              children: [
                Map(),
              ],
            ),
          );
    //     } else {
    //       return Center(child: CircularProgressIndicator());
    //     }
    //   },
    // );
  }

  Widget Map() {
    var pos = _routeStore.curLoc;
    //var loc = data.data as Position;
    return GoogleMap(
      onMapCreated: (controller) {
        _controller.complete(controller);
      },
      initialCameraPosition:
          CameraPosition(target: LatLng(pos.latitude, pos.longitude), zoom: 14),
    );
  }

  // Future<void> _goToCurrentLocation() async {
  //   final GoogleMapController controller = await _controller.future;
  //   controller
  // }
}
