import 'package:car_data_app/src/blocs/advanced_search_bloc/advanced_search_bloc.dart';
import 'package:car_data_app/src/blocs/advanced_search_bloc/advanced_search_event.dart';
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

  Map<String, RangeValues> selectedSliderAttributeValues = {
    "year": RangeValues(1984, 2021),
    "displacement": RangeValues(0, 8.4),
    "cylinders": RangeValues(2, 16)
  };

  @override
  void initState() {
    super.initState();
    _advancedSearchBloc = BlocProvider.of<AdvancedSearchBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    List<double> numericalValues = widget.attributeValues
        .where((element) => element != null)
        .toList()
        .map((e) => double.parse(e))
        .toList();
    var minimum = min(numericalValues);
    var maximum = max(numericalValues);
    final rangeValues = selectedSliderAttributeValues[widget.attributeName];
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
                activeColor: Colors.blue[700],
                inactiveColor: Colors.blueAccent[300],
                min: minimum.toDouble(),
                max: maximum.toDouble(),
                values: rangeValues,
                labels: widget.isDoubleValue ?
                RangeLabels(rangeValues.start.toStringAsFixed(2), rangeValues.end.toStringAsFixed(2)) :
                RangeLabels(rangeValues.start.toInt().toString(), rangeValues.end.toInt().toString()),
                onChanged: (values){
                  setState(() {
                    selectedSliderAttributeValues[widget.attributeName] = values;
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