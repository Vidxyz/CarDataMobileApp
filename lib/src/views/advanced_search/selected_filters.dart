import 'package:car_data_app/src/blocs/advanced_search_bloc/advanced_search_bloc.dart';
import 'package:car_data_app/src/blocs/advanced_search_bloc/advanced_search_event.dart';
import 'package:car_data_app/src/blocs/advanced_search_bloc/advanced_search_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiver/iterables.dart';

class SelectedFilters extends StatefulWidget {

  @override
  State createState() {
    return _SelectedFilters();
  }
}

class _SelectedFilters extends State<SelectedFilters> {

  static final List<String> intRangeAttributes = [
    "city_mpg_primary",
    "combined_mpg_primary",
    "highway_mpg_primary",
    "fuel_economy_score",
    "gh_gas_score_primary",
    "annual_fuel_cost_primary",
  ];

  static final List<String> doubleRangeAttributes = [
    "cylinders",
    "displacement",
    "tailpipe_co2_primary",
  ];

  static final Map<String, String> attributeNamesToDisplayNames = {
    "fuel_type_primary": "Primary Fuel",
    "fuel_type_secondary": "Secondary Fuel",
    "fuel_type": "Fuel Grade",
    "engine_descriptor": "Engine",
    "type": "Transmission",
    "cylinders": "Cylinders",
    "displacement": "Displacement",
    "make": "Make",
    "year": "Year",
    "sort_by": "Sort",
    "is_supercharged": "Supercharged",
    "is_turbocharged": "Turbocharged",
    "is_guzzler": "Guzzler",
    "annual_fuel_cost_primary": "Annual Fuel Cost",
    "city_mpg_primary": "City Mpg",
    "combined_mpg_primary": "Combined Mpg",
    "highway_mpg_primary": "Highway Mpg",
    "fuel_economy_score": "Fuel Economy Score",
    "tailpipe_co2_primary": "CO2 Emissions",
    "gh_gas_score_primary": "Greenhouse Gas Score",
  };

  AdvancedSearchBloc _advancedSearchBloc;
  Map<String, List<String>> selectedFilters = {};

