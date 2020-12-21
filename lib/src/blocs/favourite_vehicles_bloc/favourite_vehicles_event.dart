import 'package:equatable/equatable.dart';

abstract class FavouriteVehiclesEvent extends Equatable {
  const FavouriteVehiclesEvent();
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