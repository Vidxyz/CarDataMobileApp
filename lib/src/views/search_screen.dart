import 'package:car_data_app/src/blocs/vehicle_images_bloc.dart';
import 'package:car_data_app/src/models/search_suggestion.dart';
import 'package:car_data_app/src/models/vehicle.dart';
import 'package:car_data_app/src/repo/repo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:car_data_app/src/blocs/vehicles_bloc.dart';
import 'package:car_data_app/src/views/vehicle_detail.dart';
import 'package:car_data_app/src/blocs/bloc_provider.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';


class SearchScreen extends StatefulWidget {

  @override
  State createState() {
    return _SearchScreenState();
  }
}

class _SearchScreenState extends State<SearchScreen> {

  static final int pageSize = 15;
  VehiclesBloc vehiclesBloc;
  Repo repo;

  List<Vehicle> vehicleList = new List<Vehicle>();
  bool isLoading = false;
  String searchText = "";
  int pageCount = 0;
  bool shouldShow = false;

  TextEditingController _searchTextController;
  ScrollController _listScrollController;
  SuggestionsBoxController _suggestionsController;


  @override
  void initState() {
    super.initState();
    _listScrollController = new ScrollController(initialScrollOffset: 5.0)..addListener(_scrollListener);
    _searchTextController = TextEditingController();
    _suggestionsController = SuggestionsBoxController();
    vehiclesBloc = VehiclesBloc();
    repo = Repo();
  }

  // todo - rework this to make sure that fetching is smooth and hiccup free, especially when
  //        new fetches are started when user is already at the bottom of the list view
  _scrollListener() {
    if (_listScrollController.offset >= _listScrollController.position.maxScrollExtent &&
        !_listScrollController.position.outOfRange) {

      if (isLoading) {
        pageCount = pageCount + 1;
        vehiclesBloc.searchVehicles(searchText, pageCount * pageSize, pageSize);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Find Vehicles"),
      ),
      body: _buildSearch(context)
    );
  }


  Widget _buildSearch(BuildContext context) {
    final searchWidget = BlocProvider<VehiclesBloc>(
      bloc: vehiclesBloc,
      child: Column(
        children: <Widget>[
          Padding(
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
                      vehiclesBloc.searchVehicles(_searchTextController.value.text, pageCount * pageSize, pageSize);
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
          ),
          Expanded(
            child: _buildStreamBuilder(vehiclesBloc),
          )
        ],
      ),
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

  Widget _buildStreamBuilder(VehiclesBloc bloc) {
    return StreamBuilder(
      stream: bloc.allVehicles,
      builder: (context, snapshot) {
        final results = snapshot.data;

        if (results == null) return Center(child: Text('Search for a vehicle by make/model/year'));

        vehicleList.addAll(results);

        if (results.length == pageSize) isLoading = true;
        else isLoading = false;

        if (vehicleList.isEmpty) {
          return Center(child: Text('No Results'));
        }
        else return _buildSearchResults(vehicleList);
      },
    );
  }

  Widget _buildSearchResults(List<Vehicle> results) {
    return ListView.builder(
      controller: _listScrollController,
      physics: ScrollPhysics(),
      itemCount: isLoading ? results.length + 1 : results.length,
      itemBuilder: (BuildContext context, int index) {
        if (index == results.length) return Center(child: CircularProgressIndicator());
        else {
          final vehicle = results[index];
          return ListTile(
            title: Text(vehicle.make + " " + vehicle.model, style: TextStyle(fontWeight: FontWeight.w500)),
            subtitle: Text(vehicle.year.toString()),
            leading: Icon(Icons.directions_car, color: Colors.teal),
            onTap: () => openDetailPage(vehicle, context),
          );
        }
      },
    );
  }


  Widget openDetailPage(Vehicle vehicle, BuildContext context) {
    final bloc = VehicleImagesBloc();
    final page = BlocProvider<VehicleImagesBloc>(
        bloc: bloc,
        child: VehicleDetail(vehicle: vehicle)
    );

    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) {
          return page;
        }),
    );
  }

  @override
  void dispose() {
    _listScrollController.dispose();
    _searchTextController.dispose();
    // _suggestionsController.dispose();
    vehiclesBloc.dispose();
    super.dispose();
  }
}
