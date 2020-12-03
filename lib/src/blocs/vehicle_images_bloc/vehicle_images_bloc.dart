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

  VehicleImagesBloc({@required this.repository}): super(ImageFetchInitial());

  @override
  Stream<Transition<VehicleImagesEvent, VehicleImagesState>> transformEvents(
      Stream<VehicleImagesEvent> events,
      Stream<Transition<VehicleImagesEvent, VehicleImagesState>> Function(VehicleImagesEvent event, ) transitionFn,
      ) {
    return events
        .debounceTime(const Duration(milliseconds: 300))
        .switchMap(transitionFn);
  }

  @override
  Stream<VehicleImagesState> mapEventToState(VehicleImagesEvent event) async* {
    if(event is ImageFetchStarted) {
      try {
        yield ImageFetchLoading();
        final results = await repository.getVehicleImages(event.vehicleId);
        yield ImageFetchSuccess(results);
      } catch (error) {
        yield ImageFetchError('An error occurred fetching vehicle images: ${error.toString()}');
      }
    }
  }
}