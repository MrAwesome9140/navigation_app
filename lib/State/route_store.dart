import 'package:mobx/mobx.dart';
import 'package:navigation_app/Models/graph.dart';
import 'package:navigation_app/Services/mapbox_service.dart';
import 'package:flutter/material.dart';

part 'route_store.g.dart';

class RouteStore extends _RouteStore with _$RouteStore {
  RouteStore() : super();
}

abstract class _RouteStore with Store {

  _RouteStore();

  @observable
  List<SpecialVertex> route = [];

  @observable
  Map<String,List<String>> locs = new Map<String, List<String>>();

  
}
