import 'package:CarPedia/src/blocs/advanced_search_bloc/advanced_search_event.dart';
import 'package:CarPedia/src/blocs/advanced_search_bloc/advanced_search_state.dart';
import 'package:CarPedia/src/repo/repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:rxdart/rxdart.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'dart:async';

class AdvancedSearchBloc extends Bloc<AdvancedSearchEvent, AdvancedSearchState> {
  static final int pageSize = 15;
  final Repo repository;

  AdvancedSearchBloc({@required this.repository}): super(AdvancedSearchEmpty());

  @override
  Stream<Transition<AdvancedSearchEvent, AdvancedSearchState>> transformEvents(
      Stream<AdvancedSearchEvent> events,
      Stream<Transition<AdvancedSearchEvent, AdvancedSearchState>> Function(AdvancedSearchEvent event, ) transitionFn,
      ) {
    return events
        .switchMap(transitionFn);
  }

  @override
  Stream<AdvancedSearchState> mapEventToState(AdvancedSearchEvent event) async* {
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
      else if (currentState is AdvancedSearchSuccess) {
        yield AdvancedSearchEmpty();
        yield currentState.removeFilters(attributeName: event.attributeName, attributeValue: event.attributeValue);
      }
      else { // this should never be reached ideally
        print("This should not be reached...");
        yield currentState;
      }
    }

    if (event is AdvancedSearchFiltersChanged) {
      if(currentState is AdvancedSearchCriteriaChanged) yield currentState.copyWith(updatedFilters: event.selectedFilters);
      else yield AdvancedSearchCriteriaChanged(selectedFilters: event.selectedFilters);
    }

    if(event is AdvancedSearchButtonPressed && currentState is AdvancedSearchCriteriaChanged) {
      yield AdvancedSearchLoading();
      try {
        final resultCount = await repository.getVehicleCountBySelectedAttributes(currentState.selectedFilters);
        final results = await repository.getVehiclesBySelectedAttributes(currentState.selectedFilters, pageSize, 0);
        yield AdvancedSearchSuccess(
          vehicles: results,
          selectedFilters: currentState.selectedFilters,
          hasReachedMax: results.length == pageSize ? false : true,
          totalResultCount: resultCount
        );
      } catch (error) {
        yield AdvancedSearchError("An error occurred fetching vehicle data: ${error.toString()}");
      }
    }

    if(event is AdvancedSearchButtonPressed && currentState is AdvancedSearchSuccess) {
      print("Lazyloading is called pressed with state $currentState");
      try {
        final results = await repository.getVehiclesBySelectedAttributes(currentState.selectedFilters, pageSize, currentState.vehicles.length);
        yield AdvancedSearchSuccess(
          vehicles: currentState.vehicles + results,
          selectedFilters: currentState.selectedFilters,
          hasReachedMax: results.length == pageSize ? false : true,
          totalResultCount: currentState.totalResultCount
        );
      } catch (error) {
        yield AdvancedSearchError("An error occurred fetching vehicle data: ${error.toString()}");
      }
    }
  }
}