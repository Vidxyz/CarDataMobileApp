import 'dart:convert';

import 'package:car_data_app/src/blocs/advanced_search_bloc/advanced_search_bloc.dart';
import 'package:car_data_app/src/blocs/advanced_search_bloc/advanced_search_event.dart';
import 'package:car_data_app/src/blocs/advanced_search_bloc/advanced_search_state.dart';
import 'package:car_data_app/src/models/saved_filter.dart';
import 'package:car_data_app/src/utils/Utils.dart';
import 'package:car_data_app/src/views/menu_items/advanced_search/attribute_selections.dart';
import 'package:car_data_app/src/views/menu_items/advanced_search/selected_filters.dart';
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

  static final String sortBy = "sort_by";
  static final String sortOrderKey = "sort_order";
  static final List<String> sortByAttributesDisplay = [
    "City Mpg",
    "Highway Mpg",
    "Combined Mpg",
    "Annual Fuel Cost",
    "Fuel Economy",
    "CO2 Emissions",
    "Greenhouse Score"
  ];

  int sortOrderIndex = -1;
  String sortOrderValue = "Descending";
  AdvancedSearchBloc _advancedSearchBloc;

  @override
  void initState() {
    super.initState();
    _advancedSearchBloc = BlocProvider.of<AdvancedSearchBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
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
              Expanded(child: _sortButton()),
              Expanded(child: _editOrApplyButton(state))
            ],
          );
        }
        else {
          return Row(
            children: [
              Expanded(child: _clearFiltersButton()),
              Expanded(child: _sortButton()),
              Expanded(child: _editOrApplyButton(state)),
              Expanded(child: _saveButton(state))
            ],
          );
        }
      }
    );


  Widget _sortButton() {
    return Container(
      padding: EdgeInsets.all(1),
      child: RaisedButton.icon(
          onPressed: () {
            final currentState = _advancedSearchBloc.state;
            if(currentState is AdvancedSearchSuccess) {
              // We force the UI to go back to the attribute selection screen by simulating
              // a event with change in filters, while simply re-providing the same set of of filters
              print("Re-adding same filters to go back to edit filters view");
              _advancedSearchBloc.add(
                  AdvancedSearchFiltersChanged(selectedFilters: currentState.selectedFilters));
            }
            else {
              // We want to make sure that previous sorting selections are cleared before moving forward
              // Additionally, we are making sure that selected criteria are highlighter upon dialog show
              // This second check is strictly not necessary, as `sortOrderValue` and `sortOrderIndex` are
              // persisted from last selection, but it's better to be safe than sorry
              if(currentState is AdvancedSearchCriteriaChanged) {
                if(currentState.selectedFilters[sortOrderKey] != null &&
                    currentState.selectedFilters[sortOrderKey].isNotEmpty) {
                  sortOrderValue = currentState.selectedFilters[sortOrderKey].first;
                }
                else {
                  sortOrderValue = "Descending";
                }
                if(currentState.selectedFilters[sortBy] != null &&
                    currentState.selectedFilters[sortBy].isNotEmpty) {
                  sortOrderIndex = sortByAttributesDisplay.indexOf(currentState.selectedFilters[sortBy].first);
                }
                else {
                  sortOrderIndex = -1;
                }
              }
              else {
                sortOrderIndex = -1;
                sortOrderValue = "Descending";
              }

            }
            return _showUserSortingCriteria();
          },
          icon: Icon(Icons.sort_sharp),
          label: Text("Sort", style: _raisedButtonTextStyle()),
          color: Colors.orangeAccent
      ),
    );
  }

  Widget _clearFiltersButton() {
    return Container(
      padding: EdgeInsets.all(1),
      child: RaisedButton.icon(
          onPressed: () {
            _advancedSearchBloc.add(AdvancedSearchReset());
            setState(() {});
          },
          icon: Icon(Icons.clear_sharp),
          label: Text("Clear", style: _raisedButtonTextStyle()),
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
            else if (state is AdvancedSearchSuccess) {
              _showUserPromptToSaveFilters(state.selectedFilters);
            }
            else {
              print("This shouldn't be happening... look into it....");
            }
          },
          icon: Icon(Icons.save_sharp),
          label: Text("Save", style: _raisedButtonTextStyle()),
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
          label: state is AdvancedSearchSuccess ?
            Text("Edit", style: _raisedButtonTextStyle()) :
            Text("Go", style: _raisedButtonTextStyle()),
          color: Colors.teal
      ),
    );
  }

  TextStyle _raisedButtonTextStyle() => TextStyle(fontSize: 14);

  Future<void> _showUserSortingCriteria() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        int sortIndex = sortOrderIndex;
        String sortOrder = sortOrderValue;
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              actions: <Widget>[
                TextButton(
                  child: Text(
                    'Close',
                    style: TextStyle(
                        color: Colors.tealAccent
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
              title: Text('Sort By', textAlign: TextAlign.center),
              content: Container(
                constraints: BoxConstraints(
                  maxHeight: Utils.getScreenHeight(context) / 3,
                  maxWidth: Utils.getScreenWidth(context) / 2,
                ),
                child: Container(
                  height: Utils.getScreenHeight(context) / 2,
                  width: Utils.getScreenWidth(context) / 2,
                  child: Column(
                      children: <Widget> [
                        Expanded(
                          flex: 2,
                          child: RadioListTile<String>(
                            title: Text("Ascending"),
                            value: "Ascending",
                            groupValue: sortOrder,
                            onChanged: (String value) {
                              setState(() {
                                sortOrder = value;
                                sortOrderValue = sortOrder;
                                _advancedSearchBloc.add(
                                    AdvancedSearchFiltersChanged(
                                        selectedFilters: {sortOrderKey: [sortOrder]}
                                    )
                                );
                              });
                            },
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: RadioListTile<String>(
                            title: Text("Descending"),
                            value: "Descending",
                            groupValue: sortOrder,
                            onChanged: (String value) {
                              setState(() {
                                sortOrder = value;
                                sortOrderValue = sortOrder;
                                _advancedSearchBloc.add(
                                    AdvancedSearchFiltersChanged(
                                        selectedFilters: {sortOrderKey: [sortOrder]}
                                    )
                                );
                              });
                            },
                          ),
                        ),
                        Expanded(flex: 2, child: Divider()),
                        Expanded(
                          flex: 10,
                          child: Container(
                            child: ListView(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              children:
                              List.generate(sortByAttributesDisplay.length,
                                (index) =>
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: index == sortIndex ? Colors.tealAccent : Colors.transparent,
                                        width: 1
                                    ),
                                  ),
                                  padding: EdgeInsets.only(left:17, right: 17),
                                  child: GestureDetector(
                                    onTap: () => setState(() {
                                      if(index == sortIndex) {
                                        sortIndex = -1;
                                        sortOrderIndex = sortIndex;
                                        _advancedSearchBloc.add(AdvancedSearchFilterRemoved(
                                            attributeName: sortBy,
                                            attributeValue: sortByAttributesDisplay[index]
                                        ));
                                      }
                                      else {
                                        sortIndex = index;
                                        sortOrderIndex = sortIndex;
                                        _advancedSearchBloc.add(AdvancedSearchFiltersChanged(
                                            selectedFilters: {
                                              sortBy: [sortByAttributesDisplay[index]]
                                            }));
                                      }
                                    }),
                                    child: Container(
                                      margin: EdgeInsets.all(3),
                                      child: Text(
                                        sortByAttributesDisplay[index].toString(),
                                        style: TextStyle(
                                            color: index == sortIndex ? Colors.tealAccent : Colors.white,
                                            fontSize: 15
                                        )
                                      ),
                                    ),
                                  ),
                                )
                              ),
                            ),
                          )
                        ),
                      ]
                  ),
                ),
              ),
            );
          },
        );
      },
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
                Utils.gap(),
                Utils.gap(),
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
        .where((element) => element.key != sortOrderKey)
        .map((e) => e.value)
        .map((e) => e.isEmpty)
        .toList()
        .fold(true, (previousValue, element) => previousValue && element);
}