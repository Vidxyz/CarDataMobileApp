import 'package:car_data_app/src/blocs/random_vehicle_bloc/random_vehicle_event.dart';
import 'package:car_data_app/src/blocs/random_vehicle_bloc/random_vehicle_state.dart';
import 'package:car_data_app/src/repo/repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:rxdart/rxdart.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'dart:async';

class RandomVehicleBloc extends Bloc<RandomVehicleEvent, RandomVehicleState> {
  final Repo repository;

  RandomVehicleBloc({required this.repository}): super(RandomVehicleInitial()) {
    on<RandomVehicleRequested>(_randomVehicleRequested);
  }

  void _randomVehicleRequested(RandomVehicleRequested event, Emitter<RandomVehicleState> emit) async {
    try {
      emit(RandomVehicleLoading());
      final vehicle = await repository.getRandomVehicle();
      emit(RandomVehicleSuccess(vehicle: vehicle));
    } catch (error) {
      emit(RandomVehicleError('An error occurred fetching random vehicle: ${error.toString()}'));
    }
  }

}