  @override
  void initState() {
    super.initState();
    _advancedSearchBloc = BlocProvider.of<AdvancedSearchBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
          minHeight: 50,
          maxHeight: 200.0
      ),
      child: Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.white)),
        child: BlocBuilder<AdvancedSearchBloc, AdvancedSearchState>(
          builder: (BuildContext context, AdvancedSearchState state) {
            if (state is AdvancedSearchEmpty) {
              return Container();
            }
            else if (state is AdvancedSearchCriteriaChanged) {
              selectedFilters = state.selectedFilters;
              return _selectedFilters(state.selectedFilters);
            }
            else {
              return _selectedFilters(selectedFilters);
            }
          }
        ),
      ),
    );
  }

  Widget _selectedFilters(Map<String, List<String>> filters) {
    filters.removeWhere((key, value) => value.isEmpty);
    final keys = filters.keys.toList();
    return Padding(
      padding: EdgeInsets.all(10),
      child: ListView.builder(
        itemCount: filters.length,
        itemBuilder: (_, index) {
          return displaySelectedAttributeValues(
              attributeNamesToDisplayNames[keys[index]],
              keys[index],
              filters[keys[index]]
          );
        }
      ),
    );
  }

  Widget displaySelectedAttributeValues(
      String displayAttributeName,
      String attributeName,
      List<String> attributeValues) {
    return Container(
      padding: EdgeInsets.only(bottom: 2.5),
      child: Wrap(
        direction: Axis.horizontal,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 5),
            child: Text(
              displayAttributeName,
              style: TextStyle(
                color: Colors.redAccent[200],
                fontSize: 15,
                fontWeight: FontWeight.bold
              )
            ),
          ),
          // Gap()
        ]
          + (intRangeAttributes.contains(attributeName) ?
            _displayRangeAttributeValues(displayAttributeName, attributeName, attributeValues, false) :
            (doubleRangeAttributes.contains(attributeName) ?
            _displayRangeAttributeValues(displayAttributeName, attributeName, attributeValues, true) :
            _displayAttributeValues(displayAttributeName, attributeValues))
            ),
      ),
    );
  }

  List<Widget> _displayRangeAttributeValues(
      String displayAttributeName, String attributeName, List<String> attributeValues, bool isDouble) {
    if (attributeValues.length == 1) {
      return attributeValues.map((attributeValue) => Stack(
          children: [
            Container(
              padding: EdgeInsets.only(right: 15, left: 5),
              decoration: BoxDecoration(
                  color: Colors.teal[700],
                  border: Border.all(
                      color: Colors.teal[700],
                      width: 1
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(10))
              ),
              child: Text(
                attributeValue,
                style: TextStyle(fontSize: 15, color: Colors.white),
              ),
            ),
            Positioned(
              right: 5.0,
              top: 1,
              child: GestureDetector(
                onTap: (){
                  _advancedSearchBloc.add(
                      AdvancedSearchFilterRemoved(
                          attributeName: attributeNamesToDisplayNames.keys.firstWhere((element) => attributeNamesToDisplayNames[element] == displayAttributeName),
                          attributeValue: attributeValue));
                },
                child: Align(
                  alignment: Alignment.topRight,
                  child: CircleAvatar(
                    radius: 5.0,
                    backgroundColor: Colors.red,
                    child: Icon(Icons.close, color: Colors.white, size: 10,),
                  ),
                ),
              ),
            ),
          ]
      )).toList();
    }
    else {
      var minimum =  isDouble ?
      min(attributeValues.map((e) => double.parse(e)).toList()) :
      min(attributeValues.map((e) => int.parse(e)).toList());
      var maximum = isDouble ?
      max(attributeValues.map((e) => double.parse(e)).toList()) :
      max(attributeValues.map((e) => int.parse(e)).toList());
      return [Stack(
          children: [
            Container(
              padding: EdgeInsets.only(right: 15, left: 5),
              decoration: BoxDecoration(
                  color: Colors.teal[700],
                  border: Border.all(
                      color: Colors.teal[700],
                      width: 1
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(10))
              ),
              child: Text(
                isDouble ? "${minimum.toStringAsFixed(2)} - ${maximum.toStringAsFixed(2)}" : "$minimum - $maximum",
                style: TextStyle(fontSize: 15, color: Colors.white),
              ),
            ),
            Positioned(
              right: 5.0,
              top: 1,
              child: GestureDetector(
                onTap: (){
                  _advancedSearchBloc.add(AdvancedSearchFiltersChanged(
                      selectedFilters: {attributeName: []}));
                },
                child: Align(
                  alignment: Alignment.topRight,
                  child: CircleAvatar(
                    radius: 5.0,
                    backgroundColor: Colors.red,
                    child: Icon(Icons.close, color: Colors.white, size: 10,),
                  ),
                ),
              ),
            ),
          ]
      )
      ];
    }
  }


  List<Widget> _displayAttributeValues(String displayAttributeName, List<String> attributeValues) {
    return attributeValues.map((attributeValue) => Stack(
      children: [
        Container(
        padding: EdgeInsets.only(right: 15, left: 5),
        decoration: BoxDecoration(
          color: Colors.teal[700],
          border: Border.all(
            color: Colors.teal[700],
            width: 1
          ),
          borderRadius: BorderRadius.all(Radius.circular(10))
        ),
        child: Text(
          attributeValue,
          style: TextStyle(fontSize: 15, color: Colors.white),
          ),
        ),
        Positioned(
          right: 5.0,
          top: 1,
          child: GestureDetector(
            onTap: (){
              _advancedSearchBloc.add(
                  AdvancedSearchFilterRemoved(
                      attributeName: attributeNamesToDisplayNames.keys.firstWhere((element) => attributeNamesToDisplayNames[element] == displayAttributeName),
                      attributeValue: attributeValue));
            },
            child: Align(
              alignment: Alignment.topRight,
              child: CircleAvatar(
                radius: 5.0,
                backgroundColor: Colors.red,
                child: Icon(Icons.close, color: Colors.white, size: 10,),
                ),
              ),
            ),
          ),
        ]
      )
    ).toList();
  }
}