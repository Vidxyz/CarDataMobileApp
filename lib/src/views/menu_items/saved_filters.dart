import 'dart:convert';

import 'package:car_data_app/src/blocs/saved_filter_bloc/menu_navigation_event.dart';
import 'package:car_data_app/src/blocs/saved_filter_bloc/menu_navigation_bloc.dart';
import 'package:car_data_app/src/models/saved_filter.dart';
import 'package:car_data_app/src/utils/Utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SavedFiltersScreen extends StatefulWidget {

  @override
  State createState() {
    return SavedFiltersScreenState();
  }
}

class SavedFiltersScreenState extends State<SavedFiltersScreen> {

  List<SavedFilter> savedFilters;
  MenuNavigationBloc _menuNavigationBloc;

  @override
  void initState() {
    super.initState();
    _getSavedFiltersFromSharedPrefs();
    _menuNavigationBloc = BlocProvider.of<MenuNavigationBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: savedFilters?.length ?? 0,
      itemBuilder: (BuildContext context, int index) {
        final item = savedFilters[index];
        return Dismissible(
          key: UniqueKey(),
          onDismissed: (direction) {
            savedFilters.removeWhere((element) => element.id == item.id);
            _replaceSavedFiltersSharedPrefs(savedFilters);
            Utils.showSnackBar(
                "Removed ${item.name} from saved filters",
                context
            );
          },
          background: Container(color: Colors.redAccent),
          child: _searchResultItem(item),
        );
      },
    );
  }


  Widget _searchResultItem(SavedFilter savedFilter) {
    return Container(
      padding: EdgeInsets.all(5),
      child: ListTile(
        title: Text(
            savedFilter.name,
            style: TextStyle(fontWeight: FontWeight.w500)
        ),
        trailing: Icon(Icons.format_align_left_sharp),
        subtitle: Container(
          padding: EdgeInsets.only(top: 5),
            margin: EdgeInsets.only(top: 5),
            child:
            Text(
                savedFilter.toString()
            )
        ),
        onTap: () {
          _menuNavigationBloc.add(SavedFilterChosen(selectedFilters: savedFilter.selections));
        },
      ),
    );
  }


  _replaceSavedFiltersSharedPrefs(List<SavedFilter> savedFilters) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setStringList(Utils.SAVED_FILTERS_KEY, savedFilters.map((e) => json.encode(e.toJson())).toList());
  }

  _getSavedFiltersFromSharedPrefs() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    savedFilters = preferences
        .getStringList(Utils.SAVED_FILTERS_KEY)
        ?.map((e) => json.decode(e))
        ?.map((e) => SavedFilter.fromJson(e))
        ?.toList();
    setState(() {});
  }
}