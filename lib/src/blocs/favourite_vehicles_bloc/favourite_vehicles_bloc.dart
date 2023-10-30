import 'package:car_data_app/src/blocs/favourite_vehicles_bloc/favourite_vehicles_event.dart';
import 'package:car_data_app/src/blocs/favourite_vehicles_bloc/favourite_vehicles_state.dart';
import 'package:car_data_app/src/repo/repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:rxdart/rxdart.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'dart:async';

class FavouriteVehiclesBloc extends Bloc<FavouriteVehiclesEvent, FavouriteVehiclesState> {
  static final int pageSize = 15;
  final Repo repository;

  FavouriteVehiclesBloc({required this.repository}): super(FavouriteVehiclesInitial()) {
    on<FavouriteVehiclesReset>(favouriteVehiclesReset);
    on<FavouriteVehiclesRequested>(favouriteVehiclesRequested);
  }

  void favouriteVehiclesReset(FavouriteVehiclesReset event, Emitter<FavouriteVehiclesState> emit) async {
    emit(FavouriteVehiclesInitial());
  }

  void favouriteVehiclesRequested(FavouriteVehiclesRequested event, Emitter<FavouriteVehiclesState> emit) async {
    final currentState = state;
    if(currentState is FavouriteVehiclesInitial) {
      try {
        emit(FavouriteVehiclesLoading());
        final results = await repository.getVehiclesByIds(event.favouriteVehicleIds, pageSize, 0);
        emit(FavouriteVehiclesSuccess(
            favouriteVehicles: results,
            hasReachedMax: results.length == pageSize ? false : true
        ));
      } catch (error) {
        emit(FavouriteVehiclesError("An error occurred fetching vehicle data: ${error.toString()}"));
      }
    }

    if(currentState is FavouriteVehiclesSuccess) {
      try {
        final results = await repository.getVehiclesByIds(
            event.favouriteVehicleIds, pageSize, currentState.favouriteVehicles.length);
        emit(FavouriteVehiclesSuccess(
            favouriteVehicles: currentState.favouriteVehicles + results,
            hasReachedMax: results.length == pageSize ? false : true
        ));
      }
      catch (error) {
        emit(FavouriteVehiclesError("An error occurred fetching vehicle data: ${error.toString()}"));
      }
    }
  }

}