import 'package:car_data_app/src/blocs/advanced_search_bloc/advanced_search_bloc.dart';
import 'package:car_data_app/src/blocs/advanced_search_bloc/advanced_search_event.dart';
import 'package:car_data_app/src/blocs/advanced_search_bloc/advanced_search_state.dart';
import 'package:car_data_app/src/views/advanced_search/attribute_selections.dart';
import 'package:car_data_app/src/views/advanced_search/selected_filters.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdvancedSearch extends StatefulWidget {

  @override
  State createState() {
    return _AdvancedSearchState();
  }
}

class _AdvancedSearchState extends State<AdvancedSearch> {

  AdvancedSearchBloc _advancedSearchBloc;

  @override
  void initState() {
    super.initState();
    _advancedSearchBloc = BlocProvider.of<AdvancedSearchBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    print("Advanced Search build method called");
    return Container(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SelectedFilters(),
            _selectionButtons(),
            AttributeSelectionFilters()
          ],
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
                  onPressed: () {
                    _advancedSearchBloc.add(AdvancedSearchReset());
                    setState(() {});
                  },
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
                  onPressed: () {
                    final currentState =_advancedSearchBloc.state;
                    if(currentState is AdvancedSearchCriteriaChanged){
                      _advancedSearchBloc.add(AdvancedSearchButtonPressed(
                          selectedFilters: currentState.selectedFilters));
                    }
                    else {
                      print("Doing nothing because no filters set");
                    }
                  },
                  icon: Icon(Icons.search_sharp),
                  label: Text("Apply filters"),
                  color: Colors.teal
              ),
            )
        ),
      ],
    );
}