import 'package:car_data_app/src/blocs/advanced_search_bloc/advanced_search_event.dart';
import 'package:car_data_app/src/blocs/advanced_search_bloc/advanced_search_state.dart';
import 'package:car_data_app/src/repo/repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:rxdart/rxdart.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'dart:async';

class AdvancedSearchBloc extends Bloc<AdvancedSearchEvent, AdvancedSearchState> {
  final Repo repository;

  AdvancedSearchBloc({@required this.repository}): super(AdvancedSearchEmpty());

  @override
  Stream<Transition<AdvancedSearchEvent, AdvancedSearchState>> transformEvents(
      Stream<AdvancedSearchEvent> events,
      Stream<Transition<AdvancedSearchEvent, AdvancedSearchState>> Function(AdvancedSearchEvent event, ) transitionFn,
      ) {
    return events
        // .debounceTime(const Duration(milliseconds: 300))
        .switchMap(transitionFn);
  }

  @override
  Stream<AdvancedSearchState> mapEventToState(AdvancedSearchEvent event) async* {
    print("In map event to state AdvancedSearchBloc");
    final currentState = state;
    if (event is AdvancedSearchReset) {
      yield AdvancedSearchEmpty();
    }

    // Filters can only be removed when something has been set, thus state is AdvancedSearchFiltersChanged
    if(event is AdvancedSearchFilterRemoved) {
      if(currentState is AdvancedSearchCriteriaChanged) {
        yield AdvancedSearchEmpty();
        yield currentState.removeFilters(attributeName: event.attributeName, attributeValue: event.attributeValue);
      }
      else {
        print("This should not be reached...");
        yield currentState;
      }// this should never be reached ideally
    }

    if (event is AdvancedSearchFiltersChanged) {
      if(currentState is AdvancedSearchCriteriaChanged) yield currentState.copyWith(updatedFilters: event.selectedFilters);
      else yield AdvancedSearchCriteriaChanged(selectedFilters: event.selectedFilters);
    }

    if(event is AdvancedSearchButtonPressed) {
      yield AdvancedSearchLoading();
      try {
        // Make network call and return results
      } catch (error) {
        yield AdvancedSearchError("An error occurred fetching vehicle data: ${error.toString()}");
      }
    }
  }
}