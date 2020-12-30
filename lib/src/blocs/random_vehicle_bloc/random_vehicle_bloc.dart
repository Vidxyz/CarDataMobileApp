import 'package:CarPedia/src/blocs/random_vehicle_bloc/random_vehicle_event.dart';
import 'package:CarPedia/src/blocs/random_vehicle_bloc/random_vehicle_state.dart';
import 'package:CarPedia/src/repo/repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:rxdart/rxdart.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'dart:async';

class RandomVehicleBloc extends Bloc<RandomVehicleEvent, RandomVehicleState> {
  final Repo repository;

  RandomVehicleBloc({@required this.repository}): super(RandomVehicleInitial());

  @override
  Stream<Transition<RandomVehicleEvent, RandomVehicleState>> transformEvents(
      Stream<RandomVehicleEvent> events,
      Stream<Transition<RandomVehicleEvent, RandomVehicleState>> Function(RandomVehicleEvent event, ) transitionFn,
      ) {
    return events
        .debounceTime(const Duration(milliseconds: 300))
        .switchMap(transitionFn);
  }

  @override
  Stream<RandomVehicleState> mapEventToState(RandomVehicleEvent event) async* {
    if(event is RandomVehicleRequested) {
      try {
        yield RandomVehicleLoading();
        final vehicle = await repository.getRandomVehicle();
        yield RandomVehicleSuccess(vehicle: vehicle);
      } catch (error) {
        yield RandomVehicleError('An error occurred fetching random vehicle: ${error.toString()}');
      }
    }
  }
}