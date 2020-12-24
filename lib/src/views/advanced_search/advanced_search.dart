import 'dart:convert';

import 'package:car_data_app/src/blocs/advanced_search_bloc/advanced_search_bloc.dart';
import 'package:car_data_app/src/blocs/advanced_search_bloc/advanced_search_event.dart';
import 'package:car_data_app/src/blocs/advanced_search_bloc/advanced_search_state.dart';
import 'package:car_data_app/src/models/saved_filter.dart';
import 'package:car_data_app/src/utils/Utils.dart';
import 'package:car_data_app/src/views/advanced_search/attribute_selections.dart';
import 'package:car_data_app/src/views/advanced_search/selected_filters.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class AdvancedSearch extends StatefulWidget {

  @override
  State createState() {
    return _AdvancedSearchState();
  }
}

class _AdvancedSearchState extends State<AdvancedSearch> {

  static final String sortOrderKey = "sort_order";
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
    BlocBuilder<AdvancedSearchBloc, AdvancedSearchState>(
      builder: (BuildContext context, AdvancedSearchState state) {
        if (state is AdvancedSearchEmpty ||
            (state is AdvancedSearchCriteriaChanged && _areFiltersEmpty(state.selectedFilters))
        ) {
          return Row(
            children: [
              Expanded(child: _clearFiltersButton()),
              Expanded(child: _editOrApplyButton(state))
            ],
          );
        }
        else {
          return Row(
            children: [
              Expanded(child: _clearFiltersButton()),
              Expanded(child: _editOrApplyButton(state)),
              Expanded(child: _saveButton(state))
            ],
          );
        }
      }
    );


  Widget _clearFiltersButton() {
    return Container(
      padding: EdgeInsets.all(1),
      child: RaisedButton.icon(
          onPressed: () {
            _advancedSearchBloc.add(AdvancedSearchReset());
            setState(() {});
          },
          icon: Icon(Icons.clear_all),
          label: Text("Clear"),
          color: Colors.redAccent
      ),
    );
  }


  Widget _saveButton(AdvancedSearchState state) {
    return Container(
      padding: EdgeInsets.all(1),
      child: RaisedButton.icon(
          onPressed: () {
            // Need to prompt dialog with text prompt and store JSON object in shared prefs
            if(state is AdvancedSearchCriteriaChanged) {
              _showUserPromptToSaveFilters(state.selectedFilters);
            }
            else {
              print("This shouldn't be happening... look into it....");
            }
          },
          icon: Icon(Icons.save_sharp),
          label: Text("Save"),
          color: Colors.blueAccent
      ),
    );
  }

  Widget _editOrApplyButton(AdvancedSearchState state) {
    return Container(
      padding: EdgeInsets.all(1),
      child: RaisedButton.icon(
          onPressed: () {
            final currentState =_advancedSearchBloc.state;
            if(currentState is AdvancedSearchCriteriaChanged){
              final f = Map<String, List<String>>.from(currentState.selectedFilters);
              // Remove sort order key (asc, desc) and search only if at least one attribute selected
              f.removeWhere((key, value) => key == sortOrderKey);
              if(f.isNotEmpty && !_areFiltersEmpty(f)) {
                _advancedSearchBloc.add(AdvancedSearchButtonPressed(
                    selectedFilters: currentState.selectedFilters)
                );
              }
              else {
                print("Doing nothing because only sort order is set, OR filters have empty values");
              }
            }
            else if (currentState is AdvancedSearchSuccess) {
              // We force the UI to go back to the attribute selection screen by simulating
              // a event with change in filters, while simply re-providing the same set of of filters
              print("Re-adding same filters to go back to edit filters view");
              _advancedSearchBloc.add(
                  AdvancedSearchFiltersChanged(selectedFilters: currentState.selectedFilters));
            }
            else {
              print("Doing nothing because no filters set");
            }
          },
          icon: state is AdvancedSearchSuccess ? Icon(Icons.edit_outlined) : Icon(Icons.search_sharp),
          label: state is AdvancedSearchSuccess ? Text("Edit") : Text("Apply"),
          color: Colors.teal
      ),
    );
  }

  Future<void> _showUserPromptToSaveFilters(Map<String, List<String>> selectedFilters) async {
    final textEditingController = TextEditingController();
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Save Filter'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Please enter a name for your selection'),
                Utils.Gap(),
                Utils.Gap(),
                TextField(
                  controller: textEditingController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Filter Name"
                  ),
                )
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                   'Cancel',
                    style: TextStyle(
                      color: Colors.tealAccent
                    ),
                  ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'Save',
                style: TextStyle(
                    color: Colors.tealAccent
                ),
              ),
              onPressed: () {
                // Save to shared prefs here before popping
                _saveChosenFilter(selectedFilters, textEditingController.text);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _saveChosenFilter(Map<String, List<String>> filters, String filterName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var uuid = Uuid();
    var filterId = uuid.v4();
    var savedFilter = SavedFilter.from(filterId, filterName, filters);

    List<String> savedFiltersFromPrefs = prefs.getStringList(Utils.SAVED_FILTERS_KEY);
    if(savedFiltersFromPrefs == null)
      savedFiltersFromPrefs = [json.encode(savedFilter.toJson())];
    else
      savedFiltersFromPrefs.add(json.encode(savedFilter.toJson()));

    await prefs.setStringList(Utils.SAVED_FILTERS_KEY, savedFiltersFromPrefs);
    Utils.showSnackBar("Filter saved successfully!", context);
  }

  bool _areFiltersEmpty(Map<String, List<String>> filters) =>
    filters.entries
        .map((e) => e.value)
        .map((e) => e.isEmpty)
        .toList()
        .fold(true, (previousValue, element) => previousValue && element);
}