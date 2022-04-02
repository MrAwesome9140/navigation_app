import 'package:expandable/expandable.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mapbox_navigation/library.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:geocoding/geocoding.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:mobx/mobx.dart';
import 'package:navigation_app/Models/graph.dart';
import 'package:navigation_app/Services/mapbox_service.dart';
import 'package:navigation_app/UI/Views/Navigation_Screen.dart';
import 'package:navigation_app/UI/Views/Search_Screen.dart';
import 'package:navigation_app/State/route_store.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:reorderables/reorderables.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';

class RouteScreen extends StatefulWidget {
  const RouteScreen({Key? key}) : super(key: key);

  @override
  _RouteScreenState createState() => _RouteScreenState();
}

class _RouteScreenState extends State<RouteScreen> {
  var _switch1State = false;
  bool _switch2State = false;
  RouteStore _routeStore = RouteStore();
  late MapBoxService _mapBoxService;
  late MapBoxNavigation _directions;
  late MapBoxOptions _options;
  late NavigatorState _navigator;

  @override
  void didChangeDependencies() {
    _navigator = Navigator.of(context);
    super.didChangeDependencies();
  }

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

    _directions = MapBoxNavigation();
    _mapBoxService = MapBoxService(context: context);
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
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height * 0.91,
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: size.height * 0,
              ),
              child: Column(
                children: [
                  _searchBar(size),
                  _routeSettings(size),
                  _startLocation(size),
                  _locationsDisplay(size),
                  _startButton(size),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _startLocation(Size size) {
    return Container(
      height: size.height * 0.16,
      width: size.width * 0.9,
      color: Colors.transparent,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: size.height * 0.03),
            child: SizedBox(
              height: size.height * 0.06,
              width: size.width * 0.85,
              child: Text(
                'Start Location',
                style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          Container(
            height: size.height * 0.07,
            decoration: BoxDecoration(border: Border.all(color: Colors.black, width: 2.0)),
            child: Row(
              children: [
                Container(
                  width: size.width * 0.15,
                  child: Center(child: Icon(Icons.location_pin)),
                ),
                Container(
                  width: size.width * 0.68,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(top: size.height * 0.01),
                          child: Observer(
                            builder: (_) => Text(
                              _routeStore.startName.length != 0 ? _routeStore.startName[0] : "",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(top: size.height * 0.0045),
                          child: Observer(
                            builder: (_) => Text(
                              _routeStore.startName.length != 0 ? _routeStore.startName[1] : "",
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _startButton(Size size) {
    return Padding(
      padding: EdgeInsets.only(top: size.height * 0.02),
      child: Container(
        height: size.height * 0.1,
        width: size.width,
        color: Colors.transparent,
        child: ElevatedButton(
          style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.green[200])),
          onPressed: () async {
            if (_switch1State) {
              _routeStore.curStep = 0;
              Future<void> dialog = showGeneralDialog(
                context: context,
                barrierColor: Colors.black26.withOpacity(0.4),
                barrierDismissible: false,
                barrierLabel: 'Progress',
                transitionDuration: Duration(milliseconds: 500),
                pageBuilder: (c, __, ___) {
                  return OverlayView(highCont: context);
                },
              );
              List<Location> _fullCoords = [_routeStore.startLoc];
              _fullCoords.addAll(_routeStore.coords);
              List<SpecialVertex> _optiRoute = await _mapBoxService.getOptimalPath(_fullCoords);
              List<Location> _optimal = [];
              List<List<String>> _optiNames = [];
              for (int i = 1; i < _optiRoute.length; i++) {
                _optimal.add(_routeStore.coords[_optiRoute[i].label - 1]);
                _optiNames.add(_routeStore.locs[_optiRoute[i].label - 1]);
              }
              _routeStore.locs = ObservableList.of(_optiNames);
              _routeStore.coords = ObservableList.of(_optimal);
            }
            List<WayPoint> route = [];
            route.add(new WayPoint(name: _routeStore.startName[0], latitude: _routeStore.startLoc.latitude, longitude: _routeStore.startLoc.longitude));
            for (int i = 0; i < _routeStore.locs.length; i++) {
              route.add(new WayPoint(name: _routeStore.locs[i][0], latitude: _routeStore.coords[i].latitude, longitude: _routeStore.coords[i].longitude));
            }
            if (_switch2State) {
              route.add(new WayPoint(name: _routeStore.startName[0], latitude: _routeStore.startLoc.latitude, longitude: _routeStore.startLoc.longitude));
            }
            await _directions.startNavigation(wayPoints: route, options: _options);
          },
          child: Text(
            'Start Route',
            style: TextStyle(fontSize: 20.0),
          ),
        ),
      ),
    );
  }

  Widget _locationsDisplay(Size size) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: size.height * 0.03),
          child: SizedBox(
            height: size.height * 0.06,
            width: size.width * 0.85,
            child: Text(
              'Route',
              style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(),
          child: Container(
            decoration: BoxDecoration(color: Colors.blue[100]),
            height: size.height * 0.2,
            child: Observer(
              builder: (_) => ReorderableListView.builder(
                scrollController: ScrollController(initialScrollOffset: 12),
                onReorder: (int oldIndex, int newIndex) {
                  List<String> tempPos = _routeStore.locs[oldIndex];
                  Location tempLoc = _routeStore.coords[oldIndex];
                  _routeStore.locs[oldIndex] = _routeStore.locs[newIndex];
                  _routeStore.coords[oldIndex] = _routeStore.coords[newIndex];
                  _routeStore.locs[newIndex] = tempPos;
                  _routeStore.coords[newIndex] = tempLoc;
                },
                itemCount: _routeStore.locs.length,
                itemBuilder: (context, index) {
                  return Padding(
                    key: Key(index.toString()),
                    padding: EdgeInsets.only(), //EdgeInsets.only(top: size.height * 0.005, bottom: size.height * 0.005),
                    child: Container(
                      color: Colors.blue[100],
                      child: ExpansionTile(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(),
                            child: Container(
                              height: size.height * 0.05,
                              width: size.width * 0.9,
                              child: Align(
                                alignment: Alignment.center,
                                child: ElevatedButton(
                                  onPressed: () {
                                    List<String>? _locName = _routeStore.locs[index];
                                    Location? _locLocation = _routeStore.coords[index];
                                    if (_routeStore.startName.length > 0) {
                                      _routeStore.locs.add(_routeStore.startName);
                                      _routeStore.coords.add(_routeStore.startLoc);
                                    }
                                    var temp = _routeStore.locs.length;
                                    for (int i = index + 1; i < temp; i++) {
                                      List<String> _locName = _routeStore.locs[i];
                                      Location _locLocation = _routeStore.coords[i];
                                      _routeStore.locs[i - 1] = _locName;
                                      _routeStore.coords[i - 1] = _locLocation;
                                    }
                                    print(_routeStore.locs.length);
                                    _routeStore.locs.removeAt(_routeStore.locs.length - 1);
                                    print(_routeStore.coords.length);
                                    _routeStore.coords.removeAt(_routeStore.coords.length - 1);
                                    _routeStore.startName = ObservableList.of(_locName);
                                    _routeStore.startLoc = _locLocation;
                                  },
                                  child: Text('Set as Start Location'),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(),
                            child: Container(
                              height: size.height * 0.05,
                              width: size.width * 0.9,
                              child: Align(
                                alignment: Alignment.center,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.red,
                                  ),
                                  onPressed: () {
                                    for (int i = index + 1; i < _routeStore.locs.length; i++) {
                                      List<String> _locName = _routeStore.locs[i];
                                      Location _locLocation = _routeStore.coords[i];
                                      _routeStore.locs[i - 1] = _locName;
                                      _routeStore.coords[i - 1] = _locLocation;
                                    }
                                    _routeStore.locs.removeAt(_routeStore.locs.length - 1);
                                    _routeStore.coords.removeAt(_routeStore.coords.length - 1);
                                  },
                                  child: Text('Delete Location'),
                                ),
                              ),
                            ),
                          ),
                        ],
                        title: Column(
                          children: [
                            SizedBox(
                              height: index == 0 ? size.height * 0.006 : 0,
                            ),
                            Container(
                              height: size.height * 0.08,
                              child: Row(
                                children: [
                                  Container(
                                    width: size.width * 0.1,
                                    child: Padding(
                                      padding: EdgeInsets.only(bottom: size.height * 0.015),
                                      child: Icon(Icons.location_pin),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: size.width * 0.02, top: size.height * 0.01),
                                    child: Container(
                                      width: size.width * 0.665,
                                      child: Column(
                                        children: [
                                          Container(
                                            width: size.width * 0.8,
                                            height: size.height * 0.03,
                                            child: Observer(
                                              builder: (_) {
                                                return Text(
                                                  _routeStore.locs[index][0],
                                                  style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500),
                                                );
                                              },
                                            ),
                                          ),
                                          Container(
                                            width: size.width * 0.8,
                                            height: size.height * 0.03,
                                            child: Observer(
                                              builder: (_) => Text(
                                                _routeStore.locs[index][1],
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize: 12.0,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Divider(
                              height: size.height * 0.005,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _searchBar(Size size) {
    return Padding(
      padding: EdgeInsets.only(top: size.height * 0.02),
      child: Align(
        alignment: Alignment.topCenter,
        child: GestureDetector(
          behavior: HitTestBehavior.deferToChild,
          onTap: () {
            _navigator.push(MaterialPageRoute(
              builder: (_) => SearchScreen(),
            ));
          },
          child: Container(
            height: size.height * 0.12,
            width: size.width,
            child: AbsorbPointer(
              child: FloatingSearchBar(
                hint: 'Add Locations...',
                //scrollPadding: EdgeInsets.only(top: 16, bottom: 56),
                transitionDuration: const Duration(milliseconds: 800),
                transitionCurve: Curves.easeInOut,
                transition: ExpandingFloatingSearchBarTransition(),
                physics: const BouncingScrollPhysics(),
                height: size.height * 0.12,
                width: size.width * 0.85,
                debounceDelay: const Duration(milliseconds: 500),
                onQueryChanged: (query) {},
                onFocusChanged: (focus) {},
                leadingActions: [],
                builder: (context, transition) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Material(
                      color: Colors.white,
                      elevation: 4.0,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: Colors.accents.map((color) {
                          return Container(height: 112, color: color);
                        }).toList(),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _routeSettings(Size size) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: size.height * 0.03),
          child: SizedBox(
            height: size.height * 0.05,
            width: size.width * 0.85,
            child: Text(
              'Route Settings',
              style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(),
          child: Column(
            children: [
              Container(
                height: size.height * 0.06,
                width: size.width * 0.9,
                child: ListTile(
                  leading: Icon(Icons.settings),
                  title: Container(
                    width: size.width * 0.6,
                    child: Text(
                      'Optimize Route',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                  trailing: Switch(
                    value: _switch1State,
                    onChanged: (val) {
                      setState(() {
                        _switch1State = val;
                      });
                    },
                  ),
                ),
              ),
              Container(
                height: size.height * 0.06,
                width: size.width * 0.9,
                child: ListTile(
                  leading: Icon(Icons.location_pin),
                  title: Container(
                    width: size.width * 0.6,
                    child: Text(
                      'End at Start Location',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                  trailing: Switch(
                    value: _switch2State,
                    onChanged: (val) {
                      setState(() {
                        _switch2State = val;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class OverlayView extends StatelessWidget {
  BuildContext highCont;
  var widgetOpacity = 0.0;

  OverlayView({Key? key, required this.highCont}) : super(key: key);

  final RouteStore _routeStore = RouteStore();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Observer(
      builder: (_) => Center(
        child: Container(
          color: Colors.white,
          height: size.height * 0.3,
          width: size.width * 0.7,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: size.height * 0.02),
                child: Container(
                  width: size.width * 0.6,
                  height: size.height * 0.1,
                  child: Text(
                    'Route Optimization Progress',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              Container(
                height: size.height * 0.08,
                width: size.width * 0.6,
                child: Observer(
                  builder: (_) {
                    if (_routeStore.curStep == 6) {
                      Future.delayed(Duration(milliseconds: 800), () {
                        Navigator.pop(context);
                      });
                    }
                    return StepProgressIndicator(
                      selectedColor: Colors.blue,
                      unselectedColor: Colors.grey,
                      totalSteps: 6,
                      currentStep: _routeStore.curStep,
                      selectedSize: 12,
                      unselectedSize: 8,
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: size.height * 0.02),
                child: Container(
                  height: size.height * 0.05,
                  width: size.width * 0.6,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Cancel'),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
