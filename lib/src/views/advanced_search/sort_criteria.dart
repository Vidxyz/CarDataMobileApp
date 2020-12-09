import 'package:car_data_app/src/blocs/advanced_search_bloc/advanced_search_bloc.dart';
import 'package:car_data_app/src/blocs/advanced_search_bloc/advanced_search_event.dart';
import 'package:car_data_app/src/blocs/advanced_search_bloc/advanced_search_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SortCriteria extends StatefulWidget {
  final String attributeName;
  final List<String> displayAttributeValues;

  SortCriteria({
    Key key,
    this.attributeName,
    this.displayAttributeValues
  }):
        super(key: key);

  @override
  State createState() {
    return _SortCriteriaState();
  }
}

class _SortCriteriaState extends State<SortCriteria> {

  AdvancedSearchBloc _advancedSearchBloc;
  int _selectedIndex = -1;

  @override
  void initState() {
    super.initState();
    _advancedSearchBloc = BlocProvider.of<AdvancedSearchBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    final blocState = _advancedSearchBloc.state;
    if (blocState is AdvancedSearchCriteriaChanged) {
      final selectedAttributeValues = blocState.selectedFilters[widget.attributeName];
      print("SELECTED ATTR VALUES $selectedAttributeValues");
      if(selectedAttributeValues != null) {
        var retrievedState = selectedAttributeValues.map((e) => widget.displayAttributeValues.indexOf(e)).toList();
        if (retrievedState.isEmpty) _selectedIndex = -1;
        else _selectedIndex = retrievedState.first;
      }
      else {
        _selectedIndex = -1;
      }
    }
    else {
      _selectedIndex = -1;
    }
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: 200,
      ),
      child: Container(
        padding: EdgeInsets.only(bottom: 10),
        child: GridView.count(
          childAspectRatio: 4,
          crossAxisCount: 2,
          shrinkWrap: true,
          children:
          List.generate(widget.displayAttributeValues.length,
                  (index) =>
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: index == _selectedIndex ? Colors.tealAccent : Colors.transparent,
                          width: 2.5
                      ),
                    ),
                    padding: EdgeInsets.only(left:17, right: 17),
                    child: GestureDetector(
                      onTap: () => setState(() {
                        if(index == _selectedIndex) _selectedIndex = -1;
                        else _selectedIndex = index;

                        _advancedSearchBloc.add(AdvancedSearchFiltersChanged(
                            selectedFilters: {
                              widget.attributeName: [widget.displayAttributeValues[index]]}));
                      }),
                      child: Container(
                          padding: EdgeInsets.only(top: 5),
                          child: Text(
                            widget.displayAttributeValues[index].toString(),
                            style: TextStyle(
                                color: index == _selectedIndex ? Colors.blue : Colors.white,
                                fontSize: 15
                            )
                        ),
                      ),
                    ),
                  )
          ),
        ),
      ),
    );
  }
}