import 'package:car_data_app/src/blocs/more_attribute_values_bloc/more_attribute_values_event.dart';
import 'package:car_data_app/src/blocs/more_attribute_values_bloc/more_attribute_values_state.dart';
import 'package:car_data_app/src/repo/repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:rxdart/rxdart.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'dart:async';

class MoreAttributeValuesBloc extends Bloc<MoreAttributeValuesEvent, MoreAttributeValuesState> {
  final Repo repository;

  MoreAttributeValuesBloc({required this.repository}): super(MoreAttributeValuesInitial()) {
    on<MoreAttributeValuesRequested>(_moreAttributeValuesRequested);
  }

  void _moreAttributeValuesRequested(MoreAttributeValuesRequested event, Emitter<MoreAttributeValuesState> emit) async {
    try {
      // write code here
      emit(MoreAttributeValuesLoading());
      final attributeValues = await repository.getMoreAttributeValues();
      emit(MoreAttributeValuesSuccess(attributeValues: attributeValues));
    } catch (error) {
      emit(MoreAttributeValuesError('An error occurred fetching vehicle images: ${error.toString()}'));
    }
  }

}