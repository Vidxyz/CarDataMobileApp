import 'package:car_data_app/src/blocs/app_properties_bloc.dart';
import 'package:car_data_app/src/blocs/bloc_provider.dart';
import 'package:car_data_app/src/views/advanced_search_screen.dart';
import 'package:car_data_app/src/views/basic_search_screen.dart';
import 'package:flutter/material.dart';

class TabView extends StatelessWidget{
  final appBloc = AppPropertiesBloc();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: StreamBuilder(
            stream: appBloc.titleStream,
            initialData: "Welcome",
            builder: (context, snapshot) {
              print("App bar is being updated right now to value: ${snapshot.data}");
              return Text(snapshot.data);
            }
          ),
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.search), text: "Basic Search"),
              Tab(icon: Icon(Icons.saved_search), text: "Advanced Search"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            BlocProvider<AppPropertiesBloc>(
              bloc: appBloc,
              child: BasicSearchScreen()
            ),
            BlocProvider<AppPropertiesBloc>(
              bloc: appBloc,
              child: AdvancedSearchScreen()
            )
          ],
        ),
      ),
    );
  }
}