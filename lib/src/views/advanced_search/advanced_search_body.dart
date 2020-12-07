import 'package:car_data_app/src/blocs/advanced_search_bloc/advanced_search_bloc.dart';
import 'package:car_data_app/src/models/vehicle.dart';
import 'package:car_data_app/src/views/basic_search/basic_search_result_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdvancedSearchBody extends StatefulWidget {

  List<Vehicle> vehicles;

  AdvancedSearchBody({Key key, this.vehicles}):super(key: key);

  @override
  State createState() {
    return AdvancedSearchBodyState();
  }
}

class AdvancedSearchBodyState extends State<AdvancedSearchBody> {
  static final double _scrollThreshold = 200.0;

  AdvancedSearchBloc _advancedSearchBloc;
  final _scrollController = ScrollController();


  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    final currentBlocState = _advancedSearchBloc.state;
    // if (maxScroll - currentScroll <= _scrollThreshold && currentBlocState is AdvancedSearchSuccess) {
    //   _vehicleSearchBloc.add(SearchQueryChanged(text: currentBlocState.vehicles));
    // }
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _advancedSearchBloc = BlocProvider.of<AdvancedSearchBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return _searchResults(widget.vehicles, true);
  }

  Widget _searchResults(List<Vehicle> items, bool hasReachedMax) {
    return ListView.builder(
      shrinkWrap: true,
      controller: _scrollController,
      itemCount: hasReachedMax ? items.length : items.length + 1,
      itemBuilder: (BuildContext context, int index) {
        if (index >= items.length) {
          return Center(child: CircularProgressIndicator());
        }
        else {
          return BasicSearchResultItem(vehicle: items[index]);
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