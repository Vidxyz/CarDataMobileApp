import 'package:car_data_app/src/blocs/advanced_search_bloc/advanced_search_bloc.dart';
import 'package:car_data_app/src/blocs/advanced_search_bloc/advanced_search_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SelectedFilters extends StatefulWidget {

  @override
  State createState() {
    return _SelectedFilters();
  }
}

class _SelectedFilters extends State<SelectedFilters> {

  static final Map<String, String> attributeNamesToDisplayNames = {
    "fuel_type_primary": "Primary Fuel",
    "fuel_type_secondary": "Secondary Fuel",
    "fuel_type": "Fuel Grade",
    "engine_descriptor": "Engine",
    "type": "Transmission",
    "cylinders": "Cylinders",
    "displacement": "Displacement",
    "make": "Make",
    "year": "Year"
  };

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
            if (state is AdvancedSearchCriteriaChanged) {
              print(state.selectedFilters);
              return _selectedFilters(state.selectedFilters);
            }
            else {
              return Container();
            }
          }
        ),
      ),
    );
  }

  Widget _selectedFilters(Map<String, List<String>> filters) {
    final keys = filters.keys.toList();
    return Padding(
      padding: EdgeInsets.all(10),
      child: ListView.builder(
        itemCount: filters.length,
        itemBuilder: (_, index) {
          return displaySelectedAttributeValues(attributeNamesToDisplayNames[keys[index]], filters[keys[index]]);
        }
      ),
    );
  }

  // Make it a stateless widget? Also, figure out line wrap issue with years, and why that is the case
  Widget displaySelectedAttributeValues(String attributeName, List<String> attributeValues) {
    return Text(
      "$attributeName : ${attributeValues.join(",")}",
      style: TextStyle(fontSize: 15, color: Colors.tealAccent),
    );
  }
}