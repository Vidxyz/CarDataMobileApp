import 'package:CarPedia/src/models/vehicle_image.dart';
import 'package:equatable/equatable.dart';

abstract class VehicleImagesState extends Equatable {
  const VehicleImagesState();

  @override
  List<Object> get props => [];
}

class ImageFetchInitial extends VehicleImagesState {}

class ImageFetchLoading extends VehicleImagesState {}

class ImageFetchSuccess extends VehicleImagesState {
  final List<VehicleImage> vehicleImages;

  const ImageFetchSuccess(this.vehicleImages);

  @override
  List<Object> get props => [vehicleImages];

  @override
  String toString() => 'ImageFetchSuccess { images: ${vehicleImages.length} }';
}

class ImageFetchError extends VehicleImagesState {
  final String error;

  const ImageFetchError(this.error);

  @override
  List<Object> get props => [error];
}