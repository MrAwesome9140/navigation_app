import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hexcolor/hexcolor.dart' as hex;
import 'package:http/http.dart' as http;
import 'package:navigation_app/State/route_store.dart';
import '../Models/graph.dart';
import 'graph_operations.dart';

class MapBoxService {
  final String _baseUrl = "api.mapbox.com";
  final String _mapBoxKey = "pk.eyJ1IjoibXJhd2Vzb21lOTEwNCIsImEiOiJja3Bibm94eWMwenFoMnVueGFpdWQ4YW4zIn0.LLg54LGkURVdJeORIdo9MA";
  late List<SpecialVertex> optimalPath;
  late double weights;
  RouteStore _routeStore = RouteStore();
  BuildContext context;

  MapBoxService({required this.context});

  Future<List<http.Response>> getDirections(List<Location> coords) async {
    Map<String, String> props = new Map<String, String>();
    List<Uri> urls = [];

    props["access_token"] = _mapBoxKey;
    props["overview"] = "full";
    props["geometries"] = "geojson";
    props["steps"] = "true";
    props["banner_instructions"] = "true";
    final StringBuffer _baseExtension = new StringBuffer("/directions/v5/mapbox/driving/");
    for (int i = 0; i < math.min(coords.length, 25); i++) {
      _baseExtension.write("${coords[i].longitude},${coords[i].latitude};");
    }
    final StringBuffer _baseExtension2 = new StringBuffer("/directions/v5/mapbox/driving/");
    for (int i = 25; i < coords.length; i++) {
      _baseExtension2.write("${coords[i].longitude},${coords[i].latitude};");
    }

    urls.add(Uri.https(_baseUrl, _baseExtension.toString().substring(0, _baseExtension.length - 1), props));
    coords.length > 25 ? urls.add(Uri.https(_baseUrl, _baseExtension2.toString().substring(0, _baseExtension2.length - 1), props)) : print("");
    var responses = await Future.wait(urls.map((e) => http.get(e)));

    return responses;
  }

  Future<List<SpecialVertex>> getOptimalPath(List<Location> coords) async {
    GraphOperations ops = GraphOperations();
    Graph matrix = await getMatrix(coords);
    _routeStore.nextStep();
    await Future.delayed(Duration(milliseconds: 500));
    List<Edge> mst = ops.mst(matrix);
    _routeStore.nextStep();
    await Future.delayed(Duration(milliseconds: 500));
    Graph oddies = ops.oddDegreeVertGraph(mst, matrix);
    _routeStore.nextStep();
    await Future.delayed(Duration(milliseconds: 500));
    List<Edge> perfectMatch = ops.minWeightPerfectMatch(oddies);
    _routeStore.nextStep();
    await Future.delayed(Duration(milliseconds: 500));
    Graph multiGraph = ops.uniteMinSpanAndPerMatch(matrix, mst, perfectMatch);
    _routeStore.nextStep();
    await Future.delayed(Duration(milliseconds: 500));
    List<SpecialVertex> fin = ops.optimumTour(multiGraph);
    _routeStore.nextStep();
    await Future.delayed(Duration(milliseconds: 500));
    return fin;
  }

  Graph createGraph(http.Response matrix, Graph myGraph) {
    http.Response first = matrix;
    List<SpecialVertex> verts = myGraph.vertices;
    print(first.body);
    var initData = json.decode(first.body);
    var initDurations = initData["durations"] as List<dynamic>;
    var nums = List<List<bool>>.generate(verts.length, (i) => List.generate(verts.length, (_) => false), growable: false);
    for (int i = 0; i < initDurations.length; i++) {
      var tempDur = initDurations[i];
      for (int k = 0; k < tempDur.length; k++) {
        if (k != i) {
          if (!nums[i][k]) {
            myGraph.addEdge(verts[i], verts[k], (initDurations[i][k] + initDurations[k][i]) / 2);
            nums[i][k] = true;
            nums[k][i] = true;
          }
        }
      }
    }
    return myGraph;
  }

  Future<Graph> getMatrix(List<Location> coords) async {
    Graph myGraph = new Graph();
    for (int i = 0; i < coords.length; i++) {
      myGraph.addVertex(new SpecialVertex(label: i));
    }
    final String _baseMapBox = "api.mapbox.com";
    StringBuffer _extension = new StringBuffer("/directions-matrix/v1/mapbox/driving/");
    coords.forEach((element) {
      _extension.write("${element.longitude},${element.latitude};");
    });

    Map<String, String> _params = new Map();
    _params["access_token"] = _mapBoxKey;

    var response = await http.get(Uri.https(_baseMapBox, _extension.toString().substring(0, _extension.length - 1), _params));
    return createGraph(response, myGraph);
  }

  Future<List<List<String>>> getSearchResults(String text, Position curLoc) async {
    var params = Map<String, String>();
    List<String> placeNames = [];
    List<String> addresses = [];

    String _extension = "/geocoding/v5/mapbox.places/$text.json";
    params["access_token"] = _mapBoxKey;
    params["autocomplete"] = "true";
    params["proximity"] = "${curLoc.longitude},${curLoc.latitude}";

    var response = await http.get(Uri.https(_baseUrl, _extension, params));
    var decoded = json.decode(response.body);
    print(decoded.toString());
    var features = decoded["features"] as List<dynamic>;
    features.forEach((element) {
      placeNames.add(element["text"]);
      addresses.add(element["place_name"]);
    });
    return [placeNames, addresses];
  }

  Future<String> testStuff(String url) async {
    var response = await http.get(Uri.parse(url));
    print(response.body);
    print("hi");
    return response.body;
  }

  String getStaticMapImage(Location center, double width, double height, int zoomLevel) {
    String temp = "https://$_baseUrl/styles/v1/mapbox/streets-v11/static/pin-l+000024(${center.longitude},${center.latitude})/${center.longitude},${center.latitude},$zoomLevel/${width.toInt()}x${height.toInt()}@2x?access_token=$_mapBoxKey&logo=false";
    //testStuff(temp);
    return temp;
  }

  String htmlColorNotation(Color color) => color.red.toInt().toRadixString(16) + color.green.toInt().toRadixString(16) + color.blue.toInt().toRadixString(16);
}
