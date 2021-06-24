import 'package:flutter/material.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:navigation_app/UI/Views/Search_Screen.dart';
import 'package:navigation_app/State/route_store.dart';

class RouteScreen extends StatefulWidget {
  @override
  _RouteScreenState createState() => _RouteScreenState();
}

class _RouteScreenState extends State<RouteScreen> {
  RouteStore _routeStore = RouteStore();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: size.height * 0.3,
                ),
                child: Container(
                  height: size.height * 0.6,
                  child: ReorderableListView(
                    children: List<Widget>.generate(_routeStore.route.length,
                        (index) {
                      return ListTile(
                        leading: Icon(Icons.location_pin),
                        title: Text(''),
                      );
                    }),
                    onReorder: (before, after) {},
                  ),
                ),
              )
            ],
          ),
          Container(
            child: Hero(
              tag: 'SearchBar',
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => SearchScreen(),
                  ));
                },
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: EdgeInsets.only(top: size.height * 0.03),
                    child: IgnorePointer(
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
                        onFocusChanged: (focus) {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => SearchScreen(),
                          ));
                        },
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
        ],
      ),
    );
  }
}
