import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:mobx/mobx.dart';
import 'package:navigation_app/Services/mapbox_service.dart';
import 'package:navigation_app/State/route_store.dart';
import 'package:skeleton_text/skeleton_text.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  FloatingSearchBarController _controller = FloatingSearchBarController();
  MapBoxService _mapService = MapBoxService();
  String _autoText = "";
  RouteStore _routeStore = RouteStore();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey[400],
      body: Stack(
        children: [
          Container(
            child: Hero(
              tag: 'SearchBar',
              child: Padding(
                padding: EdgeInsets.only(top: size.height * 0.03),
                // child: searchBarUI()
                child: FloatingSearchBar(
                  elevation: 4.0,
                  openAxisAlignment: 0.0,
                  controller: _controller,
                  hint: 'Add Locations...',
                  scrollPadding: EdgeInsets.only(top: 16, bottom: 20),
                  transitionDuration: const Duration(milliseconds: 800),
                  transitionCurve: Curves.easeInOut,
                  transition: CircularFloatingSearchBarTransition(),
                  physics: BouncingScrollPhysics(),
                  height: size.height * 0.06,
                  width: size.width * 0.85,
                  debounceDelay: const Duration(milliseconds: 500),
                  onQueryChanged: (query) {
                    setState(() {
                      _autoText = query;
                    });
                  },
                  onFocusChanged: (focus) {},
                  actions: [
                    // FloatingSearchBarAction.back(
                    //   color: Colors.black,
                    // )
                  ],
                  builder: (context, transition) {
                    return _autoCompleteOptions();
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget searchBarUI() {
    return FloatingSearchBar(
      hint: 'Search.....',
      openAxisAlignment: 0.0,
      axisAlignment: 0.0,
      scrollPadding: EdgeInsets.only(top: 16, bottom: 20),
      elevation: 4.0,
      physics: BouncingScrollPhysics(),
      onQueryChanged: (query) {
        //Your methods will be here
      },
      transitionCurve: Curves.easeInOut,
      transitionDuration: Duration(milliseconds: 500),
      transition: CircularFloatingSearchBarTransition(),
      debounceDelay: Duration(milliseconds: 500),
      actions: [
        FloatingSearchBarAction(
          showIfOpened: false,
          child: CircularButton(
            icon: Icon(Icons.place),
            onPressed: () {
              print('Places Pressed');
            },
          ),
        ),
        FloatingSearchBarAction.searchToClear(
          showIfClosed: false,
        ),
      ],
      builder: (context, transition) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Material(
            color: Colors.white,
            child: Container(
              height: 200.0,
              color: Colors.white,
              child: Column(
                children: [
                  ListTile(
                    title: Text('Home'),
                    subtitle: Text('more info here........'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _autoCompleteOptions() {
    var size = MediaQuery.of(context).size;
    return Observer(
      builder: (BuildContext context) {
        if (_autoText == '') {
          return _tempSkeletonOptions(size);
        } else {
          return FutureBuilder(
              future:
                  _mapService.getSearchResults(_autoText, _routeStore.curLoc),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  var suggestions = snapshot.data as List<List<String>>;
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Material(
                      color: Colors.white,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: List<Widget>.generate(
                          5,
                          (index) {
                            return Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    _routeStore.locs[_routeStore.locs.length] =
                                        [
                                      suggestions[0][index],
                                      suggestions[1][index]
                                    ];
                                    _controller.close();
                                  },
                                  child: Container(
                                    color: Colors.transparent,
                                    height: size.height * 0.09,
                                    width: size.width * 0.9,
                                    child: ListTile(
                                      leading: Icon(Icons.location_pin),
                                      title: Padding(
                                        padding: EdgeInsets.only(
                                            top: size.height * 0.01),
                                        child: Container(
                                          child: Text(suggestions[0][index]),
                                          height: size.height * 0.022,
                                          width: size.width * 0.3,
                                          decoration: BoxDecoration(
                                            color: Colors.transparent,
                                          ),
                                        ),
                                      ),
                                      subtitle: Padding(
                                        padding: EdgeInsets.only(
                                            top: size.height * 0.014),
                                        child: Container(
                                          child: Text(suggestions[1][index]),
                                          decoration: BoxDecoration(
                                            color: Colors.transparent,
                                          ),
                                          height: size.height * 0.022,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Divider(
                                  height: size.height * 0.005,
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  );
                } else {
                  return _tempSkeletonOptions(size);
                }
              });
        }
      },
    );
  }

  Widget _tempSkeletonOptions(Size size) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: Material(
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: List<Widget>.generate(
            5,
            (index) {
              return Column(
                children: [
                  Container(
                    color: Colors.transparent,
                    height: size.height * 0.09,
                    width: size.width * 0.9,
                    child: ListTile(
                      leading: Icon(Icons.location_pin),
                      title: Padding(
                        padding: EdgeInsets.only(top: size.height * 0.01),
                        child: SkeletonAnimation(
                          child: Container(
                            height: size.height * 0.022,
                            width: size.width * 0.3,
                            decoration: BoxDecoration(
                              color: Colors.grey[400],
                            ),
                          ),
                        ),
                      ),
                      subtitle: Padding(
                        padding: EdgeInsets.only(top: size.height * 0.014),
                        child: SkeletonAnimation(
                          child: Container(
                            decoration: BoxDecoration(color: Colors.grey[400]),
                            height: size.height * 0.022,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Divider(
                    height: size.height * 0.005,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
