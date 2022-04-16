import 'package:geocoding/geocoding.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:navigation_app/State/route_store.dart';
import 'package:system_alert_window/system_alert_window.dart';

class NavigationService {
  RouteStore _routeStore = RouteStore();

  Future startNavigation() async {
    await SystemAlertWindow.requestPermissions();
    displaySystemWindow();
    // for (int i = 1; i < _routeStore.coords.length; i++) {
    //   Location startLoc = _routeStore.coords[i - 1];
    //   Location endLoc = _routeStore.coords[i];
    //   await navigateBetween(startLoc, endLoc);
    // }
  }

  Future navigateBetween(Location start, Location end) async {}

  Future displaySystemWindow() async {
    SystemWindowHeader header = SystemWindowHeader(
        title: SystemWindowText(
            text: 'On Route Finished:',
            padding: SystemWindowPadding(
              left: 100,
            )),
        button: SystemWindowButton(
          tag: 'finished_button',
          text: SystemWindowText(text: 'Continue'),
        ));
    await SystemAlertWindow.showSystemWindow(
      header: header,
      height: 50,
      margin: SystemWindowMargin(left: 100, right: 100),
    );
  }
}
