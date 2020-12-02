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
  // todo - uniformity in sub widgets being classes or methods -  as well as other niformity
  static final double _scrollThreshold = 200.0;

  VehicleSearchBloc _vehicleSearchBloc;

  List<Vehicle> vehicleList = new List<Vehicle>();
  String searchText = "";
  bool shouldShow = false;

  final _searchTextController = TextEditingController();
  final _suggestionsController = SuggestionsBoxController();
  final _scrollController = ScrollController();

  final repo = Repo();

  @override
  void initState() {
    print("Init method called");
    super.initState();
    _vehicleSearchBloc = BlocProvider.of<VehicleSearchBloc>(context);
    _scrollController.addListener(_onScroll);
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
                      searchText = _searchTextController.value.text;
                      vehicleList = new List();
                      _vehicleSearchBloc.add(SearchQueryReset());
                      // This is so that debounce filter is avoided
                      Future.delayed(Duration(milliseconds: 350), () => _vehicleSearchBloc.add(SearchQueryChanged(text: searchText)));
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

  Widget _SearchBody() {
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
              : Expanded(
              child: SearchResults(state.vehicles, state.hasReachedMax)
          );
        }
        else {
          return Center(child: Text("Error: Something went wrong"));
        }
      },
    );
  }

  Widget SearchResults(List<Vehicle> items, bool hasReachedMax) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: hasReachedMax ? items.length : items.length + 1,
      itemBuilder: (BuildContext context, int index) {
        if (index >= items.length) {
          return  Center(child: CircularProgressIndicator());
        }
        else {
          return _SearchResultItem(vehicle: items[index]);
        }
      },
    );
  }

  @override
  void dispose() {
    print("Search screen dispose method called");
    _searchTextController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreshold) {
      _vehicleSearchBloc.add(SearchQueryChanged(text: searchText));
    }
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

