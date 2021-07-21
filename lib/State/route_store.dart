import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mobx/mobx.dart';
import 'package:navigation_app/Models/graph.dart';
import 'package:navigation_app/Services/mapbox_service.dart';
import 'package:flutter/material.dart';

part 'route_store.g.dart';

class RouteStore extends _RouteStore with _$RouteStore {
  static final RouteStore _routeStore = RouteStore._internal();

  factory RouteStore() {
    return _routeStore;
  }

  RouteStore._internal();
}

abstract class _RouteStore with Store {
  @observable
  Map<int, List<String>> locs = new Map<int, List<String>>();

  @observable
  Map<int, Location> coords = new Map();

  @observable
  List<SpecialVertex> optiRoute = [];

  @observable
  Location startLoc =
      Location(timestamp: DateTime.now(), latitude: 0.0, longitude: 0.0);

  @observable
  List<String> startName = [];

  @observable
  var progressOverlay = false;

  @observable
  var curStep = 0;

  @action
  void flipOverlay() {
    progressOverlay = !progressOverlay;
  }

  @action
  void nextStep() {
    curStep++;
  }

  @observable
  Location curLoc =
      Location(timestamp: DateTime.now(), latitude: 0.0, longitude: 0.0);
}
