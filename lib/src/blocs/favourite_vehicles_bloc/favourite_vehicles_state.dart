import 'package:CarPedia/src/models/vehicle.dart';
import 'package:equatable/equatable.dart';

abstract class FavouriteVehiclesState extends Equatable {
  const FavouriteVehiclesState();

  @override
  List<Object> get props => [];
}

class FavouriteVehiclesInitial extends FavouriteVehiclesState {}

class FavouriteVehiclesLoading extends FavouriteVehiclesState {}

class FavouriteVehiclesSuccess extends FavouriteVehiclesState {
  final List<Vehicle> favouriteVehicles;
  final bool hasReachedMax;

  const FavouriteVehiclesSuccess({
    this.favouriteVehicles,
    this.hasReachedMax
  });

  @override
  List<Object> get props => [favouriteVehicles, hasReachedMax];

  @override
  String toString() => 'FavouriteVehiclesSuccess { vehicles for $favouriteVehicles }';
}

class FavouriteVehiclesError extends FavouriteVehiclesState {
  final String error;

  const FavouriteVehiclesError(this.error);

  @override
  List<Object> get props => [error];
}