import 'package:car_data_app/src/blocs/advanced_search_bloc/advanced_search_bloc.dart';
import 'package:car_data_app/src/blocs/attribute_values_bloc/attribute_values_bloc.dart';
import 'package:car_data_app/src/blocs/more_attribute_values_bloc/more_attribute_values_bloc.dart';
import 'package:car_data_app/src/blocs/vehicle_search_bloc/vehicle_search_bloc.dart';
import 'package:car_data_app/src/repo/repo.dart';
import 'package:car_data_app/src/views/advanced_search/advanced_search.dart';
import 'package:car_data_app/src/views/basic_search/basic_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VehicleSearchTabView extends StatelessWidget {

  static final int MAX_TABS = 2;

  // parameterize this and make it stateful widget, pass parameter down to advanced search
  // use it to populate the selections screen if being brought here from saved filters menu
  // add app bar icon here to go back to that same menu
  // OR USE A BLOC INSTEAD - thats the way to go
  // TabController _tabController = TabController(initialIndex: 0, length: MAX_TABS, vsync: this);
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: MAX_TABS,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 75,
          title: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.search), text: "Basic Search"),
              Tab(icon: Icon(Icons.saved_search), text: "Advanced Search"),
            ],
          ),
        ),
        body: TabBarView(
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
                    create: (context) => AdvancedSearchBloc(repository: Repo()),
                  ),
                ],
                child: AdvancedSearch(),
            )
          ],
        ),
      ),
    );
  }
}