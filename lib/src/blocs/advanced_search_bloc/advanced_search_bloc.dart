import 'package:car_data_app/src/blocs/advanced_search_bloc/advanced_search_event.dart';
import 'package:car_data_app/src/blocs/advanced_search_bloc/advanced_search_state.dart';
import 'package:car_data_app/src/repo/repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:rxdart/rxdart.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'dart:async';

class AdvancedSearchBloc extends Bloc<AdvancedSearchEvent, AdvancedSearchState> {
  static final int pageSize = 15;
  final Repo repository;

  AdvancedSearchBloc({required this.repository}): super(AdvancedSearchEmpty()) {
    on<AdvancedSearchReset>(advancedSearchReset);
    on<AdvancedSearchFilterRemoved>(advancedSearchFilterRemoved);
    on<AdvancedSearchFiltersChanged>(advancedSearchFiltersChanged);
    on<AdvancedSearchButtonPressed>(advancedSearchButtonPressed);
  }

  void advancedSearchReset(AdvancedSearchReset event, Emitter<AdvancedSearchState> emit) async {
    emit(AdvancedSearchEmpty());
  }

  void advancedSearchFilterRemoved(AdvancedSearchFilterRemoved event, Emitter<AdvancedSearchState> emit) async {
    final currentState = state;
    if(currentState is AdvancedSearchCriteriaChanged) {
      emit(AdvancedSearchEmpty());
      emit(currentState.removeFilters(attributeName: event.attributeName, attributeValue: event.attributeValue));
    }
    else if (currentState is AdvancedSearchSuccess) {
      emit(AdvancedSearchEmpty());
      emit(currentState.removeFilters(attributeName: event.attributeName, attributeValue: event.attributeValue));
    }
    else { // this should never be reached ideally
      print("This should not be reached...");
      emit(currentState);
    }
  }

  void advancedSearchFiltersChanged(AdvancedSearchFiltersChanged event, Emitter<AdvancedSearchState> emit) async {
    final currentState = state;
    if(currentState is AdvancedSearchCriteriaChanged)  emit(currentState.copyWith(updatedFilters: event.selectedFilters));
    else emit(AdvancedSearchCriteriaChanged(selectedFilters: event.selectedFilters));
  }

  void advancedSearchButtonPressed(AdvancedSearchButtonPressed event, Emitter<AdvancedSearchState> emit) async {
    final currentState = state;
    if(currentState is AdvancedSearchCriteriaChanged) {
      emit(AdvancedSearchLoading());
      try {
        final resultCount = await repository.getVehicleCountBySelectedAttributes(currentState.selectedFilters);
        final results = await repository.getVehiclesBySelectedAttributes(currentState.selectedFilters, pageSize, 0);
        emit(AdvancedSearchSuccess(
            vehicles: results,
            selectedFilters: currentState.selectedFilters,
            hasReachedMax: results.length == pageSize ? false : true,
            totalResultCount: resultCount
        ));
      } catch (error) {
        emit(AdvancedSearchError("An error occurred fetching vehicle data: ${error.toString()}"));
      }
    }

    if(currentState is AdvancedSearchSuccess) {
      print("Lazyloading is called pressed with state $currentState");
      try {
        final results = await repository.getVehiclesBySelectedAttributes(currentState.selectedFilters, pageSize, currentState.vehicles.length);
        emit(AdvancedSearchSuccess(
            vehicles: currentState.vehicles + results,
            selectedFilters: currentState.selectedFilters,
            hasReachedMax: results.length == pageSize ? false : true,
            totalResultCount: currentState.totalResultCount
        ));
      } catch (error) {
        emit(AdvancedSearchError("An error occurred fetching vehicle data: ${error.toString()}"));
      }
    }
  }

}