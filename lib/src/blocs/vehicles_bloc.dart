import 'package:car_data_app/src/blocs/bloc.dart';
import 'package:car_data_app/src/models/vehicle.dart';
import 'package:car_data_app/src/repo/repo.dart';
import 'package:rxdart/rxdart.dart';

import 'dart:async';

class VehiclesBloc implements Bloc {

  final _repo = Repo();
  final _vehiclesFetcher = PublishSubject<List<Vehicle>>();

  Stream<List<Vehicle>> get allVehicles => _vehiclesFetcher.stream;

  void searchVehicles(String query) async {
    List<Vehicle> vehicles = await _repo.getVehiclesBySearchQuery(query);
    _vehiclesFetcher.sink.add(vehicles);
  }

  @override
  void dispose() {
    _vehiclesFetcher.close();
  }

}
