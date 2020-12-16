import 'package:car_data_app/src/views/app_drawer.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: GlobalAppDrawer()
    );
  }
}
