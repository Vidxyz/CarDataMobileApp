import 'package:equatable/equatable.dart';

abstract class FavouriteVehiclesEvent extends Equatable {
  const FavouriteVehiclesEvent();
}

class FavouriteVehiclesReset extends FavouriteVehiclesEvent {
  const FavouriteVehiclesReset();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'FavouriteVehiclesReset {  }';
}

class FavouriteVehiclesRequested extends FavouriteVehiclesEvent {
  final List<String> favouriteVehicleIds;

  const FavouriteVehiclesRequested({
    this.favouriteVehicleIds
  });

  @override
  List<Object> get props => [favouriteVehicleIds];

  @override
  String toString() => 'FavouriteVehiclesRequested { ids: $favouriteVehicleIds }';
}