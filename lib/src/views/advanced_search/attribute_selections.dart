import 'package:car_data_app/src/blocs/advanced_search_bloc/advanced_search_bloc.dart';
import 'package:car_data_app/src/blocs/advanced_search_bloc/advanced_search_event.dart';
import 'package:car_data_app/src/blocs/advanced_search_bloc/advanced_search_state.dart';
import 'package:car_data_app/src/blocs/attribute_values_bloc/attribute_values_bloc.dart';
import 'package:car_data_app/src/blocs/attribute_values_bloc/attribute_values_event.dart';
import 'package:car_data_app/src/blocs/attribute_values_bloc/attribute_values_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AttributeSelectionFilters extends StatefulWidget {

  @override
  State createState() {
    return _AttributeSelectionFiltersState();
  }
}

// This is for showing all the attribute that have to be user selected
class _AttributeSelectionFiltersState extends State<AttributeSelectionFilters> with AutomaticKeepAliveClientMixin {

  @override
  bool wantKeepAlive = true;

  static final List<String> displayNames = ["Primary Fuel",
    "Secondary Fuel", "Fuel Grade", "Transmission", "Make", "Engine"];

  static final List<String> attributesToDisplayListsFor = ["fuel_type_primary",
    "fuel_type_secondary", "fuel_type", "type", "make", "engine_descriptor"];

  AdvancedSearchBloc _advancedSearchBloc;
  AttributeValuesBloc _attributeValuesBloc;

  Map<String, List<int>> selectedAttributeNameValueIndices = {
    "fuel_type_primary": List<int>(),
    "fuel_type_secondary": List<int>(),
    "fuel_type": List<int>(),
    "type": List<int>(),
    "make": List<int>(),
    "engine_descriptor": List<int>()
  };

  @override
  void initState() {
    super.initState();
    print("AttributeSelectionFiltersState init state method");
    _advancedSearchBloc = BlocProvider.of<AdvancedSearchBloc>(context);
    _attributeValuesBloc = BlocProvider.of<AttributeValuesBloc>(context);
    _attributeValuesBloc.add(AttributeValuesRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
          padding: EdgeInsets.only(top: 10),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: attributesToDisplayListsFor.length,
            itemBuilder: (_, index) {
              return Card(child:
              _createAttributeValues(displayNames[index],
                  attributesToDisplayListsFor[index]));
            },
          ),
        ),
    );
  }

  Widget _createAttributeValues(String displayName, String attributeName) {
    return BlocBuilder<AdvancedSearchBloc, AdvancedSearchState>(
      builder: (BuildContext context, AdvancedSearchState state) {
        if (state is AdvancedSearchCriteriaChanged || state is AdvancedSearchEmpty) {
          return ExpansionTile(
              title: Text(
                displayName,
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),
              children: <Widget> [
                BlocBuilder<AttributeValuesBloc, AttributeValuesState>(
                  builder: (BuildContext context, AttributeValuesState state) {
                    if(state is AttributeValuesLoading) {
                      return ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: 100,
                        ),
                        child: Container(
                          padding: EdgeInsets.all(30),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    else if (state is AttributeValuesSuccess) {
                      // only doing attribute values for primary fuel type right now
                      return attributeValuesListView(attributeName, state.attributeValues.attributeValues[attributeName]);
                    }
                    else { // this should not be reached ideally
                      print(state.toString());
                      return Container();
                    }
                  },
                )
              ]
          );
        }
        else {
          print("Attribute Selection - in else case with state ${state.toString()}");
          return Container();
        }
      }
    );
  }

  Widget attributeValuesListView(String attributeName, List<String> attributeValues) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: 200,
      ),
      child: Container(
        padding: EdgeInsets.only(bottom: 10),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: attributeValues.length,
          itemBuilder: (_, index) {
            return Container(
              margin: EdgeInsets.only(left:17),
              child: GestureDetector(
                onTap: () => setState(() {
                  var selectedIndices = selectedAttributeNameValueIndices[attributeName];
                  if(selectedIndices.contains(index))
                    selectedIndices.remove(index);
                  else
                    selectedIndices.add(index);

                  selectedAttributeNameValueIndices[attributeName] = selectedIndices;
                  _advancedSearchBloc.add(AdvancedSearchFiltersChanged(
                      selectedFilters: {attributeName: getSelectedAttributeValues(attributeValues, selectedIndices)}));
                }),
                child: Container(
                  padding: EdgeInsets.only(top: 5),
                  child: Text(
                      attributeValues[index].toString(),
                      style: TextStyle(
                          color: selectedAttributeNameValueIndices[attributeName].contains(index) ? Colors.blue : Colors.white,
                          fontSize: 15
                      )
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
  
  List<String> getSelectedAttributeValues(List<String> values, List<int> selectedIndices) {
    var selectedTypes = List<String>();
    for (var i = 0; i < selectedIndices.length; i++) {
      selectedTypes.add(values[selectedIndices[i]]);
    }
    return selectedTypes;
  }
}