import 'dart:async';

import 'package:CarPedia/src/blocs/advanced_search_bloc/advanced_search_bloc.dart';
import 'package:CarPedia/src/blocs/advanced_search_bloc/advanced_search_event.dart';
import 'package:CarPedia/src/blocs/advanced_search_bloc/advanced_search_state.dart';
import 'package:CarPedia/src/models/vehicle.dart';
import 'package:CarPedia/src/views/menu_items/basic_search/search_result_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdvancedSearchBody extends StatefulWidget {

  final List<Vehicle> vehicles;
  final bool hasReachedMax;
  final String sortMetric;
  final int totalResultCount;

  AdvancedSearchBody({
    Key key,
    this.vehicles,
    this.hasReachedMax,
    this.sortMetric,
    this.totalResultCount
  }):super(key: key);

  @override
  State createState() {
    return AdvancedSearchBodyState();
  }
}

class AdvancedSearchBodyState extends State<AdvancedSearchBody> {
  static final double _scrollThreshold = 200.0;

  AdvancedSearchBloc _advancedSearchBloc;
  final _scrollController = ScrollController();
  Timer _debounce;

  void _onScroll() {
    if (_debounce?.isActive ?? false) _debounce.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if(_scrollController.hasClients) {
        // do something with _searchQuery.text
        final maxScroll = _scrollController.position.maxScrollExtent;
        final currentScroll = _scrollController.position.pixels;
        final currentBlocState = _advancedSearchBloc.state;

        if (maxScroll - currentScroll <= _scrollThreshold && currentBlocState is AdvancedSearchSuccess) {
          _advancedSearchBloc.add(AdvancedSearchButtonPressed(selectedFilters: currentBlocState.selectedFilters));
        }
      }
    });

  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _advancedSearchBloc = BlocProvider.of<AdvancedSearchBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.vehicles.isNotEmpty)
      return Column(
        children: [
            ListTile(
              title: Text("Total Results", style: TextStyle(color: Colors.tealAccent)),
              trailing: Text(widget.totalResultCount.toString(), style: TextStyle(color: Colors.tealAccent)),
            ),
          Expanded(child: _searchResults(widget.vehicles, widget.hasReachedMax))
        ],
      );
    else
      return Center(child: Text('No Results'));
  }

  Widget _searchResults(List<Vehicle> vehicles, bool hasReachedMax) {
    return ListView.builder(
      shrinkWrap: true,
      controller: _scrollController,
      itemCount: hasReachedMax ? vehicles.length : vehicles.length + 1,
      itemBuilder: (BuildContext context, int index) {
        if (index >= vehicles.length) {
          return Center(child: CircularProgressIndicator());
        }
        else {
          return SearchResultItem(
            vehicle: vehicles[index],
            sortMetric: widget.sortMetric,
            sortMetricValue: sortMetricToValueMap(vehicles[index], widget.sortMetric),
          );
        }
      },
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  String sortMetricToValueMap(Vehicle vehicle, String sortMetric) {
    switch (sortMetric) {
      case "City Mpg": return vehicle.engine.fuelEconomy.cityMpgPrimary.toString();
      case "Highway Mpg": return vehicle.engine.fuelEconomy.highwayMpgPrimary.toString();
      case "Combined Mpg": return vehicle.engine.fuelEconomy.combinedMpgPrimary.toString();
      case "Annual Fuel Cost": return vehicle.engine.fuelEconomy.annualFuelCostPrimary.toString();
      case "Fuel Economy": return vehicle.engine.fuelEconomy.fuelEconomyScore.toString();
      case "CO2 Emissions": return vehicle.engine.fuelEmission.tailpipeCo2Primary.toString();
      case "Greenhouse Score": return vehicle.engine.fuelEmission.greenhouseScorePrimary.toString();
      default: return "";
    }
  }
}