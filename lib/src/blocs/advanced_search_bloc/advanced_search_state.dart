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
    required this.selectedFilters
  });


  AdvancedSearchCriteriaChanged copyWith({
    required Map<String, List<String>> updatedFilters
  }) {
    return AdvancedSearchCriteriaChanged(
      selectedFilters: {...selectedFilters, ...updatedFilters}
    );
  }

  AdvancedSearchCriteriaChanged removeFilters({
    required String attributeName,
    required String attributeValue
  }) {
    var attributeValuesHavingRemovedChosenOne = selectedFilters[attributeName]!;
    attributeValuesHavingRemovedChosenOne.remove(attributeValue);
    selectedFilters[attributeName] = attributeValuesHavingRemovedChosenOne;
    return AdvancedSearchCriteriaChanged(
        selectedFilters: selectedFilters
    );
  }

  @override
  List<Object> get props => [selectedFilters];

  @override
  String toString() => 'AdvancedSearchCriteriaChanged { attributeValues for $selectedFilters }';

}

class AdvancedSearchLoading extends AdvancedSearchState {}

class AdvancedSearchSuccess extends AdvancedSearchState {
  final Map<String, List<String>> selectedFilters;
  final List<Vehicle> vehicles;
  final bool hasReachedMax;
  final totalResultCount;

  const AdvancedSearchSuccess({
    required this.selectedFilters,
    required this.vehicles,
    required this.hasReachedMax,
    this.totalResultCount
  });

  AdvancedSearchCriteriaChanged removeFilters({
    required String attributeName,
    required String attributeValue
  }) {
    var attributeValuesHavingRemovedChosenOne = selectedFilters[attributeName]!;
    attributeValuesHavingRemovedChosenOne.remove(attributeValue);
    selectedFilters[attributeName] = attributeValuesHavingRemovedChosenOne;
    return AdvancedSearchCriteriaChanged(
        selectedFilters: selectedFilters
    );
  }

  @override
  List<Object> get props => [selectedFilters, vehicles, hasReachedMax];

  @override
  String toString() => 'AdvancedSearchSuccess { hasReachedMax: $hasReachedMax attributeValues : $selectedFilters \n vehicles: ${vehicles.length} }';
}

class AdvancedSearchError extends AdvancedSearchState {
  final String error;

  const AdvancedSearchError(this.error);

  @override
  List<Object> get props => [error];
}