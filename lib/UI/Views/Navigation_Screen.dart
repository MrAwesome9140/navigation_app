import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mapbox_navigation/library.dart';
import 'package:navigation_app/State/route_store.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({Key? key}) : super(key: key);

  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  late MapBoxNavigation _directions;
  double _distanceRemaining = 0.0;
  double _durationRemaining = 0.0;
  bool _arrived = false;
  String _instruction = "";
  bool _routeBuilt = false;
  bool _isNavigating = false;
  bool _isMultipleStop = false;
  String _platformVersion = "";
  late final MapBoxNavigationViewController _controller;
  late MapBoxOptions _options;
  RouteStore _routeStore = RouteStore();

  @override
  void initState() {
    super.initState();
    initialize();
  }

  Future<void> initialize() async {
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    _directions = MapBoxNavigation(onRouteEvent: _onRouteEvent);
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
      simulateRoute: false,
      animateBuildRoute: true,
      longPressDestinationEnabled: true,
      language: "en",
    );

    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await _directions.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  Future<void> _onRouteEvent(e) async {
    //_distanceRemaining = await _directions.distanceRemaining;
    //_durationRemaining = await _directions.durationRemaining;

    //switch (e.eventType) {
    //   case MapBoxEvent.progress_change:
    //     var progressEvent = e.data as RouteProgressEvent;
    //     _arrived = progressEvent.arrived!;
    //     if (progressEvent.currentStepInstruction != null) _instruction = progressEvent.currentStepInstruction!;
    //     break;
    //   case MapBoxEvent.route_building:
    //   case MapBoxEvent.route_built:
    //     _routeBuilt = true;
    //     break;
    //   case MapBoxEvent.route_build_failed:
    //     _routeBuilt = false;
    //     break;
    //   case MapBoxEvent.navigation_running:
    //     _isNavigating = true;
    //     break;
    //   case MapBoxEvent.on_arrival:
    //     _arrived = true;
    //     if (!_isMultipleStop) {
    //       await Future.delayed(Duration(seconds: 3));
    //       await _controller.finishNavigation();
    //     } else {}
    //     break;
    //   case MapBoxEvent.navigation_finished:
    //   case MapBoxEvent.navigation_cancelled:
    //     _routeBuilt = false;
    //     _isNavigating = false;
    //     break;
    //   default:
    //     break;
    // }
    // //refresh UI
    // setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MapBoxNavigationView(
        options: _options,
        onRouteEvent: _onRouteEvent,
        onCreated: (controller) async {
          _controller = controller;
          await _controller.initialize();
          List<WayPoint> route = [];
          route.add(new WayPoint(name: _routeStore.startName[0], latitude: _routeStore.startLoc.latitude, longitude: _routeStore.startLoc.longitude));
          for (int i = 0; i < _routeStore.locs.length; i++) {
            route.add(new WayPoint(name: _routeStore.locs[i][0], latitude: _routeStore.coords[i].latitude, longitude: _routeStore.coords[i].longitude));
          }
          _controller.buildRoute(wayPoints: route);
          _isMultipleStop = true;
          _controller.startNavigation();
        },
      ),
    );
  }
}