import 'package:car_data_app/src/blocs/advanced_search_bloc/advanced_search_bloc.dart';
import 'package:car_data_app/src/blocs/advanced_search_bloc/advanced_search_event.dart';
import 'package:car_data_app/src/blocs/advanced_search_bloc/advanced_search_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiver/iterables.dart';

class AttributeValuesSlider extends StatefulWidget {
  final String attributeName;
  final List<String> attributeValues;
  final bool isDoubleValue;

  AttributeValuesSlider({Key key, this.attributeName, this.attributeValues, this.isDoubleValue}):
        super(key: key);

  @override
  State createState() {
    return _AttributeValuesSliderState();
  }
}

class _AttributeValuesSliderState extends State<AttributeValuesSlider> {

  AdvancedSearchBloc _advancedSearchBloc;

  Map<String, RangeValues> _selectedSliderAttributeValues = {
    "year": RangeValues(1984, 2021),
    "displacement": RangeValues(0, 8.4),
    "cylinders": RangeValues(2, 16),
    "annual_fuel_cost_primary": RangeValues(450, 6000),
    "city_mpg_primary": RangeValues(6, 150),
    "combined_mpg_primary": RangeValues(7, 141),
    "highway_mpg_primary": RangeValues(9, 132),
    "fuel_economy_score": RangeValues(1, 10),
    "tailpipe_co2_primary": RangeValues(0, 1269.58),
    "gh_gas_score_primary": RangeValues(1, 10),
  };

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
      if(selectedAttributeValues != null) {
        _selectedSliderAttributeValues[widget.attributeName] =
            RangeValues(double.parse(selectedAttributeValues.first), double.parse(selectedAttributeValues.last));
      }
      else {
        _selectedSliderAttributeValues = {
          "year": RangeValues(1984, 2021),
          "displacement": RangeValues(0, 8.4),
          "cylinders": RangeValues(2, 16),
          "annual_fuel_cost_primary": RangeValues(450, 6000),
          "city_mpg_primary": RangeValues(6, 150),
          "combined_mpg_primary": RangeValues(7, 141),
          "highway_mpg_primary": RangeValues(9, 132),
          "fuel_economy_score": RangeValues(1, 10),
          "tailpipe_co2_primary": RangeValues(0, 1269.58),
          "gh_gas_score_primary": RangeValues(1, 10),
        };
      }
    }
    else {
      _selectedSliderAttributeValues =  {
        "year": RangeValues(1984, 2021),
        "displacement": RangeValues(0, 8.4),
        "cylinders": RangeValues(2, 16),
        "annual_fuel_cost_primary": RangeValues(450, 6000),
        "city_mpg_primary": RangeValues(6, 150),
        "combined_mpg_primary": RangeValues(7, 141),
        "highway_mpg_primary": RangeValues(9, 132),
        "fuel_economy_score": RangeValues(1, 10),
        "tailpipe_co2_primary": RangeValues(0, 1269.5),
        "gh_gas_score_primary": RangeValues(1, 10),
      };
    }

    List<double> numericalValues = widget.attributeValues
        .where((element) => element != null)
        .toList()
        .map((e) => double.parse(e))
        .toList();
    var minimum = min(numericalValues);
    var maximum = max(numericalValues);
    final rangeValues = _selectedSliderAttributeValues[widget.attributeName];
    return Container(
      padding: EdgeInsets.only(bottom: 10),
      child: Column(
        children: [
          Center(
            child: Text(
              widget.isDoubleValue ?
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
                activeColor: Colors.teal[700],
                inactiveColor: Colors.tealAccent[300],
                min: minimum.toDouble(),
                max: maximum.toDouble(),
                values: rangeValues,
                labels: widget.isDoubleValue ?
                RangeLabels(rangeValues.start.toStringAsFixed(2), rangeValues.end.toStringAsFixed(2)) :
                RangeLabels(rangeValues.start.toInt().toString(), rangeValues.end.toInt().toString()),
                onChanged: (values){
                  setState(() {
                    _selectedSliderAttributeValues[widget.attributeName] = values;
                    // Must also update bloc here with continous values
                    _advancedSearchBloc.add(AdvancedSearchFiltersChanged(
                        selectedFilters: {widget.attributeName:
                        _getSelectedSliderAttributeValues(numericalValues, values, widget.isDoubleValue)}));
                  });
                }
            ),
          ),
        ],
      ),
    );
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