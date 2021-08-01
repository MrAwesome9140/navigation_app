import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:geocoding/geocoding.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:mobx/mobx.dart';
import 'package:navigation_app/Models/graph.dart';
import 'package:navigation_app/Services/mapbox_service.dart';
import 'package:navigation_app/UI/Views/Search_Screen.dart';
import 'package:navigation_app/State/route_store.dart';
import 'package:flutter_switch/flutter_switch.dart';

class RouteScreen extends StatefulWidget {
  const RouteScreen({Key? key}) : super(key: key);

  @override
  _RouteScreenState createState() => _RouteScreenState();
}

class _RouteScreenState extends State<RouteScreen> {
  var _switch1State = false;
  bool _switch2State = false;
  RouteStore _routeStore = RouteStore();
  MapBoxService _mapBoxService = MapBoxService();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: size.height * 0.15,
            ),
            child: Column(
              children: [
                _routeSettings(size),
                _startLocation(size),
                _locationsDisplay(size),
                _startButton(size),
              ],
            ),
          ),
          _searchBar(size),
        ],
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
          Padding(
            padding: EdgeInsets.only(),
            child: Container(
              height: size.height * 0.07,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 2.0)),
            child: Row(
                children: [
                  Container(
                    width: size.width*0.15,
                    child: Center(child: Icon(Icons.location_pin)),
                  ),
                  Container(
                    width: size.width*0.68,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top:size.height*0.01),
                          child: Observer(
                            builder: (_) => Text(
                              _routeStore.startName.length != 0 ? _routeStore.startName[0]: "",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: size.height*0.0045),
                          child: Observer(
                            builder: (_) => Text(
                              _routeStore.startName.length != 0 ? _routeStore.startName[1]: "",
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _startButton(Size size) {
    return Padding(
      padding: EdgeInsets.only(top: size.height * 0.02),
      child: Container(
        height: size.height * 0.075,
        width: size.width,
        color: Colors.transparent,
        child: ElevatedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.green[200])),
          onPressed: () async {
            _routeStore.flipOverlay();
            var locs = _routeStore.coords.values as List<Location>;
            _routeStore.optiRoute = ObservableList.of(await _mapBoxService.getOptimalPath(locs));
            print('done');
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
            height: size.height * 0.25,
            child: Observer(
              builder: (_) => ListView(
                children: List<Widget>.generate(_routeStore.locs.length, (index) {
                  return Container(
                    key: Key(index.toString()),
                    height: size.height * 0.08,
                    child: Column(
                      children: [
                        Container(
                          child: Row(
                            children: [
                              Container(
                                height: size.height * 0.06,
                                width: size.width * 0.1,
                                child: Center(child: Icon(Icons.location_pin)),
                              ),
                              Container(
                                height: size.height * 0.06,
                                width: size.width * 0.8,
                                child: Column(
                                  children: [
                                    Container(
                                      width: size.width * 0.8,
                                      height: size.height * 0.03,
                                      child: Observer(
                                        builder: (_) => Text(
                                          _routeStore.locs[index]![0],
                                          style: TextStyle(
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: size.width * 0.8,
                                      height: size.height * 0.03,
                                      child: Observer(
                                        builder: (_) => Text(
                                          _routeStore.locs[index]![1],
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: size.height * 0.005,
                              bottom: size.height * 0.01),
                          child: Divider(
                            height: size.height * 0.005,
                          ),
                        )
                      ],
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _searchBar(Size size) {
    return Padding(
      padding: EdgeInsets.only(top: size.height * 0.03),
      child: Container(
        height: size.height * 0.09,
        child: Hero(
          tag: 'SearchBar',
          child: Align(
            alignment: Alignment.topCenter,
            child: GestureDetector(
              behavior: HitTestBehavior.deferToChild,
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => SearchScreen(),
                ));
              },
              child: Container(
                height: size.height * 0.09,
                child: AbsorbPointer(
                  child: FloatingSearchBar(
                    hint: 'Add Locations...',
                    scrollPadding: EdgeInsets.only(top: 16, bottom: 56),
                    transitionDuration: const Duration(milliseconds: 800),
                    transitionCurve: Curves.easeInOut,
                    transition: ExpandingFloatingSearchBarTransition(),
                    physics: const BouncingScrollPhysics(),
                    height: size.height * 0.06,
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
        ),
      ),
    );
  }

  Widget _routeSettings(Size size) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: size.height * 0.01),
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
