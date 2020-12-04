import 'package:car_data_app/src/blocs/advanced_search_bloc/advanced_search_bloc.dart';
import 'package:car_data_app/src/repo/repo.dart';
import 'package:car_data_app/src/views/advanced_search/attribute_selections.dart';
import 'package:car_data_app/src/views/advanced_search/selected_filters.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdvancedSearch extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AdvancedSearchBloc(repository: Repo()),
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SelectedFilters(),
            _selectionButtons(),
            AttributeSelectionFilters()
          ],
        ),
      ),
    );
  }

  Widget _selectionButtons() =>
    Row(
      children: [
        Expanded(
            child: Container(
              padding: EdgeInsets.all(1),
              child: RaisedButton.icon(
                  onPressed: () => print("Filters to be cleared"),
                  icon: Icon(Icons.clear_all),
                  label: Text("Clear filters"),
                  color: Colors.redAccent
              ),
            )
        ),
        Expanded(
            child: Container(
              padding: EdgeInsets.all(1),
              child: RaisedButton.icon(
                  onPressed: () => print("Filters to be applied"),
                  icon: Icon(Icons.search_sharp),
                  label: Text("Apply filters"),
                  color: Colors.teal
              ),
            )
        ),
      ],
    );
}