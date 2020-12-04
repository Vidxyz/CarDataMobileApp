import 'package:car_data_app/src/blocs/advanced_search_bloc/advanced_search_bloc.dart';
import 'package:car_data_app/src/blocs/advanced_search_bloc/advanced_search_event.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AttributeValuesGrid extends StatefulWidget {
  final String attributeName;
  final List<String> attributeValues;
  final bool isDoubleValue;

  AttributeValuesGrid({Key key, this.attributeName, this.attributeValues, this.isDoubleValue}):
        super(key: key);

  @override
  State createState() {
    return _AttributeValuesGridState();
  }
}

class _AttributeValuesGridState extends State<AttributeValuesGrid> {

  AdvancedSearchBloc _advancedSearchBloc;

  List<int> selectedIndices = [];

  @override
  void initState() {
    super.initState();
    _advancedSearchBloc = BlocProvider.of<AdvancedSearchBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: 200,
      ),
      child: Container(
        padding: EdgeInsets.only(bottom: 10),
        child: GridView.count(
          childAspectRatio: 3,
          crossAxisCount: 3,
          shrinkWrap: true,
          children: List.generate(widget.attributeValues.length,
                  (index) =>
                  Container(
                    margin: EdgeInsets.only(left:17),
                    child: GestureDetector(
                      onTap: () => setState(() {
                        if(selectedIndices.contains(index)) selectedIndices.remove(index);
                        else selectedIndices.add(index);

                        _advancedSearchBloc.add(AdvancedSearchFiltersChanged(
                            selectedFilters: {widget.attributeName: _getSelectedAttributeValues(widget.attributeValues, selectedIndices)}));
                      }),
                      child: Container(
                        padding: EdgeInsets.only(top: 5),
                        child: Text(
                            widget.attributeValues[index].toString(),
                            style: TextStyle(
                                color: selectedIndices.contains(index) ? Colors.blue : Colors.white,
                                fontSize: 15
                            )
                        ),
                      ),
                    ),
                  )
          ),
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
}