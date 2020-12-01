import 'package:car_data_app/src/models/vehicle.dart';
import 'package:equatable/equatable.dart';

abstract class VehicleSearchState extends Equatable {
  const VehicleSearchState();

  @override
  List<Object> get props => [];
}

class SearchStateEmpty extends VehicleSearchState {}

class SearchStateLoading extends VehicleSearchState {}

class SearchStateSuccess extends VehicleSearchState {
  final List<Vehicle> vehicles;

  const SearchStateSuccess(this.vehicles);

  @override
  List<Object> get props => [vehicles];

  @override
  String toString() => 'SearchStateSuccess { items: ${vehicles.toString()} }';
}

class SearchStateError extends VehicleSearchState {
  final String error;

  const SearchStateError(this.error);

  @override
  List<Object> get props => [error];
}