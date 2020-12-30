import 'package:CarPedia/src/blocs/more_attribute_values_bloc/more_attribute_values_event.dart';
import 'package:CarPedia/src/blocs/more_attribute_values_bloc/more_attribute_values_state.dart';
import 'package:CarPedia/src/repo/repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:rxdart/rxdart.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'dart:async';

class MoreAttributeValuesBloc extends Bloc<MoreAttributeValuesEvent, MoreAttributeValuesState> {
  final Repo repository;

  MoreAttributeValuesBloc({@required this.repository}): super(MoreAttributeValuesInitial());

  @override
  Stream<Transition<MoreAttributeValuesEvent, MoreAttributeValuesState>> transformEvents(
      Stream<MoreAttributeValuesEvent> events,
      Stream<Transition<MoreAttributeValuesEvent, MoreAttributeValuesState>> Function(MoreAttributeValuesEvent event, ) transitionFn,
      ) {
    return events
        .debounceTime(const Duration(milliseconds: 300))
        .switchMap(transitionFn);
  }

  @override
  Stream<MoreAttributeValuesState> mapEventToState(MoreAttributeValuesEvent event) async* {
    if(event is MoreAttributeValuesRequested) {
      try {
        // write code here
        yield MoreAttributeValuesLoading();
        final attributeValues = await repository.getMoreAttributeValues();
        yield MoreAttributeValuesSuccess(attributeValues: attributeValues);
      } catch (error) {
        yield MoreAttributeValuesError('An error occurred fetching vehicle images: ${error.toString()}');
      }
    }
  }
}