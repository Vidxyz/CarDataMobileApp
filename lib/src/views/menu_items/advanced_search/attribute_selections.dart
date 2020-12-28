import 'package:car_data_app/src/blocs/advanced_search_bloc/advanced_search_bloc.dart';
import 'package:car_data_app/src/blocs/advanced_search_bloc/advanced_search_state.dart';
import 'package:car_data_app/src/blocs/attribute_values_bloc/attribute_values_bloc.dart';
import 'package:car_data_app/src/blocs/attribute_values_bloc/attribute_values_event.dart';
import 'package:car_data_app/src/blocs/attribute_values_bloc/attribute_values_state.dart';
import 'package:car_data_app/src/blocs/more_attribute_values_bloc/more_attribute_values_bloc.dart';
import 'package:car_data_app/src/blocs/more_attribute_values_bloc/more_attribute_values_event.dart';
import 'package:car_data_app/src/blocs/more_attribute_values_bloc/more_attribute_values_state.dart';
import 'package:car_data_app/src/views/menu_items/advanced_search/advanced_search_body.dart';
import 'package:car_data_app/src/views/menu_items/advanced_search/attribute_values_grid.dart';
import 'package:car_data_app/src/views/menu_items/advanced_search/attribute_values_list.dart';
import 'package:car_data_app/src/views/menu_items/advanced_search/attribute_values_slider.dart';
import 'package:car_data_app/src/views/menu_items/advanced_search/attribute_values_grid_with_one_selection.dart';
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

  static final List<String> listAttributes = [
    "make",
    "fuel_type",
    "engine_descriptor",
    "type",
    "vehicle_class"
  ];
  static final List<String> gridAttributes = [
    "fuel_type_primary",
    "fuel_type_secondary"
  ];
  static final List<String> integerSliderAttributes = [
    "year",
    "cylinders"
  ];
  static final List<String> doubleSliderAttributes = ["displacement"];

  static final List<String> displayNames = [
    "Make",
    "Year",
    "Vehicle Type",
    "Primary Fuel",
    "Secondary Fuel",
    "Fuel Grade",
    "Engine",
    "Transmission",
    "Cylinders",
    "Displacement"
  ];
  static final List<String> attributesToDisplayListsFor = [
    "make",
    "year",
    "vehicle_class",
    "fuel_type_primary",
    "fuel_type_secondary",
    "fuel_type",
    "engine_descriptor",
    "type",
    "cylinders",
    "displacement"
  ];


  static final List<String> moreDisplayNames = [
    "City Mpg",
    "Highway Mpg",
    "Combined Mpg",
    "Annual Fuel Cost (\$)",
    "Fuel Economy Score",
    "CO2 Emissions",
    "Greenhouse Gas Score"
  ];
  static final List<String> moreAttributesToDisplayListsFor = [
    "city_mpg_primary",
    "highway_mpg_primary",
    "combined_mpg_primary",
    "annual_fuel_cost_primary",
    "fuel_economy_score",
    "tailpipe_co2_primary",
    "gh_gas_score_primary"
  ];

  static final List<String> yesNoDisplayAttributes = ["Supercharged", "Turbocharged", "Guzzler"];
  static final List<String> yesNoRawAttributes = ["is_supercharged", "is_turbocharged", "is_guzzler"];
  static final List<String> yesNoOptions = ["Yes", "No"];

  AttributeValuesBloc _attributeValuesBloc;
  MoreAttributeValuesBloc _moreAttributeValuesBloc;

  String sortOrder = "Descending";
  String sortOrderKey = "sort_order";

  @override
  void initState() {
    super.initState();
    _attributeValuesBloc = BlocProvider.of<AttributeValuesBloc>(context);
    _moreAttributeValuesBloc = BlocProvider.of<MoreAttributeValuesBloc>(context);

    _attributeValuesBloc.add(AttributeValuesRequested());
    _moreAttributeValuesBloc.add(MoreAttributeValuesRequested());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdvancedSearchBloc, AdvancedSearchState>(
      builder: (BuildContext context, AdvancedSearchState state) {
        if (state is AdvancedSearchCriteriaChanged || state is AdvancedSearchEmpty){
          return Expanded(
            child: Container(
              padding: EdgeInsets.only(top: 10),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: attributesToDisplayListsFor.length + yesNoDisplayAttributes.length + 1, // +1 for more attributes
                itemBuilder: (_, index) {
                  if (index < attributesToDisplayListsFor.length)
                    return Card(child: _displayAttributesNameValuesToUser(displayNames[index], attributesToDisplayListsFor[index]));
                  else if (index >= attributesToDisplayListsFor.length && index < attributesToDisplayListsFor.length + yesNoDisplayAttributes.length)
                    return Card(
                        child: _displayBooleanCriteria(
                            yesNoDisplayAttributes[index - attributesToDisplayListsFor.length],
                            yesNoRawAttributes[index - attributesToDisplayListsFor.length]
                        )
                    );
                  else
                    return Card(child: _displayMoreCriteria());
                },
              ),
            ),
          );
        }
        else if (state is AdvancedSearchLoading) {
          return Expanded(
            child: Center(
                // padding: EdgeInsets.fromLTRB(100, 250, 100, 250),
                child: CircularProgressIndicator()
            ),
          );
        }
        else if (state is AdvancedSearchSuccess){
          if (state.selectedFilters['sort_by'] == null || state.selectedFilters['sort_by'].isEmpty)
            return Expanded(
                child: AdvancedSearchBody(
                  vehicles: state.vehicles,
                  hasReachedMax: state.hasReachedMax,
                  totalResultCount: state.totalResultCount,
                )
            );
          else {
            return Expanded(
                child: AdvancedSearchBody(
                  vehicles: state.vehicles,
                  hasReachedMax: state.hasReachedMax,
                  sortMetric: state.selectedFilters['sort_by'].first,
                  totalResultCount: state.totalResultCount,
                )
            );
          }
        }
        else {
          print("This should NOT be reached....");
          return Container();
        }
      }
    );
  }

  Widget _displayBooleanCriteria(String displayName, String filterKey) {
    return ExpansionTile(
        title: Text(
          displayName,
          textAlign: TextAlign.start,
          style: TextStyle(
            fontSize: 18.0,
          ),
        ),
        children: <Widget> [
          AttributeValuesGridWithOneSelection(
            attributeName: filterKey,
            displayAttributeValues: yesNoOptions,
          )
        ]
    );
  }

  Widget _displayMoreCriteria() {
    return ExpansionTile(
        title: Text(
          "More Attributes",
          textAlign: TextAlign.start,
          style: TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.bold
          ),
        ),
        children: <Widget> [
          BlocBuilder<MoreAttributeValuesBloc, MoreAttributeValuesState>(
            builder: (BuildContext context, MoreAttributeValuesState state) {
              if(state is MoreAttributeValuesLoading) {
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
              else if (state is MoreAttributeValuesSuccess) {
                return Flex(
                    direction: Axis.vertical,
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: 10),
                        child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: moreAttributesToDisplayListsFor.length,
                          itemBuilder: (_, index) {
                          final attributeName = moreAttributesToDisplayListsFor[index];
                            return ExpansionTile(
                                title: Text(
                                moreDisplayNames[index],
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 18.0,
                                ),
                              ),
                              children: [
                                AttributeValuesSlider(
                                  attributeName: attributeName,
                                  attributeValues: state.attributeValues.attributeValues[attributeName],
                                  isDoubleValue: attributeName == "tailpipe_co2_primary"
                                )
                              ]
                            );
                          },
                        ),
                      )
                    ]
                );
              }
              else { // this should not be reached ideally
                print("This shouldn't be reached...");
                return Container();
              }
            }
          )
        ]
    );
  }

  Widget _displayAttributesNameValuesToUser(String displayName, String attributeName) {
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
                      attributeValues: state.attributeValues.attributeValues[attributeName],
                      shouldShowSearchBar: attributeName != "fuel_type");

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
                      attributeValues: state.attributeValues.attributeValues[attributeName],
                      shouldShowSearchBar: attributeName != "fuel_type");
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
}