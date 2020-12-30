import 'package:CarPedia/src/blocs/favourite_vehicles_bloc/favourite_vehicles_event.dart';
import 'package:CarPedia/src/blocs/favourite_vehicles_bloc/favourite_vehicles_state.dart';
import 'package:CarPedia/src/repo/repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:rxdart/rxdart.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'dart:async';

class FavouriteVehiclesBloc extends Bloc<FavouriteVehiclesEvent, FavouriteVehiclesState> {
  static final int pageSize = 15;
  final Repo repository;

  FavouriteVehiclesBloc({@required this.repository}): super(FavouriteVehiclesInitial());

  @override
  Stream<Transition<FavouriteVehiclesEvent, FavouriteVehiclesState>> transformEvents(
      Stream<FavouriteVehiclesEvent> events,
      Stream<Transition<FavouriteVehiclesEvent, FavouriteVehiclesState>> Function(FavouriteVehiclesEvent event, ) transitionFn,
      ) {
    return events
        .switchMap(transitionFn);
  }

  @override
  Stream<FavouriteVehiclesState> mapEventToState(FavouriteVehiclesEvent event) async* {
    final currentState = state;
    if(event is FavouriteVehiclesReset) {
      yield FavouriteVehiclesInitial();
    }

    if(event is FavouriteVehiclesRequested && currentState is FavouriteVehiclesInitial) {
      try {
        yield FavouriteVehiclesLoading();
        final results = await repository.getVehiclesByIds(event.favouriteVehicleIds, pageSize, 0);
        yield FavouriteVehiclesSuccess(
            favouriteVehicles: results,
            hasReachedMax: results.length == pageSize ? false : true
        );
      } catch (error) {
        yield FavouriteVehiclesError("An error occurred fetching vehicle data: ${error.toString()}");
      }
    }

    if(event is FavouriteVehiclesRequested && currentState is FavouriteVehiclesSuccess) {
      try {
        final results = await repository.getVehiclesByIds(
            event.favouriteVehicleIds, pageSize, currentState.favouriteVehicles.length);
        yield FavouriteVehiclesSuccess(
            favouriteVehicles: currentState.favouriteVehicles + results,
            hasReachedMax: results.length == pageSize ? false : true
        );
      }
      catch (error) {
        yield FavouriteVehiclesError("An error occurred fetching vehicle data: ${error.toString()}");
      }
    }
  }
}