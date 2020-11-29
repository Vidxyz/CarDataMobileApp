import 'package:flutter/material.dart';
import 'views/search_screen.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: Scaffold(
        body: SearchScreen(),
      ),
    );
  }
}
