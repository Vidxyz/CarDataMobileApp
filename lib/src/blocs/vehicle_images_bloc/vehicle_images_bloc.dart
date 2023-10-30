import 'package:car_data_app/src/blocs/vehicle_images_bloc/vehicle_images_event.dart';
import 'package:car_data_app/src/blocs/vehicle_images_bloc/vehicle_images_state.dart';
import 'package:car_data_app/src/repo/repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:rxdart/rxdart.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'dart:async';

class VehicleImagesBloc extends Bloc<VehicleImagesEvent, VehicleImagesState> {
  final Repo repository;

  VehicleImagesBloc({required this.repository}): super(ImageFetchInitial()) {
    on<ImageFetchStarted>(imageFetchStarted);
  }

  void imageFetchStarted(ImageFetchStarted event, Emitter<VehicleImagesState> emit) async {
    try {
      emit(ImageFetchLoading());
      final results = await repository.getVehicleImages(event.vehicleId);
      emit(ImageFetchSuccess(results));
    } catch (error) {
      emit(ImageFetchError('An error occurred fetching vehicle images: ${error.toString()}'));
    }
  }
}