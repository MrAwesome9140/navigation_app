import 'package:mobx/mobx.dart';
import 'package:navigation_app/Models/graph.dart';
import 'package:navigation_app/Services/mapbox_service.dart';

part 'route_store.g.dart';

class RouteStore extends _RouteStore with _$RouteStore {
  RouteStore(MapBoxService mapBoxService) : super(mapBoxService);
}

abstract class _RouteStore with Store {
  final MapBoxService _mapBoxService;

  _RouteStore(this._mapBoxService);

  @observable
  List<SpecialVertex> route = [];

  
}
