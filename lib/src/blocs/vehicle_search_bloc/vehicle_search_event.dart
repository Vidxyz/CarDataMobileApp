import 'package:equatable/equatable.dart';

abstract class VehicleSearchEvent extends Equatable {
  const VehicleSearchEvent();
}

class SearchQueryChanged extends VehicleSearchEvent {
  final String text;

  const SearchQueryChanged({this.text});

  @override
  List<Object> get props => [text];

  @override
  String toString() => 'SearchQueryChanged { text: $text }';
}