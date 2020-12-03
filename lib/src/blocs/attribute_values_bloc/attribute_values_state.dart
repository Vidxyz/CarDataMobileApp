import 'package:car_data_app/src/models/attribute_values.dart';
import 'package:equatable/equatable.dart';

abstract class AttributeValuesState extends Equatable {
  const AttributeValuesState();

  @override
  List<Object> get props => [];
}

class AttributeValuesInitial extends AttributeValuesState {}

class AttributeValuesLoading extends AttributeValuesState {}

class AttributeValuesSuccess extends AttributeValuesState {
  final AttributeValues attributeValues;

  const AttributeValuesSuccess({
    this.attributeValues
  });

  @override
  List<Object> get props => [attributeValues];

  @override
  String toString() => 'AttributeSearchSuccess { attributeValues for $attributeValues }';
}

class AttributeValuesError extends AttributeValuesState {
  final String error;

  const AttributeValuesError(this.error);

  @override
  List<Object> get props => [error];
}