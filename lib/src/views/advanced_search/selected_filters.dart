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

  AdvancedSearchBloc _advancedSearchBloc;

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
            if (state is AdvancedSearchCriteriaChanged) {
              print(state.selectedFilters);
              return Container();
            }
            else {
              return Container();
            }
          }
        ),
      ),
    );
  }

}