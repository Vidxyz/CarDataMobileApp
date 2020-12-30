import 'package:CarPedia/src/models/vehicle.dart';
import 'package:equatable/equatable.dart';

abstract class RandomVehicleState extends Equatable {
  const RandomVehicleState();

  @override
  List<Object> get props => [];
}

class RandomVehicleInitial extends RandomVehicleState {}

class RandomVehicleLoading extends RandomVehicleState {}

class RandomVehicleSuccess extends RandomVehicleState {
  final Vehicle vehicle;

  const RandomVehicleSuccess({
    this.vehicle
  });

  @override
  List<Object> get props => [vehicle];

  @override
  String toString() => 'RandomVehicleSuccess { vehicle for $vehicle }';
}

class RandomVehicleError extends RandomVehicleState {
  final String error;

  const RandomVehicleError(this.error);

  @override
  List<Object> get props => [error];
}