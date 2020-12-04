import 'package:car_data_app/src/blocs/advanced_search_bloc/advanced_search_bloc.dart';
import 'package:car_data_app/src/blocs/advanced_search_bloc/advanced_search_event.dart';
import 'package:car_data_app/src/blocs/advanced_search_bloc/advanced_search_state.dart';
import 'package:car_data_app/src/blocs/attribute_values_bloc/attribute_values_bloc.dart';
import 'package:car_data_app/src/blocs/attribute_values_bloc/attribute_values_event.dart';
import 'package:car_data_app/src/blocs/attribute_values_bloc/attribute_values_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiver/iterables.dart';
import 'dart:math';


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

  static final List<String> listAttributes = ["make", "fuel_type_primary", "fuel_type_secondary", "fuel_type", "engine_descriptor", "type"];
  static final List<String> integerSliderAttributes = ["year"];
  static final List<String> doubleSliderAttributes = ["displacement"];
  static final List<String> boxAttributes = ["cylinders"];

  static final List<String> displayNames = ["Make", "Year", "Primary Fuel",
    "Secondary Fuel", "Fuel Grade", "Engine", "Transmission", "Cylinders", "Displacement"];

  static final List<String> attributesToDisplayListsFor = ["make", "year", "fuel_type_primary",
    "fuel_type_secondary", "fuel_type", "engine_descriptor", "type",  "cylinders", "displacement"];

  AdvancedSearchBloc _advancedSearchBloc;
  AttributeValuesBloc _attributeValuesBloc;

  Map<String, List<int>> selectedAttributeNameValueIndices = {
    "fuel_type_primary": List<int>(),
    "fuel_type_secondary": List<int>(),
    "fuel_type": List<int>(),
    "type": List<int>(),
    "make": List<int>(),
    "engine_descriptor": List<int>(),
    "cylinders": List<int>(),
  };

  Map<String, RangeValues> selectedSliderAttributeValues = {
    "year": RangeValues(1984, 2021),
    "displacement": RangeValues(0, 8.4)
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
              return Card(child: _displayAttributesNameValuesToUser(displayNames[index], attributesToDisplayListsFor[index]));
            },
          ),
        ),
    );
  }

  Widget _displayAttributesNameValuesToUser(String displayName, String attributeName) {
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
                      if(listAttributes.contains(attributeName))
                        return attributeValuesListView(attributeName, state.attributeValues.attributeValues[attributeName]);
                      else if(integerSliderAttributes.contains(attributeName))
                        return attributeValuesSliderView(attributeName, state.attributeValues.attributeValues[attributeName], false);
                      else if(doubleSliderAttributes.contains(attributeName))
                        return attributeValuesSliderView(attributeName, state.attributeValues.attributeValues[attributeName], true);
                      else
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

  // Need to then replace single list with a gridview list
  // And then, begin working on selected_filters_view
  // todo - refactor so that each filter is only aware of itself, and the bloc handles collection of data - better efficiency in redrawing - still need different slides
  Widget attributeValuesSliderView(String attributeName, List<String> attributeValues, bool isDoubleValue) {
    List<double> numericalValues = attributeValues
        .where((element) => element != null)
        .toList()
        .map((e) => double.parse(e))
        .toList();
    var minimum = min(numericalValues);
    var maximum = max(numericalValues);
    final rangeValues = selectedSliderAttributeValues[attributeName];
    return Container(
        padding: EdgeInsets.only(bottom: 10),
        child: Column(
          children: [
            Center(
              child: Text(
                  isDoubleValue ?
                  "${rangeValues.start.toStringAsFixed(2)} - ${rangeValues.end.toStringAsFixed(2)}" :
                  "${rangeValues.start.toInt()} - ${rangeValues.end.toInt()}",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
            SliderTheme(
              data: SliderThemeData(
                showValueIndicator: ShowValueIndicator.always,
              ),
              child: RangeSlider(
                  divisions: numericalValues.length,
                  activeColor: Colors.blue[700],
                  inactiveColor: Colors.blueAccent[300],
                  min: minimum.toDouble(),
                  max: maximum.toDouble(),
                  values: rangeValues,
                  labels: isDoubleValue ?
                  RangeLabels(rangeValues.start.toStringAsFixed(2), rangeValues.end.toStringAsFixed(2)) :
                  RangeLabels(rangeValues.start.toInt().toString(), rangeValues.end.toInt().toString()),
                  onChanged: (values){
                    setState(() {
                      selectedSliderAttributeValues[attributeName] = values;
                      // Must also update bloc here with continous values
                      _advancedSearchBloc.add(AdvancedSearchFiltersChanged(
                          selectedFilters: {attributeName: _getSelectedSliderAttributeValues(numericalValues, values, isDoubleValue)}));
                    });
                  }
              ),
            ),
          ],
        ),
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
                  if(selectedIndices.contains(index)) selectedIndices.remove(index);
                  else selectedIndices.add(index);

                  selectedAttributeNameValueIndices[attributeName] = selectedIndices;
                  _advancedSearchBloc.add(AdvancedSearchFiltersChanged(
                      selectedFilters: {attributeName: _getSelectedAttributeValues(attributeValues, selectedIndices)}));
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

  List<String> _getSelectedAttributeValues(List<String> values, List<int> selectedIndices) {
    var selectedTypes = List<String>();
    for (var i = 0; i < selectedIndices.length; i++) {
      selectedTypes.add(values[selectedIndices[i]]);
    }
    return selectedTypes;
  }

  List<String> _getSelectedSliderAttributeValues(List<double> values, RangeValues rangeValues, bool isDoubleValue) {
    return values
        .where((element) =>
          element >= (isDoubleValue ? rangeValues.start : rangeValues.start.toInt())
              && element <= (isDoubleValue ? rangeValues.end : rangeValues.end.toInt()))
        .toList()
        .map((e) => isDoubleValue ? e.toString() : e.toInt().toString())
        .toList();
  }
}