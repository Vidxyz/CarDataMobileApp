import 'package:equatable/equatable.dart';

abstract class VehicleImagesEvent extends Equatable {
  const VehicleImagesEvent();
}

class ImageFetchStarted extends VehicleImagesEvent {
  final String vehicleId;

  const ImageFetchStarted({required this.vehicleId});

  @override
  List<Object> get props => [vehicleId];

  @override
  String toString() => 'ImageFetchStarted { vehicleId: $vehicleId }';
}