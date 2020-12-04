import 'package:car_data_app/src/blocs/vehicle_search_bloc/vehicle_search_bloc.dart';
import 'package:car_data_app/src/blocs/vehicle_search_bloc/vehicle_search_event.dart';
import 'package:car_data_app/src/blocs/vehicle_search_bloc/vehicle_search_state.dart';
import 'package:car_data_app/src/models/vehicle.dart';
import 'package:car_data_app/src/views/basic_search/search_result_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchBody extends StatefulWidget {

  @override
  State createState() {
    return SearchBodyState();
  }
}

class SearchBodyState extends State<SearchBody> {
  static final double _scrollThreshold = 200.0;

  VehicleSearchBloc _vehicleSearchBloc;
  final _scrollController = ScrollController();


  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    final currentBlocState = _vehicleSearchBloc.state;
    if (maxScroll - currentScroll <= _scrollThreshold && currentBlocState is SearchStateSuccess) {
      _vehicleSearchBloc.add(SearchQueryChanged(text: currentBlocState.searchQuery));
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _vehicleSearchBloc = BlocProvider.of<VehicleSearchBloc>(context);
  }

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
              : Expanded(child: _searchResults(state.vehicles, state.hasReachedMax)
          );
        }
        else {
          return Center(child: Text("Error: Something went wrong"));
        }
      },
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
          return SearchResultItem(vehicle: items[index]);
        }
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}