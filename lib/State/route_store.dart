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
  Position curLoc = Position(
      timestamp: null,
      latitude: 0.0,
      longitude: 0.0,
      heading: 0.0,
      speed: 0.0,
      speedAccuracy: 0.0,
      accuracy: 0.0,
      altitude: 0.0);
}
