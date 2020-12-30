import 'package:car_data_app/src/blocs/menu_navigation_bloc/menu_navigation_event.dart';
import 'package:car_data_app/src/blocs/menu_navigation_bloc/menu_navigation_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:rxdart/rxdart.dart';
import 'package:bloc/bloc.dart';
import 'dart:async';

class MenuNavigationBloc extends Bloc<MenuNavigationEvent, MenuNavigationState> {

  MenuNavigationBloc(): super(MenuNavigationInitial());

  @override
  Stream<Transition<MenuNavigationEvent, MenuNavigationState>> transformEvents(
      Stream<MenuNavigationEvent> events,
      Stream<Transition<MenuNavigationEvent, MenuNavigationState>> Function(MenuNavigationEvent event, ) transitionFn,
      ) {
    return events
        .debounceTime(const Duration(milliseconds: 300))
        .switchMap(transitionFn);
  }

  @override
  Stream<MenuNavigationState> mapEventToState(MenuNavigationEvent event) async* {
    if(event is SavedFilterChosen) {
      yield SavedFilterSelected(selectedFilters: event.selectedFilters);
    }
    if(event is MenuItemChosen) {
      yield MenuItemSelected(selectedMenuItem: event.selectedMenuItem);
    }
  }
}