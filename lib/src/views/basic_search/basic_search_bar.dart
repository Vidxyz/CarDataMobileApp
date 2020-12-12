import 'package:car_data_app/src/blocs/vehicle_search_bloc/vehicle_search_bloc.dart';
import 'package:car_data_app/src/blocs/vehicle_search_bloc/vehicle_search_event.dart';
import 'package:car_data_app/src/models/search_suggestion.dart';
import 'package:car_data_app/src/repo/repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class BasicSearchBar extends StatefulWidget {

  @override
  State createState() {
    return BasicSearchBarState();
  }
}

class BasicSearchBarState extends State<BasicSearchBar> {

  VehicleSearchBloc _vehicleSearchBloc;

  final _searchTextController = TextEditingController();
  final _suggestionsController = SuggestionsBoxController();
  final _repo = Repo();

  bool shouldShow = false;

  @override
  void initState() {
    super.initState();
    _vehicleSearchBloc = BlocProvider.of<VehicleSearchBloc>(context);
  }

  @override
  void dispose() {
    _searchTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10.0),
        child: TypeAheadField<SearchSuggestion>(
          suggestionsBoxController: _suggestionsController,
          textFieldConfiguration: TextFieldConfiguration(
              onTap: () => _suggestionsController.toggle(),
              onChanged: (text) {
                shouldShow = true;
              },
              autofocus: true,
              controller: _searchTextController,
              style: DefaultTextStyle.of(context).style.copyWith(fontSize: 15),
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Search by make/model/year",
                  suffixIcon: IconButton(
                    onPressed: () {
                      _suggestionsController.close();
                      shouldShow = false;
                      _vehicleSearchBloc.add(SearchQueryReset());
                      // This is so that debounce filter is avoided
                      Future.delayed(Duration(milliseconds: 350), () =>
                          _vehicleSearchBloc.add(
                              SearchQueryChanged(
                                  text: _searchTextController.value.text
                              )));
                    },
                    icon: Icon(Icons.search),
                  )
              )
          ),
          suggestionsCallback: (pattern) {
            if(shouldShow) return _repo.getSuggestions(pattern);
            else return List.empty();
          },
          itemBuilder: (context, suggestion) {
            final s = suggestion;
            return ListTile(
              leading: Icon(Icons.directions_car),
              title: Text(s.make + " " + s.model),
              subtitle: Text(s.year.toString()),
            );
          },
          onSuggestionSelected: (suggestion) => _searchTextController.text = suggestion.toString(),
          hideOnEmpty: true,
        )
    );
  }
}