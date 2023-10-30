import 'package:car_data_app/src/blocs/attribute_values_bloc/attribute_values_event.dart';
import 'package:car_data_app/src/blocs/attribute_values_bloc/attribute_values_state.dart';
import 'package:car_data_app/src/repo/repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:rxdart/rxdart.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'dart:async';

class AttributeValuesBloc extends Bloc<AttributeValueEvent, AttributeValuesState> {
  final Repo repository;

  AttributeValuesBloc({ required this.repository}): super(AttributeValuesInitial()) {
    on<AttributeValuesRequested>(_attributeValuesRequested);
  }

  void _attributeValuesRequested(AttributeValuesRequested event, Emitter<AttributeValuesState> emit) async {
    try {
      // write code here
      emit(AttributeValuesLoading());
      final attributeValues = await repository.getAttributeValues();
      emit(AttributeValuesSuccess(attributeValues: attributeValues));
    } catch (error) {
      emit(AttributeValuesError('An error occurred fetching vehicle images: ${error.toString()}'));
    }
  }

}