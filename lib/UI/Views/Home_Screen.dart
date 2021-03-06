import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mapbox_navigation/library.dart';
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
  late MapBoxOptions _options;
  late MapBoxNavigationViewController _mapCotroller;

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  void initState() {
    super.initState();

    _options = MapBoxOptions(
      initialLatitude: _routeStore.curLoc.latitude,
      initialLongitude: _routeStore.curLoc.longitude,
      zoom: 16.0,
      tilt: 0.0,
      bearing: 0.0,
      enableRefresh: false,
      alternatives: true,
      voiceInstructionsEnabled: true,
      bannerInstructionsEnabled: true,
      allowsUTurnAtWayPoints: true,
      mode: MapBoxNavigationMode.drivingWithTraffic,
      units: VoiceUnits.imperial,
      simulateRoute: true,
      animateBuildRoute: true,
      longPressDestinationEnabled: false,
      language: "en",
      mapStyleUrlDay: "mapbox://styles/mrawesome9104/cks4ya82g0vy217mu0xpmger0",
      mapStyleUrlNight: "mapbox://styles/mrawesome9104/cks4y93u33j5817nzdxsecpcm",
      isOptimized: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var _height = MediaQuery.of(context).size.height -
    (MediaQuery.of(context).padding.bottom +
        MediaQuery.of(context).padding.top);
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: _height * 0.94,
            child: Map(),
          ),
        ],
      ),
    );
  }

  Widget Map() {
    var pos = _routeStore.curLoc;
    //var loc = data.data as Position;
    return GoogleMap(
      onMapCreated: (controller) {
        _controller.complete(controller);
      },
      initialCameraPosition: CameraPosition(target: LatLng(pos.latitude, pos.longitude), zoom: 14),
    );
    // return MapBoxNavigationView(
    //   options: _options,
    //   onCreated: (controller) {
    //     _routeStore.homeControlller = controller;
    //     _routeStore.homeControlller.initialize();
    //     debugPrintStack();
    //   },
    // );
  }
}
