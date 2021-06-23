import 'package:flutter/material.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:navigation_app/Services/mapbox_service.dart';
import 'package:skeleton_text/skeleton_text.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  FloatingSearchBarController _controller = FloatingSearchBarController();
  MapBoxService _mapService = MapBoxService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
                size.width * 0.05, size.height * 0.03, size.width * 0.05, 0.0),
            child: FloatingSearchBar(
              controller: _controller,
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
              actions: [
                FloatingSearchBarAction.back(
                  color: Colors.black,
                )
              ],
              builder: (context, transition) {
                return _autoCompleteOptions();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _autoCompleteOptions() {
    return FutureBuilder(
      builder: (context, snapshot) {
        var size = MediaQuery.of(context).size;
        if (snapshot.hasData) {
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
        } else {
          return ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Material(
              color: Colors.white,
              elevation: 4.0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: List<Widget>.generate(
                  5,
                  (index) {
                    return Column(
                      children: [
                        SkeletonAnimation(
                          child: Container(
                            height: size.height * 0.1,
                            width: size.width * 0.9,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        Divider()
                      ],
                    );
                  },
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
