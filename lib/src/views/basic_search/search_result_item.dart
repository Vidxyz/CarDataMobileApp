import 'package:car_data_app/src/blocs/vehicle_images_bloc/vehicle_images_bloc.dart';
import 'package:car_data_app/src/models/vehicle.dart';
import 'package:car_data_app/src/repo/repo.dart';
import 'package:car_data_app/src/views/vehicle_detail_screen/vehicle_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchResultItem extends StatelessWidget {
  final Vehicle vehicle;
  final String sortMetric;
  final String sortMetricValue;

  const SearchResultItem({Key key,
    @required this.vehicle,
    this.sortMetric,
    this.sortMetricValue
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(vehicle.make + " " + vehicle.model, style: TextStyle(fontWeight: FontWeight.w500)),
      trailing: sortMetric == null ? Text("") : _showSortMetric(),
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

  Widget _showSortMetric() {
    return Column(
      children: [
        Expanded(child: Text(sortMetric, style: TextStyle(fontSize: 13))),
        Expanded(child: Text(sortMetricValue, style: TextStyle(fontSize: 13)))
      ],
    );
  }
}