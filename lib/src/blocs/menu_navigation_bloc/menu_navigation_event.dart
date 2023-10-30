import 'package:equatable/equatable.dart';

abstract class MenuNavigationEvent extends Equatable {
  const MenuNavigationEvent();
}

class MenuItemChosen extends MenuNavigationEvent {
  final String selectedMenuItem;

  const MenuItemChosen({
    required this.selectedMenuItem
  });

  @override
  List<Object> get props => [selectedMenuItem];

  @override
  String toString() => 'MenuItemChosen {  $selectedMenuItem }';
}

class SavedFilterChosen extends MenuNavigationEvent {
  final Map<String, List<String>> selectedFilters;

  const SavedFilterChosen({
    required this.selectedFilters
  });

  @override
  List<Object> get props => [selectedFilters];

  @override
  String toString() => 'SavedFilterChosen { $selectedFilters }';
}