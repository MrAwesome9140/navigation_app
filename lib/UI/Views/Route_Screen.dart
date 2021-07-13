import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:navigation_app/UI/Views/Search_Screen.dart';
import 'package:navigation_app/State/route_store.dart';
import 'package:flutter_switch/flutter_switch.dart';

class RouteScreen extends StatefulWidget {

  const RouteScreen({Key? key}) : super(key: key);

  @override
  _RouteScreenState createState() => _RouteScreenState();
}

class _RouteScreenState extends State<RouteScreen> {
  bool _switch1State = false;
  bool _switch2State = false;
  RouteStore _routeStore = RouteStore();

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
                _locationsDisplay(size),
              ],
            ),
          ),
          _searchBar(size),
        ],
      ),
    );
  }

  Widget _startLocation(Size size) {
    return Container();
  }

  Widget _locationsDisplay(Size size) {
    return Container(
      decoration: BoxDecoration(color: Colors.grey),
      height: size.height * 0.3,
      child: ReorderableListView(
        children: List<Widget>.generate(_routeStore.route.length, (index) {
          return Container(
            height: size.height * 0.09,
            child: ListTile(
              tileColor: Colors.blue,
              leading: Icon(Icons.location_pin),
              title: Builder(
                builder: (cont) {
                  var loc = _routeStore.locs[_routeStore.route[index]];
                  return Text(loc!.first);
                },
              ),
            ),
          );
        }),
        onReorder: (before, after) {},
      ),
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
          padding: EdgeInsets.only(top: size.height * 0.03),
          child: SizedBox(
            height: size.height * 0.07,
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
