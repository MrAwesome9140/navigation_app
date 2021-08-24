import 'package:flutter_mapbox_navigation/library.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mobx/mobx.dart';
import 'package:navigation_app/Models/graph.dart';
import 'package:navigation_app/Services/mapbox_service.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

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
  MapBoxNavigationViewController homeControlller = MapBoxNavigationViewController(0, (event) {});

  @observable
  PersistentTabController controller = PersistentTabController();

  @observable
  ObservableList<List<String>> locs = new ObservableList<List<String>>();

  @computed
  int get locsLength => locs.length;

  @observable
  ObservableList<Location> coords = new ObservableList();

  @observable
  ObservableList<SpecialVertex> optiRoute = new ObservableList();

  @observable
  Location startLoc = Location(timestamp: DateTime.now(), latitude: 0.0, longitude: 0.0);

  @observable
  ObservableList<String> startName = new ObservableList();

  @observable
  var progressOverlay = false;

  @observable
  var curStep = 0;

  @observable
  var loggedIn = false;

  @action
  void flipOverlay() {
    progressOverlay = !progressOverlay;
  }

  @action
  void nextStep() {
    curStep++;
  }

  @observable
  Location curLoc = Location(timestamp: DateTime.now(), latitude: 0.0, longitude: 0.0);
}
