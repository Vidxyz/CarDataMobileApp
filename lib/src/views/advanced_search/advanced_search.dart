import 'package:car_data_app/src/views/advanced_search/attribute_selections.dart';
import 'package:car_data_app/src/views/advanced_search/selected_filters.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdvancedSearch extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            SelectedFilters(),
            _selectionButtons(),
            Container(
              child: AttributeSelectionFilters(),
            )
          ],
      ),
    );
  }

  Widget _selectionButtons() =>
    Row(
      children: [
        Expanded(
            child: RaisedButton.icon(
                onPressed: () => print("Filters to be cleared"),
                icon: Icon(Icons.clear_all),
                label: Text("Clear filters"),
                color: Colors.redAccent
            )
        ),
        Expanded(
            child: RaisedButton.icon(
                onPressed: () => print("Filters to be applied"),
                icon: Icon(Icons.search_sharp),
                label: Text("Apply filters"),
                color: Colors.teal
            )
        ),
      ],
    );
}