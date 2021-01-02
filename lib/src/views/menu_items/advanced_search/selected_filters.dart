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

  static final double minHeight = 50;
  static final double maxHeight = 200;
  static final String sortOrderKey = "sort_order";

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
    "vehicle_class": "Vehicle Type",
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
  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
    _advancedSearchBloc = BlocProvider.of<AdvancedSearchBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          isExpanded = !isExpanded;
        });
      },
      child: AnimatedContainer(
        constraints: BoxConstraints(
          maxHeight: isExpanded ? maxHeight * 2 : maxHeight,
        ),
        duration: Duration(milliseconds: 300),
        child: Container(
          decoration: BoxDecoration(border: Border.all(color: Colors.tealAccent)),
          child: BlocBuilder<AdvancedSearchBloc, AdvancedSearchState>(
            builder: (BuildContext context, AdvancedSearchState state) {
              if (state is AdvancedSearchEmpty) {
                return _addFiltersView();
              }
              else if (state is AdvancedSearchCriteriaChanged) {
                selectedFilters = state.selectedFilters;
                if(selectedFilters.entries.where((element) =>
                    element.value.isNotEmpty
                        && element.key != sortOrderKey).isEmpty)
                  return _addFiltersView();
                else
                  return _selectedFilters(selectedFilters);
              }
              else {
                return _selectedFilters(selectedFilters);
              }
            }
          ),
        ),
      ),
    );
  }

  Widget _addFiltersView() {
    return Container(
      height: minHeight,
      child: ListView(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: [
          Container(
            margin: EdgeInsets.only(top: 15, bottom: 15),
            child: Center(
              child:
                Text(
                  "Add a filter to search by",
                  style: TextStyle(fontSize: 15),
                ),
            ),
          )
        ],
      ),
    );
  }

  Widget _selectedFilters(Map<String, List<String>> filters) {
    final f = Map<String, List<String>>.from(filters);
    // filter out the KVP for sort order as we dont want to show this separately
    f.removeWhere((key, value) => value.isEmpty || key == sortOrderKey);
    final keys = f.keys.toList();
    return Padding(
      padding: EdgeInsets.all(10),
      child: ListView.builder(
        itemCount: f.length,
        shrinkWrap: true,
        itemBuilder: (_, index) {
          return displaySelectedAttributeValues(
              attributeNamesToDisplayNames[keys[index]],
              keys[index],
              f[keys[index]]
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
                          attributeName: attributeName,
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
                  attributeValues.forEach((attributeValue) {
                      _advancedSearchBloc.add(
                        AdvancedSearchFilterRemoved(
                          attributeName: attributeName,
                          attributeValue: attributeValue));
                     }
                    );
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
    if(displayAttributeName == "Sort") {
      final sortOrder = selectedFilters[sortOrderKey] == null ? "Descending" :
      (selectedFilters[sortOrderKey].isEmpty ? "Descending" : selectedFilters[sortOrderKey].first);
      return attributeValues
          .map((attributeValue) => _displaySingleAttributeValue("$attributeValue - $sortOrder", displayAttributeName))
          .toList();
    }
    else {
      return attributeValues
          .map((attributeValue) => _displaySingleAttributeValue(attributeValue, displayAttributeName))
          .toList();
    }
  }

  Widget  _displaySingleAttributeValue(String attributeValue, String displayAttributeName) =>
    Stack(
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
              attributeValue + " ",
              style: TextStyle(fontSize: 15, color: Colors.white),
            ),
          ),
          Positioned(
            right: 2.5,
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
                  radius: 7.5,
                  backgroundColor: Colors.red,
                  child: Icon(Icons.close, color: Colors.white, size: 13.5,),
                ),
              ),
            ),
          ),
        ]
    );
}