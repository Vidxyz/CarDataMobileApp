import 'package:car_data_app/src/models/vehicle.dart';
import 'package:flutter/material.dart';
import 'package:car_data_app/src/blocs/vehicles_bloc.dart';
import 'package:car_data_app/src/views/vehicle_detail.dart';
import 'package:car_data_app/src/blocs/bloc_provider.dart';

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
    final bloc = VehiclesBloc();
    var _controller = TextEditingController();

    return BlocProvider<VehiclesBloc>(
      bloc: bloc,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Search by make/model/year?',
                  suffixIcon: IconButton(
                    onPressed: () => bloc.searchVehicles(_controller.value.text),
                    icon: Icon(Icons.search),
                  ),
                
              ),
            ),
          ),
          Expanded(
            child: _buildStreamBuilder(bloc),
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
        if (results == null) {
          return Center(child: Text('Search for a vehicle by make/model/year'));
        }
        if (results.isEmpty) {
          return Center(child: Text('No Results'));
        }
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
          // onTap: () => openDetailPage(snapshot.data[index]),
        );
      },
    );
  }
}


/*
class VehicleListState extends State<VehicleList> {

  VehiclesBloc bloc;

  @override
  void initState() {
    super.initState();
    // vehiclesBloc.fetchAllVehicles();
    // bloc = BlocProvider.of<VehiclesBloc>(context);
  }

  @override
  Widget build(BuildContext context) {

    final bloc = VehiclesBloc();

    return Scaffold(
      appBar: AppBar(
        title: Text('All Vehicles'),
      ),
      body: StreamBuilder(
        stream: vehiclesBloc.allVehicles,
        builder: (context, AsyncSnapshot<List<Vehicle>> snapshot) {
          if (snapshot.hasData) return buildList(snapshot);
          else if (snapshot.hasError) return Text(snapshot.error.toString());
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  @override
  void dispose() {
    vehiclesBloc.dispose();
    super.dispose();
  }

  Widget buildList(AsyncSnapshot<List<Vehicle>> snapshot) {
    return ListView.builder(
      itemCount: snapshot.data.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text(snapshot.data[index].make + " " + snapshot.data[index].model, style: TextStyle(fontWeight: FontWeight.w500)),
          subtitle: Text(snapshot.data[index].year.toString()),
          leading: Icon(Icons.directions_car, color: Colors.teal),
          // onTap: () => openDetailPage(snapshot.data[index]),
        );
      },
    );
  }

  openDetailPage(Vehicle data) {
    final page = BlocProvider(
      child: VehicleDetail(data: data)
    );
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return page;
      }),
    );
  }

}

 */