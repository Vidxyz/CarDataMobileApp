import 'package:car_data_app/src/blocs/favourite_vehicles_bloc/favourite_vehicles_event.dart';
import 'package:car_data_app/src/blocs/favourite_vehicles_bloc/favourite_vehicles_state.dart';
import 'package:car_data_app/src/repo/repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:rxdart/rxdart.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'dart:async';

class FavouriteVehiclesBloc extends Bloc<FavouriteVehiclesEvent, FavouriteVehiclesState> {
  final Repo repository;

  FavouriteVehiclesBloc({@required this.repository}): super(FavouriteVehiclesInitial());

  @override
  Stream<Transition<FavouriteVehiclesEvent, FavouriteVehiclesState>> transformEvents(
      Stream<FavouriteVehiclesEvent> events,
      Stream<Transition<FavouriteVehiclesEvent, FavouriteVehiclesState>> Function(FavouriteVehiclesEvent event, ) transitionFn,
      ) {
    return events
        .debounceTime(const Duration(milliseconds: 300))
        .switchMap(transitionFn);
  }

  @override
  Stream<FavouriteVehiclesState> mapEventToState(FavouriteVehiclesEvent event) async* {
    if(event is FavouriteVehiclesRequested) {
      try {
        // write code here
      } catch (error) {

      }
    }
  }
}