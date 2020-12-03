import 'package:car_data_app/src/blocs/attribute_values_bloc/attribute_values_bloc.dart';
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

  AttributeValuesBloc _attributeSearchBloc;

  List<int> selectedPrimaryFuelTypeIndices = new List();

  @override
  void initState() {
    super.initState();
    print("AttributeSelectionFiltersState init state method");
    _attributeSearchBloc = BlocProvider.of<AttributeValuesBloc>(context);
    // _attributeSearchBloc.add(AttributeValuesRequested());
    // print("AttributeSelectionFiltersState added event to bloc");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _createAttributeValues("Primary Fuel Type")
      ],
    );

  }

  Widget _createAttributeValues(String attributeName) {
    return ExpansionTile(
        title: Text(
          attributeName,
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
                return _primaryFuelTypeValues(state.attributeValues.fuelTypePrimary);
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

  Widget _primaryFuelTypeValues(List<String> attributeValues) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: attributeValues.length,
      itemBuilder: (_, index) {
        return Container(
          margin: EdgeInsets.only(left:17),
          child: GestureDetector(
            onTap: () => setState(() {
              if(selectedPrimaryFuelTypeIndices.contains(index))
                selectedPrimaryFuelTypeIndices.remove(index);
              else
                selectedPrimaryFuelTypeIndices.add(index);
            }),
            child: Container(
              padding: EdgeInsets.only(top: 5),
              child: Text(
                  attributeValues[index],
                  style: TextStyle(
                    color: selectedPrimaryFuelTypeIndices.contains(index) ? Colors.blue : Colors.white
                  )),
            ),
          ),
        );
      },
    );
  }
}