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

  VehicleSearchBloc({@required this.repository})
      : super(SearchStateEmpty());


  @override
  Stream<Transition<VehicleSearchEvent, VehicleSearchState>> transformEvents(
      Stream<VehicleSearchEvent> events,
      Stream<Transition<VehicleSearchEvent, VehicleSearchState>> Function(VehicleSearchEvent event, ) transitionFn,
      ) {
    return events
        .debounceTime(const Duration(milliseconds: 300))
        .switchMap(transitionFn);
  }

  @override
  Stream<VehicleSearchState> mapEventToState(VehicleSearchEvent event) async* {
    final currentState = state;
    if (event is SearchQueryReset) {
      yield SearchStateEmpty();
    }
    else if (event is SearchQueryChanged && !_hasReachedMax(currentState)) {
      final String searchTerm = event.text;
      if (searchTerm.isEmpty) {
        yield SearchStateEmpty();
      } else {
        try {
          if (currentState is SearchStateEmpty) {
            yield SearchStateLoading();
            final results = await repository.getVehiclesBySearchQuery(searchTerm, pageSize, 0);
            yield results.length == pageSize ?
              SearchStateSuccess(vehicles: results, hasReachedMax: false, searchQuery: searchTerm) :
              SearchStateSuccess(vehicles: results, hasReachedMax: true, searchQuery: searchTerm);
          }
          if (currentState is SearchStateSuccess) {
            final results = await repository.getVehiclesBySearchQuery(searchTerm, pageSize, currentState.vehicles.length);
            yield results.length != pageSize ?
              currentState.copyWith(hasReachedMax: true) :
              SearchStateSuccess(
                  vehicles: currentState.vehicles + results,
                  hasReachedMax: false,
                  searchQuery: searchTerm
              );
          }
        }
        catch (error) {
          yield SearchStateError('An error occurred fetching search results: ${error.toString()}');
        }
      }
    }
  }

  bool _hasReachedMax(VehicleSearchState state) =>
      state is SearchStateSuccess && state.hasReachedMax;
}