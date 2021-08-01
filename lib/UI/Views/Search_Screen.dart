import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:mobx/mobx.dart';
import 'package:navigation_app/Services/mapbox_service.dart';
import 'package:navigation_app/State/route_store.dart';
import 'package:skeleton_text/skeleton_text.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

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
  bool _locationVis = false;
  String _locName = "";
  String _locAdress = "";
  Location _locLocation =
      Location(latitude: 0.0, longitude: 0.0, timestamp: DateTime.now());
  Set<Marker> _markers = new Set();
  late GoogleMapController _mapController;
  bool _setStart = false;

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
          _locationDisplay(),
          Hero(
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
                onFocusChanged: (focus) {
                  if (focus) {
                    setState(() {
                      _locationVis = false;
                    });
                  }
                },
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
        ],
      ),
    );
  }

  Widget _locationDisplay() {
    var size = MediaQuery.of(context).size;
    return Align(
      child: Visibility(
        visible: _locationVis,
        child: Padding(
          padding: EdgeInsets.only(top: size.height * 0.15),
          child: Container(
            height: size.height * 0.7,
            width: size.width * 0.9,
            child: Column(
              children: [
                Container(
                  width: size.width * 0.8,
                  height: size.height * 0.3,
                  child: GoogleMap(
                    onMapCreated: (controller) {
                      _mapController = controller;
                    },
                    initialCameraPosition: CameraPosition(
                      target:
                          LatLng(_locLocation.latitude, _locLocation.longitude),
                      zoom: 12.0,
                    ),
                    markers: _markers,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(size.height * 0.02),
                  child: Container(
                    color: Colors.white,
                    height: size.height * 0.3,
                    width: size.width * 0.8,
                    child: Column(
                      children: [
                        Container(
                          color: Colors.transparent,
                          height: size.height * 0.09,
                          width: size.width * 0.9,
                          child: ListTile(
                            leading: Icon(Icons.location_pin),
                            title: Padding(
                              padding: EdgeInsets.only(top: size.height * 0.01),
                              child: Container(
                                child: Text(_locName),
                                height: size.height * 0.022,
                                width: size.width * 0.3,
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                ),
                              ),
                            ),
                            subtitle: Padding(
                              padding:
                                  EdgeInsets.only(top: size.height * 0.014),
                              child: Container(
                                child: Text(_locAdress),
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                ),
                                height: size.height * 0.022,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: size.width * 0.7,
                          child: Divider(
                            thickness: 1.0,
                            color: Colors.black,
                          ),
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  right: size.width * 0.1,
                                  left: size.width * 0.08),
                              child: Text(
                                'Start Location',
                                style: TextStyle(fontSize: 16.0),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(),
                              child: Checkbox(
                                materialTapTargetSize:
                                    MaterialTapTargetSize.padded,
                                value: _setStart,
                                onChanged: (val) {
                                  setState(() {
                                    _setStart = val!;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: size.width * 0.7,
                          child: Divider(
                            thickness: 1.0,
                            color: Colors.black,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: size.width * 0.03),
                          child: Material(
                            child: InkWell(
                              splashColor: Colors.green,
                              onTap: () {
                                if (!noRepeats(_locAdress)) {
                                  showAlertDialog();
                                } else {
                                  if (_setStart) {
                                    if (_routeStore.startName.length > 0) {
                                      _routeStore
                                              .locs[_routeStore.locs.length] =
                                          _routeStore.startName;
                                      _routeStore
                                              .coords[_routeStore.locs.length] =
                                          _routeStore.startLoc;
                                    }
                                    _routeStore.startName = ObservableList.of(
                                        [_locName, _locAdress]);
                                    _routeStore.startLoc = _locLocation;
                                  } else {
                                    _routeStore.locs[_routeStore.locs.length] =
                                        [
                                      _locName,
                                      _locAdress,
                                    ];
                                    _routeStore
                                            .coords[_routeStore.locs.length] =
                                        _locLocation;
                                  }
                                }
                              },
                              child: Ink(
                                decoration: BoxDecoration(
                                  color: Colors.blue[300],
                                ),
                                height: size.height * 0.08,
                                width: size.width * 0.6,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          right: size.width * 0.03),
                                      child: Text(
                                        'Add Stop',
                                        style: TextStyle(
                                            fontSize: 24.0,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    Icon(
                                      Icons.add,
                                      size: 35.0,
                                    )
                                  ],
                                ),
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
        ),
      ),
    );
  }

  bool noRepeats(String address) {
    bool test = true;
    _routeStore.locs.values.forEach((e) {
      if (e.length > 1 && e[1] == address) {
        test = false;
      }
    });
    if (_routeStore.startName.length > 1 && _routeStore.startName[1] == address)
      test = false;
    return test;
  }

  void showAlertDialog() {
    var exitButton = TextButton(
      child: Text('Okay'),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text('Invalid Input'),
      content: Text(
          'The address you have entered has already been added to your route. Please choose a different stop.'),
      actions: [
        exitButton,
      ],
    );

    showDialog(
      context: context,
      builder: (context) {
        return alert;
      }
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
              future: _mapService.getSearchResults(
                  _autoText,
                  Position(
                      accuracy: 0.0,
                      altitude: 0.0,
                      heading: 0.0,
                      latitude: _routeStore.curLoc.latitude,
                      longitude: _routeStore.curLoc.longitude,
                      speed: 0.0,
                      speedAccuracy: 0.0,
                      timestamp: null)),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  var suggestions = snapshot.data as List<List<String>>;
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Material(
                      color: Colors.white,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: List<Widget>.generate(5, (index) {
                          return Column(
                            children: [
                              InkWell(
                                onTap: () async {
                                  List<Location> locations =
                                      await locationFromAddress(
                                          suggestions[1][index],
                                          localeIdentifier: "en_US");
                                  _locName = suggestions[0][index];
                                  _locAdress = suggestions[1][index];
                                  _locLocation = locations.first;
                                  setState(() {
                                    _markers.clear();
                                    _markers.add(
                                      Marker(
                                        markerId: MarkerId("Marker"),
                                        position: LatLng(_locLocation.latitude,
                                            _locLocation.longitude),
                                        icon: BitmapDescriptor
                                            .defaultMarkerWithHue(
                                                BitmapDescriptor.hueBlue),
                                      ),
                                    );
                                    _locationVis = true;
                                  });
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
                        }),
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
