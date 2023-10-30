import 'package:car_data_app/src/blocs/advanced_search_bloc/advanced_search_bloc.dart';
import 'package:car_data_app/src/blocs/advanced_search_bloc/advanced_search_event.dart';
import 'package:car_data_app/src/blocs/attribute_values_bloc/attribute_values_bloc.dart';
import 'package:car_data_app/src/blocs/menu_navigation_bloc/menu_navigation_bloc.dart';
import 'package:car_data_app/src/blocs/menu_navigation_bloc/menu_navigation_state.dart';
import 'package:car_data_app/src/blocs/more_attribute_values_bloc/more_attribute_values_bloc.dart';
import 'package:car_data_app/src/blocs/vehicle_search_bloc/vehicle_search_bloc.dart';
import 'package:car_data_app/src/repo/repo.dart';
import 'package:car_data_app/src/utils/Utils.dart';
import 'package:car_data_app/src/views/menu_items/advanced_search/advanced_search.dart';
import 'package:car_data_app/src/views/menu_items/basic_search/basic_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VehicleSearchTabView extends StatefulWidget {

  @override
  State createState() {
    return VehicleSearchTabState();
  }
}

class VehicleSearchTabState extends State<VehicleSearchTabView> with SingleTickerProviderStateMixin {

  static final int MAX_TABS = 2;

  bool hasForceNavigationToAdvancedSearchTabOccurred = false;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: MAX_TABS);
    _tabController!.addListener(() {
      if(_tabController!.index == 1)  {
        Utils.hideKeyboard(context);
      }
      else {
        hasForceNavigationToAdvancedSearchTabOccurred = true;
      }
    });
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MenuNavigationBloc, MenuNavigationState>(
      builder: (BuildContext context, MenuNavigationState state) {
        if(state is SavedFilterSelected && !hasForceNavigationToAdvancedSearchTabOccurred) {
          _tabController!.animateTo(1);
          hasForceNavigationToAdvancedSearchTabOccurred = true;
        }
        else {
          hasForceNavigationToAdvancedSearchTabOccurred = false;
        }
        return DefaultTabController(
          length: MAX_TABS,
          initialIndex: state is SavedFilterSelected ? 1 : 0,
          child: Scaffold(
            appBar: AppBar(
              toolbarHeight: 75,
              title: TabBar(
                controller: _tabController,
                tabs: [
                  Tab(icon: Icon(Icons.search), text: "Basic Search"),
                  Tab(icon: Icon(Icons.saved_search), text: "Advanced Search"),
                ],
              ),
            ),
            body: TabBarView(
              controller: _tabController,
              children: [
                BlocProvider(
                  create: (context) => VehicleSearchBloc(repository: Repo()),
                  child: BasicSearch(),
                ),
                MultiBlocProvider(
                  providers: [
                    BlocProvider<AttributeValuesBloc>(
                      create: (context) => AttributeValuesBloc(repository: Repo()),
                    ),
                    BlocProvider<MoreAttributeValuesBloc>(
                      create: (context) => MoreAttributeValuesBloc(repository: Repo()),
                    ),
                    BlocProvider<AdvancedSearchBloc>(
                      create: (context) {
                        if (state is SavedFilterSelected)
                          return AdvancedSearchBloc(repository: Repo())
                              ..add(AdvancedSearchFiltersChanged(selectedFilters: state.selectedFilters));
                        else
                          return AdvancedSearchBloc(repository: Repo());
                      },
                    ),
                  ],
                  child: AdvancedSearch(),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}