import 'package:car_data_app/src/blocs/advanced_search_bloc/advanced_search_bloc.dart';
import 'package:car_data_app/src/blocs/advanced_search_bloc/advanced_search_state.dart';
import 'package:car_data_app/src/blocs/attribute_values_bloc/attribute_values_bloc.dart';
import 'package:car_data_app/src/blocs/attribute_values_bloc/attribute_values_event.dart';
import 'package:car_data_app/src/blocs/attribute_values_bloc/attribute_values_state.dart';
import 'package:car_data_app/src/views/advanced_search/attribute_values_grid.dart';
import 'package:car_data_app/src/views/advanced_search/attribute_values_list.dart';
import 'package:car_data_app/src/views/advanced_search/attribute_values_slider.dart';
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

  static final List<String> listAttributes = ["make", "fuel_type", "engine_descriptor", "type"];
  static final List<String> gridAttributes = ["fuel_type_primary", "fuel_type_secondary"];
  static final List<String> integerSliderAttributes = ["year", "cylinders"];
  static final List<String> doubleSliderAttributes = ["displacement"];

  static final List<String> displayNames = ["Make", "Year", "Primary Fuel",
    "Secondary Fuel", "Fuel Grade", "Engine", "Transmission", "Cylinders", "Displacement"];

  static final List<String> attributesToDisplayListsFor = ["make", "year", "fuel_type_primary",
    "fuel_type_secondary", "fuel_type", "engine_descriptor", "type",  "cylinders", "displacement"];

  AttributeValuesBloc _attributeValuesBloc;

  Map<String, List<int>> selectedAttributeNameValueIndices = {
    "fuel_type_primary": List<int>(),
    "fuel_type_secondary": List<int>(),
    "fuel_type": List<int>(),
    "type": List<int>(),
    "make": List<int>(),
    "engine_descriptor": List<int>(),
  };

  // todo - refactor so that individual widgets fetch their attribute values separately, instead of all at once
  // todo - add remaining attributes as well, (sliders as well as means to sort by
  @override
  void initState() {
    super.initState();
    print("AttributeSelectionFiltersState init state method");
    _attributeValuesBloc = BlocProvider.of<AttributeValuesBloc>(context);
    _attributeValuesBloc.add(AttributeValuesRequested());
  }

  @override
  Widget build(BuildContext context) {
    print("Attribute selections build method called");
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
                        return AttributeValuesList(
                            attributeName: attributeName,
                            attributeValues: state.attributeValues.attributeValues[attributeName]);

                      else if(gridAttributes.contains(attributeName))
                        return AttributeValuesGrid(
                            attributeName: attributeName,
                            attributeValues: state.attributeValues.attributeValues[attributeName]);

                      else if(integerSliderAttributes.contains(attributeName))
                        return AttributeValuesSlider(
                            attributeName: attributeName,
                            attributeValues: state.attributeValues.attributeValues[attributeName],
                            isDoubleValue: false);

                      else if(doubleSliderAttributes.contains(attributeName))
                        return AttributeValuesSlider(
                            attributeName: attributeName,
                            attributeValues: state.attributeValues.attributeValues[attributeName],
                            isDoubleValue: true);

                      else // This should ideally not be reached
                        return AttributeValuesList(
                            attributeName: attributeName,
                            attributeValues: state.attributeValues.attributeValues[attributeName]);
                    }
                    else { // this should not be reached ideally
                      print("This shouldn't be reached...");
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
}