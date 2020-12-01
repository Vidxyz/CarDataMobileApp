import 'dart:async';

import 'package:car_data_app/src/blocs/vehicle_search_bloc/vehicle_search_event.dart';
import 'package:car_data_app/src/blocs/vehicle_search_bloc/vehicle_search_state.dart';
import 'package:car_data_app/src/repo/repo.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:bloc/bloc.dart';


class VehicleSearchBloc extends Bloc<VehicleSearchEvent, VehicleSearchState> {
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
    if (event is SearchQueryChanged) {
      final String searchTerm = event.text;
      if (searchTerm.isEmpty) {
        yield SearchStateEmpty();
      } else {
        yield SearchStateLoading();
        try {
          final results = await repository.carDataApiProvider.getVehiclesBySearchQuery(searchTerm, 15, 0);
          yield SearchStateSuccess(results);
        } catch (error) {
          yield SearchStateError('An error occurred fetching search results: ${error.toString()}');
        }
      }
    }
  }
}