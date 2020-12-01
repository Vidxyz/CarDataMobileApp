import 'package:car_data_app/src/blocs/vehicle_search_bloc/vehicle_search_bloc.dart';
import 'package:car_data_app/src/repo/repo.dart';
import 'package:car_data_app/src/views/advanced_search_screen.dart';
import 'package:car_data_app/src/views/basic_search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TabView extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Find Vehicles"),
          bottom: TabBar(
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
              child: BasicSearchScreen(),
            ),
            AdvancedSearchScreen()
          ],
        ),
      ),
    );
  }
}