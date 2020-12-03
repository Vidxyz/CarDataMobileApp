import 'package:car_data_app/src/utils/Utils.dart';
import 'package:car_data_app/src/views/advanced_search/attribute_selections.dart';
import 'package:car_data_app/src/views/advanced_search/selected_filters.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdvancedSearch extends StatefulWidget {

  @override
  State createState() {
    return _AdvancedSearch();
  }
}

class _AdvancedSearch extends State<AdvancedSearch> {

  double screenWidth, screenHeight;

  @override
  void initState() {
    super.initState();
    // _appPropertiesBloc = BlocProvider.of<AppPropertiesBloc>(context);
    // print("App bar update command being sent now");
    // _appPropertiesBloc.updateTitle("Search Vehicles");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    screenHeight = Utils.getScreenHeight(context);
    screenWidth = Utils.getScreenWidth(context);
  }


  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(child: SelectedFilters()),
          Container(
            child: AttributeSelectionFilters(),
          )
        ],
    );
  }

}