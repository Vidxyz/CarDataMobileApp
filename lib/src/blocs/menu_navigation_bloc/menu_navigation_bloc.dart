import 'package:car_data_app/src/blocs/menu_navigation_bloc/menu_navigation_event.dart';
import 'package:car_data_app/src/blocs/menu_navigation_bloc/menu_navigation_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:rxdart/rxdart.dart';
import 'package:bloc/bloc.dart';
import 'dart:async';

class MenuNavigationBloc extends Bloc<MenuNavigationEvent, MenuNavigationState> {

  MenuNavigationBloc(): super(MenuNavigationInitial()) {
    on<MenuItemChosen>(menuItemChosen);
    on<SavedFilterChosen>(savedFilterChosen);
  }

  void menuItemChosen(MenuItemChosen event, Emitter<MenuNavigationState> emit) async {
    emit(MenuItemSelected(selectedMenuItem: event.selectedMenuItem));
  }

  void savedFilterChosen(SavedFilterChosen event, Emitter<MenuNavigationState> emit) async {
    emit(SavedFilterSelected(selectedFilters: event.selectedFilters));
  }


}