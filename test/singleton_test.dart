import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:navigation_app/State/route_store.dart';

import 'package:navigation_app/main.dart';

void main() {
  testWidgets('Singleton Test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    RouteStore _route1 = RouteStore();
    RouteStore _route2 = RouteStore();

    if (_route1 == _route2) {
      print('Hoorah!');
    } else {
      print('Booooooooooo!');
    }
  });
}
