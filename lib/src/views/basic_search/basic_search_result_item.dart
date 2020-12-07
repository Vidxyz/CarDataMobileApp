import 'package:car_data_app/src/blocs/vehicle_images_bloc/vehicle_images_bloc.dart';
import 'package:car_data_app/src/models/vehicle.dart';
import 'package:car_data_app/src/repo/repo.dart';
import 'package:car_data_app/src/views/vehicle_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BasicSearchResultItem extends StatelessWidget {
  final Vehicle vehicle;

  const BasicSearchResultItem({Key key, @required this.vehicle}) : super(key: key);

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