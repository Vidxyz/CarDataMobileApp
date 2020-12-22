import 'dart:async';

import 'package:car_data_app/src/blocs/favourite_vehicles_bloc/favourite_vehicles_bloc.dart';
import 'package:car_data_app/src/blocs/favourite_vehicles_bloc/favourite_vehicles_event.dart';
import 'package:car_data_app/src/blocs/favourite_vehicles_bloc/favourite_vehicles_state.dart';
import 'package:car_data_app/src/blocs/vehicle_images_bloc/vehicle_images_bloc.dart';
import 'package:car_data_app/src/models/vehicle.dart';
import 'package:car_data_app/src/repo/repo.dart';
import 'package:car_data_app/src/views/vehicle_detail_screen/vehicle_detail_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavouritesScreen extends StatefulWidget {

  @override
  State createState() {
    return FavouritesScreenState();
  }
}

class FavouritesScreenState extends State<FavouritesScreen> {
  static final double _scrollThreshold = 200.0;
  static final String FAVOURITES = "vehicle_favourites";

  String searchQuery = "";
  TextEditingController controller = new TextEditingController();

  FavouriteVehiclesBloc _favouriteVehiclesBloc;
  final _scrollController = ScrollController();
  Timer _debounce;

  void _onScroll() {
    if (_debounce?.isActive ?? false) _debounce.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if(_scrollController.hasClients) {
        final maxScroll = _scrollController.position.maxScrollExtent;
        final currentScroll = _scrollController.position.pixels;
        final currentBlocState = _favouriteVehiclesBloc.state;
        if (maxScroll - currentScroll <= _scrollThreshold && currentBlocState is FavouriteVehiclesSuccess) {
          _favouriteVehiclesBloc.add(
              FavouriteVehiclesRequested(
                  favouriteVehicleIds: currentBlocState.favouriteVehicles.map((e) => e.id).toList())
          );
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _favouriteVehiclesBloc = BlocProvider.of<FavouriteVehiclesBloc>(context);
  }

  void _fetchFavouritesAndSendBlocRequest() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var favouriteVehicleIds = prefs.getStringList(FAVOURITES);
    _favouriteVehiclesBloc.add(FavouriteVehiclesRequested(favouriteVehicleIds: favouriteVehicleIds ?? []));
  }

  @override
  Widget build(BuildContext context) {
    _fetchFavouritesAndSendBlocRequest();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _filterSearchBar(),
        _favouritesListView()
      ],
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget _favouritesListView() {
    return BlocBuilder<FavouriteVehiclesBloc, FavouriteVehiclesState>(
        builder: (BuildContext context, FavouriteVehiclesState state) {
          if(state is FavouriteVehiclesInitial || state is FavouriteVehiclesLoading) {
            return Expanded(
              child: Center(
                // padding: EdgeInsets.fromLTRB(100, 250, 100, 250),
                  child: CircularProgressIndicator()
              ),
            );
          }
          else if (state is FavouriteVehiclesSuccess) {
            if(state.favouriteVehicles.isNotEmpty)
              return Expanded(child: _searchResults(state.favouriteVehicles, state.hasReachedMax));
            else
              return Expanded(child: Center(child: Text('No Results')));
          }
          else {
            return Center(child: Text("Error: Something went wrong"));
          }
        }
    );
  }

  Widget _searchResults(List<Vehicle> items, bool hasReachedMax) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: hasReachedMax ? items.length : items.length + 1,
      itemBuilder: (BuildContext context, int index) {
        if (index >= items.length) {
          return Center(child: CircularProgressIndicator());
        }
        else {
          final item = items[index];
          return Dismissible(
            key: Key(item.id),
            onDismissed: (direction) {
              _removeFromFavourites(item.id);
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        "Removed ${item.make} ${item.model} ${item.year} from favourites",
                        style: TextStyle(color: Colors.white)
                    ),
                backgroundColor: Theme.of(context).backgroundColor,
              ));
            },
            background: Container(color: Colors.teal,),
            child: _searchResultItem(item),
          );
        }
      },
    );
  }

  // Assumption here is that this vehicle will always be present in the list
  void _removeFromFavourites(String vehicleId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var favouriteVehicleIds = prefs.getStringList(FAVOURITES);
    favouriteVehicleIds.remove(vehicleId);
    await prefs.setStringList(FAVOURITES, favouriteVehicleIds);
  }

  Widget _searchResultItem(Vehicle vehicle) {
    return ListTile(
      title: Text(
          vehicle.make + " " + vehicle.model,
          style: TextStyle(fontWeight: FontWeight.w500)
      ),
      trailing: Icon(Icons.format_align_left_sharp),
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
        ).then((value) {
          setState(() {
            _favouriteVehiclesBloc.add(FavouriteVehiclesReset());
          });
        }
        );
      },
    );
  }

  Widget _filterSearchBar() {
    return Card(
      child: ListTile(
        // dense: true,
        // leading: new Icon(Icons.search),
        title: TextField(
          controller: controller,
          decoration: InputDecoration(
              hintText: 'Filter by typing...',
              border: InputBorder.none
          ),
          onChanged: (String text) {
            setState(() {
              searchQuery = text;
            });
          },
        ),
        trailing: IconButton(
          icon: Icon(Icons.cancel_outlined),
          onPressed: () {
            controller.clear();
            setState(() {
              searchQuery = "";
            });
          },
        ),
      ),
    );
  }
}