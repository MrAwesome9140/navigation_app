// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'route_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$RouteStore on _RouteStore, Store {
  Computed<int>? _$locsLengthComputed;

  @override
  int get locsLength => (_$locsLengthComputed ??=
          Computed<int>(() => super.locsLength, name: '_RouteStore.locsLength'))
      .value;

  final _$homeControlllerAtom = Atom(name: '_RouteStore.homeControlller');

  @override
  MapBoxNavigationViewController get homeControlller {
    _$homeControlllerAtom.reportRead();
    return super.homeControlller;
  }

  @override
  set homeControlller(MapBoxNavigationViewController value) {
    _$homeControlllerAtom.reportWrite(value, super.homeControlller, () {
      super.homeControlller = value;
    });
  }

  final _$controllerAtom = Atom(name: '_RouteStore.controller');

  @override
  PersistentTabController get controller {
    _$controllerAtom.reportRead();
    return super.controller;
  }

  @override
  set controller(PersistentTabController value) {
    _$controllerAtom.reportWrite(value, super.controller, () {
      super.controller = value;
    });
  }

  final _$locsAtom = Atom(name: '_RouteStore.locs');

  @override
  ObservableList<List<String>> get locs {
    _$locsAtom.reportRead();
    return super.locs;
  }

  @override
  set locs(ObservableList<List<String>> value) {
    _$locsAtom.reportWrite(value, super.locs, () {
      super.locs = value;
    });
  }

  final _$coordsAtom = Atom(name: '_RouteStore.coords');

  @override
  ObservableList<Location> get coords {
    _$coordsAtom.reportRead();
    return super.coords;
  }

  @override
  set coords(ObservableList<Location> value) {
    _$coordsAtom.reportWrite(value, super.coords, () {
      super.coords = value;
    });
  }

  final _$optiRouteAtom = Atom(name: '_RouteStore.optiRoute');

  @override
  ObservableList<SpecialVertex> get optiRoute {
    _$optiRouteAtom.reportRead();
    return super.optiRoute;
  }

  @override
  set optiRoute(ObservableList<SpecialVertex> value) {
    _$optiRouteAtom.reportWrite(value, super.optiRoute, () {
      super.optiRoute = value;
    });
  }

  final _$startLocAtom = Atom(name: '_RouteStore.startLoc');

  @override
  Location get startLoc {
    _$startLocAtom.reportRead();
    return super.startLoc;
  }

  @override
  set startLoc(Location value) {
    _$startLocAtom.reportWrite(value, super.startLoc, () {
      super.startLoc = value;
    });
  }

  final _$startNameAtom = Atom(name: '_RouteStore.startName');

  @override
  ObservableList<String> get startName {
    _$startNameAtom.reportRead();
    return super.startName;
  }

  @override
  set startName(ObservableList<String> value) {
    _$startNameAtom.reportWrite(value, super.startName, () {
      super.startName = value;
    });
  }

  final _$progressOverlayAtom = Atom(name: '_RouteStore.progressOverlay');

  @override
  bool get progressOverlay {
    _$progressOverlayAtom.reportRead();
    return super.progressOverlay;
  }

  @override
  set progressOverlay(bool value) {
    _$progressOverlayAtom.reportWrite(value, super.progressOverlay, () {
      super.progressOverlay = value;
    });
  }

  final _$curStepAtom = Atom(name: '_RouteStore.curStep');

  @override
  int get curStep {
    _$curStepAtom.reportRead();
    return super.curStep;
  }

  @override
  set curStep(int value) {
    _$curStepAtom.reportWrite(value, super.curStep, () {
      super.curStep = value;
    });
  }

  final _$loggedInAtom = Atom(name: '_RouteStore.loggedIn');

  @override
  bool get loggedIn {
    _$loggedInAtom.reportRead();
    return super.loggedIn;
  }

  @override
  set loggedIn(bool value) {
    _$loggedInAtom.reportWrite(value, super.loggedIn, () {
      super.loggedIn = value;
    });
  }

  final _$curLocAtom = Atom(name: '_RouteStore.curLoc');

  @override
  Location get curLoc {
    _$curLocAtom.reportRead();
    return super.curLoc;
  }

  @override
  set curLoc(Location value) {
    _$curLocAtom.reportWrite(value, super.curLoc, () {
      super.curLoc = value;
    });
  }

  final _$_RouteStoreActionController = ActionController(name: '_RouteStore');

  @override
  void flipOverlay() {
    final _$actionInfo = _$_RouteStoreActionController.startAction(
        name: '_RouteStore.flipOverlay');
    try {
      return super.flipOverlay();
    } finally {
      _$_RouteStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void nextStep() {
    final _$actionInfo =
        _$_RouteStoreActionController.startAction(name: '_RouteStore.nextStep');
    try {
      return super.nextStep();
    } finally {
      _$_RouteStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
homeControlller: ${homeControlller},
controller: ${controller},
locs: ${locs},
coords: ${coords},
optiRoute: ${optiRoute},
startLoc: ${startLoc},
startName: ${startName},
progressOverlay: ${progressOverlay},
curStep: ${curStep},
loggedIn: ${loggedIn},
curLoc: ${curLoc},
locsLength: ${locsLength}
    ''';
  }
}
