import 'package:car_data_app/src/views/basic_search/basic_search_bar.dart';
import 'package:car_data_app/src/views/basic_search/basic_search_body.dart';
import 'package:flutter/material.dart';


class BasicSearch extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    print("Search screen build widget called");
    return _buildSearch(context);
  }

  Widget _buildSearch(BuildContext context) {
    print("Build search is called now");
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        BasicSearchBar(),
        BasicSearchBody()
      ],
    );
  }
}

