import 'package:car_data_app/src/models/vehicle.dart';
import 'package:equatable/equatable.dart';

abstract class AdvancedSearchState extends Equatable {
  const AdvancedSearchState();

  @override
  List<Object> get props => [];
}

class AdvancedSearchEmpty extends AdvancedSearchState {}

class AdvancedSearchCriteriaChanged extends AdvancedSearchState {
  final Map<String, List<String>> selectedFilters;

  const AdvancedSearchCriteriaChanged({
    this.selectedFilters
  });


  AdvancedSearchCriteriaChanged copyWith({
    Map<String, List<String>> updatedFilters
  }) {
    return AdvancedSearchCriteriaChanged(
      selectedFilters: {...selectedFilters, ...updatedFilters}
    );
  }


  @override
  List<Object> get props => [selectedFilters];

  @override
  String toString() => 'AdvancedSearchCriteriaChanged { attributeValues for $selectedFilters }';

}

class AdvancedSearchLoading extends AdvancedSearchState {}

class AdvancedSearchSuccess extends AdvancedSearchState {
  final List<Vehicle> vehicles;

  const AdvancedSearchSuccess({
    this.vehicles
  });

  @override
  List<Object> get props => [vehicles];

  @override
  String toString() => 'AdvancedSearchSuccess { attributeValues for $vehicles }';
}

class AdvancedSearchError extends AdvancedSearchState {
  final String error;

  const AdvancedSearchError(this.error);

  @override
  List<Object> get props => [error];
}