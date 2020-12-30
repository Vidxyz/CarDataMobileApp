import 'package:CarPedia/src/blocs/menu_navigation_bloc/menu_navigation_bloc.dart';
import 'package:CarPedia/src/views/menu_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: BlocProvider(
        create: (context) => MenuNavigationBloc(),
        child: GlobalMenuDrawer(),
      ),
    );
  }
}
