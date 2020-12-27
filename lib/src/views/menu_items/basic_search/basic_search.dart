import 'package:car_data_app/src/views/menu_items/basic_search/basic_search_bar.dart';
import 'package:car_data_app/src/views/menu_items/basic_search/basic_search_body.dart';
import 'package:flutter/material.dart';


class BasicSearch extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return _buildSearch(context);
  }

  Widget _buildSearch(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        BasicSearchBar(),
        BasicSearchBody()
      ],
    );
  }
}

