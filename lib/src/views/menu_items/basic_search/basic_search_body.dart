import 'dart:async';

import 'package:car_data_app/src/blocs/vehicle_search_bloc/vehicle_search_bloc.dart';
import 'package:car_data_app/src/blocs/vehicle_search_bloc/vehicle_search_event.dart';
import 'package:car_data_app/src/blocs/vehicle_search_bloc/vehicle_search_state.dart';
import 'package:car_data_app/src/models/vehicle.dart';
import 'package:car_data_app/src/views/menu_items/basic_search/search_result_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BasicSearchBody extends StatefulWidget {

  @override
  State createState() {
    return BasicSearchBodyState();
  }
}

class BasicSearchBodyState extends State<BasicSearchBody> with AutomaticKeepAliveClientMixin {

  @override
  bool wantKeepAlive = true;

  static final double _scrollThreshold = 200.0;

  VehicleSearchBloc _vehicleSearchBloc;
  final _scrollController = ScrollController();
  Timer _debounce;

  void _onScroll() {
    if (_debounce?.isActive ?? false) _debounce.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if(_scrollController.hasClients) {
        final maxScroll = _scrollController.position.maxScrollExtent;
        final currentScroll = _scrollController.position.pixels;
        final currentBlocState = _vehicleSearchBloc.state;

        if (maxScroll - currentScroll <= _scrollThreshold && currentBlocState is SearchStateSuccess) {
          _vehicleSearchBloc.add(SearchQueryChanged(text: currentBlocState.searchQuery));
        }
      }
    });
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
          return Expanded(
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.transparent)
                ),
                child: Center(
                  child: Text(
                    'Search for a vehicle by make/model/year'
                  )
                ),
              ),
            )
          );
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
              : Expanded(child: _displayResults(state));
        }
        else {
          return Center(child: Text("Error: Something went wrong"));
        }
      },
    );
  }

  Widget _displayResults(SearchStateSuccess state) {
    return Column(
      children: [
        ListTile(
          title: Text("Total Results", style: TextStyle(color: Colors.tealAccent)),
          trailing: Text(state.searchResultsCount.toString(), style: TextStyle(color: Colors.tealAccent)),
        ),
        Expanded(child: _searchResults(state.vehicles, state.hasReachedMax))
      ],
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