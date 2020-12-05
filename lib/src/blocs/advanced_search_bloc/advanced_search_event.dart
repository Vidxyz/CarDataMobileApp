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

class AdvancedSearchFilterRemoved extends AdvancedSearchEvent {
  final String attributeName;
  final String attributeValue;


  const AdvancedSearchFilterRemoved({
    this.attributeName,
    this.attributeValue
  });

  @override
  List<Object> get props => [attributeName, attributeValue];

  @override
  String toString() => 'AdvancedSearchFilterRemoved { removedFilter for $attributeName with value $attributeValue }';

}

class AdvancedSearchFiltersChanged extends AdvancedSearchEvent {
  final Map<String, List<String>> selectedFilters;

  const AdvancedSearchFiltersChanged({
    this.selectedFilters
  });

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