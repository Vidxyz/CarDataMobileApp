import 'package:car_data_app/src/blocs/attribute_values_bloc/attribute_values_bloc.dart';
import 'package:car_data_app/src/blocs/attribute_values_bloc/attribute_values_event.dart';
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
class _AttributeSelectionFiltersState extends State<AttributeSelectionFilters> {

  AttributeValuesBloc _attributeSearchBloc;

  @override
  void initState() {
    super.initState();
    print("AttributeSelectionFiltersState init state method");
    _attributeSearchBloc = BlocProvider.of<AttributeValuesBloc>(context);
    _attributeSearchBloc.add(AttributeValuesRequested());
    print("AttributeSelectionFiltersState added event to bloc");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ExpansionTile(
          title: Text(
            "Primary Fuel Type",
            textAlign: TextAlign.start,
            style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.bold
            ),
          ),
          children: <Widget> [
            BlocBuilder<AttributeValuesBloc, AttributeValuesState>(
              builder: (BuildContext context, AttributeValuesState state) {
                print(state.toString());
                if(state is AttributeValuesLoading) {
                  return Container(
                      padding: EdgeInsets.fromLTRB(100, 250, 100, 250),
                      child: CircularProgressIndicator()
                  );
                }
                if (state is AttributeValuesSuccess) {
                  print("Successful search!");
                  print(state.attributeValues);
                  return Container();
                }
                else {
                  print(state.toString());
                  return Container();
                }
              },
            )
          ]),
    );
  }
}