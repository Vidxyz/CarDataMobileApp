import 'package:car_data_app/src/blocs/vehicle_images_bloc.dart';
import 'package:car_data_app/src/models/search_suggestion.dart';
import 'package:car_data_app/src/models/vehicle.dart';
import 'package:car_data_app/src/repo/repo.dart';
import 'package:flutter/material.dart';
import 'package:car_data_app/src/blocs/vehicles_bloc.dart';
import 'package:car_data_app/src/views/vehicle_detail.dart';
import 'package:car_data_app/src/blocs/bloc_provider.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class VehicleList extends StatelessWidget {

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
    final vehiclesBloc = VehiclesBloc();
    final _controller = TextEditingController();
    final _suggestionsController = SuggestionsBoxController();
    final repo = Repo();
    var shouldShow = false;

    return BlocProvider<VehiclesBloc>(
      bloc: vehiclesBloc,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TypeAheadField<SearchSuggestion>(
              suggestionsBoxController: _suggestionsController,
              textFieldConfiguration: TextFieldConfiguration(
                  onChanged: (text) => shouldShow = true,
                  autofocus: true,
                  controller: _controller,
                  style: DefaultTextStyle.of(context).style.copyWith(fontSize: 15),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Search by make/model/year",
                    suffixIcon: IconButton(
                      onPressed: () {
                        shouldShow = false;
                        _suggestionsController.close();
                        vehiclesBloc.searchVehicles(_controller.value.text);
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
              onSuggestionSelected: (suggestion) => _controller.text = suggestion.toString(),
              hideOnEmpty: true,
            )
          ),
          Expanded(
            child: _buildStreamBuilder(vehiclesBloc),
          )
        ],
      ),
    );
  }

  Widget _buildStreamBuilder(VehiclesBloc bloc) {
    return StreamBuilder(
      stream: bloc.allVehicles,
      builder: (context, snapshot) {
        final results = snapshot.data;
        if (results == null) return Center(child: Text('Search for a vehicle by make/model/year'));
        if (results.isEmpty) return Center(child: Text('No Results'));
        return _buildSearchResults(results);
      },
    );
  }

  Widget _buildSearchResults(List<Vehicle> results) {
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (BuildContext context, int index) {
        final vehicle = results[index];
        return ListTile(
          title: Text(vehicle.make + " " + vehicle.model, style: TextStyle(fontWeight: FontWeight.w500)),
          subtitle: Text(vehicle.year.toString()),
          leading: Icon(Icons.directions_car, color: Colors.teal),
          onTap: () => openDetailPage(vehicle, context),
        );
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
}
