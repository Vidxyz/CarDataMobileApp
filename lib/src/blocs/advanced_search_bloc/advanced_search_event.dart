import 'package:equatable/equatable.dart';

abstract class AdvancedSearchEvent extends Equatable {
  const AdvancedSearchEvent();
}

class AdvancedSearchReset extends AdvancedSearchEvent {

  const AdvancedSearchReset();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'AdvancedSearchReset { }';
}

class AdvancedSearchFiltersChanged extends AdvancedSearchEvent {
  final Map<String, List<String>> selectedFilters;

  const AdvancedSearchFiltersChanged({
    this.selectedFilters
  });


  AdvancedSearchFiltersChanged copyWith({
    Map<String, List<String>> updatedFilters
  }) {
    return AdvancedSearchFiltersChanged(
        selectedFilters: {...selectedFilters, ...updatedFilters}
    );
  }


  @override
  List<Object> get props => [selectedFilters];

  @override
  String toString() => 'AdvancedSearchFiltersChanged { attributeValues for $selectedFilters }';

}

class AdvancedSearchButtonPressed extends AdvancedSearchEvent {
  final Map<String, List<String>> selectedFilters;

  const AdvancedSearchButtonPressed({
    this.selectedFilters
  });

  @override
  List<Object> get props => [selectedFilters];

  @override
  String toString() => 'AdvancedSearchReset { $selectedFilters }';
}