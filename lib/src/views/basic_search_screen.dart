import 'package:car_data_app/src/blocs/vehicle_images_bloc/vehicle_images_bloc.dart';
import 'package:car_data_app/src/blocs/vehicle_search_bloc/vehicle_search_bloc.dart';
import 'package:car_data_app/src/blocs/vehicle_search_bloc/vehicle_search_event.dart';
import 'package:car_data_app/src/blocs/vehicle_search_bloc/vehicle_search_state.dart';
import 'package:car_data_app/src/models/search_suggestion.dart';
import 'package:car_data_app/src/models/vehicle.dart';
import 'package:car_data_app/src/repo/repo.dart';
import 'package:car_data_app/src/views/vehicle_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';


class BasicSearchScreen extends StatefulWidget {

  @override
  State createState() {
    return _BasicSearchScreenState();
  }
}

class _BasicSearchScreenState extends State<BasicSearchScreen> {

  // this is so that the framework doesn't dispose
  // @override
  // bool wantKeepAlive = true;
  // todo - evaluate if changing app bar title is even required, and if so, how to get around the fact that it is a stack of operations
  // todo - uniformity in sub widgets being classes or methods

  static final int pageSize = 15;
  VehicleSearchBloc _vehicleSearchBloc;
  // AppPropertiesBloc _appPropertiesBloc;
  Repo repo;

  List<Vehicle> vehicleList = new List<Vehicle>();
  bool isLoading = false;
  String searchText = "";
  int pageCount = 0;
  bool shouldShow = false;

  TextEditingController _searchTextController;
  SuggestionsBoxController _suggestionsController;

  @override
  void initState() {
    print("Init method called");
    super.initState();
    _searchTextController = TextEditingController();
    _suggestionsController = SuggestionsBoxController();
    _vehicleSearchBloc = BlocProvider.of<VehicleSearchBloc>(context);
    repo = Repo();

    // _appPropertiesBloc = BlocProvider.of<AppPropertiesBloc>(context);
    // print("App bar update command being sent now");
    // _appPropertiesBloc.updateTitle("Find Vehicles");
    print("Init method setup complete");
  }

  @override
  Widget build(BuildContext context) {
    print("Search screen build widget called");
    return _buildSearch(context);
  }

  Widget _buildSearch(BuildContext context) {
    print("Build search is called now");
    final searchWidget = Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _SearchBar(),
        _SearchBody()
      ],
    );

    _searchTextController.text = searchText;
    _searchTextController.value = TextEditingValue(
      text: searchText,
      selection: TextSelection.fromPosition(
        TextPosition(offset: searchText.length),
      ),
    );
    return searchWidget;
  }


  Widget _SearchBar() {
    return Padding(
        padding: const EdgeInsets.all(10.0),
        child: TypeAheadField<SearchSuggestion>(
          suggestionsBoxController: _suggestionsController,
          textFieldConfiguration: TextFieldConfiguration(
              onTap: () => _suggestionsController.toggle(),
              onChanged: (text) {
                searchText = text;
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
                      pageCount = 0;
                      searchText = _searchTextController.value.text;
                      vehicleList = new List();
                      // _vehiclesBloc.searchVehicles(_searchTextController.value.text, pageCount * pageSize, pageSize);
                      _vehicleSearchBloc.add(SearchQueryChanged(text: searchText));
                    },
                    icon: Icon(Icons.search),
                  )
              )
          ),
          suggestionsCallback: (pattern) {
            if(shouldShow) return repo.carDataApiProvider.getSuggestions(pattern);
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

  @override
  void dispose() {
    print("Search screen dispose method called");
    _searchTextController.dispose();
    // _appPropertiesBloc.dispose();
    super.dispose();
  }
}

class _SearchBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VehicleSearchBloc, VehicleSearchState>(
      builder: (BuildContext context, VehicleSearchState state) {
        if (state is SearchStateEmpty) {
          return Expanded(child: Center(child: Text('Search for a vehicle by make/model/year')));
        }
        if (state is SearchStateLoading) {
          return Container(
            padding: EdgeInsets.fromLTRB(100, 250, 100, 250),
            child: CircularProgressIndicator()
          );
        }
        if (state is SearchStateError) {
          return Expanded(child: Center(child: Text(state.error)));
        }
        if (state is SearchStateSuccess) {
          return state.vehicles.isEmpty
              ? Expanded(child: Center(child: Text('No Results')))
              : Expanded(child: _SearchResults(items: state.vehicles));
        }
        else {
          return Center(child: Text("Error: Something went wrong"));
        }
      },
    );
  }
}

class _SearchResults extends StatelessWidget {
  final List<Vehicle> items;

  const _SearchResults({Key key, this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (BuildContext context, int index) {
        return _SearchResultItem(vehicle: items[index]);
      },
    );
  }
}

class _SearchResultItem extends StatelessWidget {
  final Vehicle vehicle;

  const _SearchResultItem({Key key, @required this.vehicle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(vehicle.make + " " + vehicle.model, style: TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text(vehicle.year.toString()),
      leading: Icon(Icons.directions_car, color: Colors.teal),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => BlocProvider(
                  create: (context) => VehicleImagesBloc(repository: Repo()),
                  child: VehicleDetailScreen(vehicle: vehicle),
                )
            )
        );
      },
    );
  }
}

