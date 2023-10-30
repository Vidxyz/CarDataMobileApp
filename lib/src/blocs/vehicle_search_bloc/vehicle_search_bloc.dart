import 'dart:async';

import 'package:car_data_app/src/blocs/vehicle_search_bloc/vehicle_search_event.dart';
import 'package:car_data_app/src/blocs/vehicle_search_bloc/vehicle_search_state.dart';
import 'package:car_data_app/src/repo/repo.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:bloc/bloc.dart';


class VehicleSearchBloc extends Bloc<VehicleSearchEvent, VehicleSearchState> {
  static final int pageSize = 15;
  final Repo repository;

  VehicleSearchBloc({required this.repository})
      : super(SearchStateEmpty()) {
    on<SearchQueryReset>(searchQueryReset);
    on<SearchQueryChanged>(searchQueryChanged);
  }

  void searchQueryReset(SearchQueryReset event, Emitter<VehicleSearchState> emit) async {
    emit(SearchStateEmpty());
  }

  void searchQueryChanged(SearchQueryChanged event, Emitter<VehicleSearchState> emit) async {
    final currentState = state;
    if (!_hasReachedMax(currentState)) {
      final String searchTerm = event.text;
      if (searchTerm.isEmpty) {
        emit(SearchStateEmpty());
      } else {
        try {
          if (currentState is SearchStateEmpty) {
            emit(SearchStateLoading());
            final resultCount = await repository.getVehiclesCountBySearchQuery(searchTerm);
            final results = await repository.getVehiclesBySearchQuery(searchTerm, pageSize, 0);
            emit(results.length == pageSize ?
            SearchStateSuccess(vehicles: results, hasReachedMax: false, searchQuery: searchTerm, searchResultsCount: resultCount) :
            SearchStateSuccess(vehicles: results, hasReachedMax: true, searchQuery: searchTerm, searchResultsCount: resultCount));
          }
          if (currentState is SearchStateSuccess) {
            final results = await repository.getVehiclesBySearchQuery(searchTerm, pageSize, currentState.vehicles.length);
            emit(results.length != pageSize ?
            currentState.copyWith(hasReachedMax: true) :
            SearchStateSuccess(
                vehicles: currentState.vehicles + results,
                hasReachedMax: false,
                searchQuery: searchTerm,
                searchResultsCount: currentState.searchResultsCount
            ));
          }
        }
        catch (error) {
          emit(SearchStateError('An error occurred fetching search results: ${error.toString()}'));
        }
      }
    }
  }


  bool _hasReachedMax(VehicleSearchState state) =>
      state is SearchStateSuccess && state.hasReachedMax;
}