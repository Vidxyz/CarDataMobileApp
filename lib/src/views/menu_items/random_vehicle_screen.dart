import 'package:car_data_app/src/blocs/random_vehicle_bloc/random_vehicle_bloc.dart';
import 'package:car_data_app/src/blocs/random_vehicle_bloc/random_vehicle_event.dart';
import 'package:car_data_app/src/blocs/random_vehicle_bloc/random_vehicle_state.dart';
import 'package:car_data_app/src/blocs/vehicle_images_bloc/vehicle_images_bloc.dart';
import 'package:car_data_app/src/repo/repo.dart';
import 'package:car_data_app/src/utils/Utils.dart';
import 'package:car_data_app/src/views/vehicle_detail_screen/vehicle_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RandomVehicleScreen extends StatefulWidget {

  @override
  State createState() {
    return RandomVehicleScreenState();
  }
}

class RandomVehicleScreenState extends State<RandomVehicleScreen> {

  late RandomVehicleBloc _randomVehicleBloc;

  @override
  void initState() {
    super.initState();
    _randomVehicleBloc = BlocProvider.of<RandomVehicleBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RandomVehicleBloc, RandomVehicleState>(
        builder: (BuildContext context, RandomVehicleState state) {
          return Container(
            padding: EdgeInsets.only(bottom: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: _generateBody(state)
            ),
          );
        }
    );
  }

  List<Widget> _generateBody(RandomVehicleState state) {
    if(state is RandomVehicleInitial) {
      return [
        Expanded(child: _goButton())
      ];
    }
    else {
      return [
        _vehicleViewScreen(state),
        Utils.gap(),
        _goButton()
      ];
    }
  }

  Widget _vehicleViewScreen(RandomVehicleState state) {
    if (state is RandomVehicleLoading) {
      return Container(
        height: Utils.getScreenHeight(context) * 3/4,
        child: Center(
          child: CircularProgressIndicator()
        ),
      );
    }
    else if (state is RandomVehicleSuccess) {
      return Container(
        height: Utils.getScreenHeight(context) * 3/4,
        child: Center(
            child: BlocProvider(
              create: (context) => VehicleImagesBloc(repository: Repo()),
              child: VehicleDetailScreen(
                  vehicle: state.vehicle,
                  isPartOfSeparateContainer: true
              ),
            )
        ),
      );
    }
    else {
      return Expanded(
        child: Text("An error has occurred... This shouldn't be happening")
      );
    }
  }

  Widget _goButton() =>
    Center(
      child: ElevatedButton(
          onPressed: () {
            _randomVehicleBloc.add(RandomVehicleRequested());
          },
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              "Go",
              style: TextStyle(
                  fontSize: 18
              ),
            ),
          ),
          // color: Colors.teal
      ),
    );
}