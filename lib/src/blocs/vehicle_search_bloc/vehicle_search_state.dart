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
  final bool hasReachedMax;
  final String searchQuery;

  const SearchStateSuccess({
      this.vehicles,
      this.hasReachedMax,
      this.searchQuery
  });

  SearchStateSuccess copyWith({
    List<Vehicle> vehicles,
    bool hasReachedMax,
    String searchQuery
  }) {
    return SearchStateSuccess(
        vehicles: vehicles ?? this.vehicles,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax,
        searchQuery: searchQuery ?? this.searchQuery
    );
  }

  @override
  String toString() => "${this.runtimeType} with length of items ${vehicles.length}. HasReachedMax $hasReachedMax";

  @override
  List<Object> get props => [vehicles, hasReachedMax, searchQuery];

}

class SearchStateError extends VehicleSearchState {
  final String error;

  const SearchStateError(this.error);

  @override
  List<Object> get props => [error];
}