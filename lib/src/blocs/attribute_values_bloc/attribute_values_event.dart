import 'package:equatable/equatable.dart';

abstract class AttributeValueEvent extends Equatable {
  const AttributeValueEvent();
}

class AttributeValuesRequested extends AttributeValueEvent {

  const AttributeValuesRequested();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'AttributeValuesRequested { }';
}