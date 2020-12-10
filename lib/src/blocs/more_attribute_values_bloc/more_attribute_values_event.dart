import 'package:equatable/equatable.dart';

abstract class MoreAttributeValuesEvent extends Equatable {
  const MoreAttributeValuesEvent();
}

class MoreAttributeValuesRequested extends MoreAttributeValuesEvent {

  const MoreAttributeValuesRequested();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'MoreAttributeValuesRequested { }';
}