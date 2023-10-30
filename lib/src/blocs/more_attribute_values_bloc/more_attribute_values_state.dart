import 'package:car_data_app/src/models/more_attribute_values.dart';
import 'package:equatable/equatable.dart';

abstract class MoreAttributeValuesState extends Equatable {
  const MoreAttributeValuesState();

  @override
  List<Object> get props => [];
}

class MoreAttributeValuesInitial extends MoreAttributeValuesState {}

class MoreAttributeValuesLoading extends MoreAttributeValuesState {}

class MoreAttributeValuesSuccess extends MoreAttributeValuesState {
  final MoreAttributeValues attributeValues;

  const MoreAttributeValuesSuccess({
    required this.attributeValues
  });

  @override
  List<Object> get props => [attributeValues];

  @override
  String toString() => 'AttributeSearchSuccess { attributeValues for $attributeValues }';
}

class MoreAttributeValuesError extends MoreAttributeValuesState {
  final String error;

  const MoreAttributeValuesError(this.error);

  @override
  List<Object> get props => [error];
}