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
    required this.attributeName,
    required this.attributeValue
  });

  @override
  List<Object> get props => [attributeName, attributeValue];

  @override
  String toString() => 'AdvancedSearchFilterRemoved { removedFilter for $attributeName with value $attributeValue }';

}

class AdvancedSearchFiltersChanged extends AdvancedSearchEvent {
  final Map<String, List<String>> selectedFilters;

  const AdvancedSearchFiltersChanged({
    required this.selectedFilters
  });

  @override
  List<Object> get props => [selectedFilters];

  @override
  String toString() => 'AdvancedSearchFiltersChanged { attributeValues for $selectedFilters }';

}

class AdvancedSearchButtonPressed extends AdvancedSearchEvent {
  final Map<String, List<String>> selectedFilters;

  const AdvancedSearchButtonPressed({
    required this.selectedFilters
  });

  @override
  List<Object> get props => [selectedFilters];

  @override
  String toString() => 'AdvancedSearchButtonPressed { $selectedFilters }';
}