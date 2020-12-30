import 'package:CarPedia/src/blocs/attribute_values_bloc/attribute_values_event.dart';
import 'package:CarPedia/src/blocs/attribute_values_bloc/attribute_values_state.dart';
import 'package:CarPedia/src/repo/repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:rxdart/rxdart.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'dart:async';

class AttributeValuesBloc extends Bloc<AttributeValueEvent, AttributeValuesState> {
  final Repo repository;

  AttributeValuesBloc({@required this.repository}): super(AttributeValuesInitial());

  @override
  Stream<Transition<AttributeValueEvent, AttributeValuesState>> transformEvents(
      Stream<AttributeValueEvent> events,
      Stream<Transition<AttributeValueEvent, AttributeValuesState>> Function(AttributeValueEvent event, ) transitionFn,
      ) {
    return events
        .debounceTime(const Duration(milliseconds: 300))
        .switchMap(transitionFn);
  }

  @override
  Stream<AttributeValuesState> mapEventToState(AttributeValueEvent event) async* {
    if(event is AttributeValuesRequested) {
      try {
        // write code here
        yield AttributeValuesLoading();
        final attributeValues = await repository.getAttributeValues();
        yield AttributeValuesSuccess(attributeValues: attributeValues);
      } catch (error) {
        yield AttributeValuesError('An error occurred fetching vehicle images: ${error.toString()}');
      }
    }
  }
}