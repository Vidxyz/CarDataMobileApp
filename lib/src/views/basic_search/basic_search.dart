import 'package:car_data_app/src/views/basic_search/search_bar.dart';
import 'package:car_data_app/src/views/basic_search/search_body.dart';
import 'package:flutter/material.dart';


class BasicSearch extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    print("Search screen build widget called");
    return _buildSearch(context);
  }

  Widget _buildSearch(BuildContext context) {
    print("Build search is called now");
    final searchWidget = Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SearchBar(),
        SearchBody()
      ],
    );

    return searchWidget;
  }
}

