import 'package:car_data_app/src/blocs/bloc_provider.dart';
import 'package:car_data_app/src/blocs/vehicle_images_bloc.dart';
import 'package:car_data_app/src/models/vehicle.dart';
import 'package:car_data_app/src/models/vehicle_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quiver/iterables.dart';

class VehicleDetail extends StatefulWidget {
  final Vehicle vehicle;

  // todo - gracefully handle nulls
  VehicleDetail({this.vehicle});

  @override
  State createState() {
    return VehicleDetailState(vehicle: vehicle);
  }
}

class VehicleDetailState extends State<VehicleDetail> {
  
  final Vehicle vehicle;
  
  VehicleImagesBloc bloc;
  
  VehicleDetailState({this.vehicle});

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    bloc = BlocProvider.of<VehicleImagesBloc>(context);
    bloc.fetchImagesByVehicleId(vehicle.id);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: true,
        bottom: false,
        child: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  expandedHeight: 200.0,
                  floating: false,
                  pinned: true,
                  elevation: 0.0,
                  flexibleSpace: StreamBuilder(
                    stream: bloc.vehicleImages,
                    builder: (context,
                        AsyncSnapshot<Future<List<VehicleImage>>> snapshot) {
                      if (snapshot.hasData) {
                        return FutureBuilder(
                          future: snapshot.data,
                          builder: (context,
                              AsyncSnapshot<List<VehicleImage>> itemSnapShot) {
                            if (itemSnapShot.hasData) {
                              if (itemSnapShot.data.length > 0)
                                return imageLayout(vehicle, itemSnapShot.data, MediaQuery.of(context).size.width, MediaQuery.of(context).size.height);
                              else
                                return noImage();
                            } else {
                              return Center(child: CircularProgressIndicator());
                            }
                          },
                        );
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                ),
              ];
            },
            body: ListView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(margin: EdgeInsets.only(top: 5.0)),
                      Text(
                        vehicle.make + " " + vehicle.model, // Make and Model
                        style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Gap(),
                      Row(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(left: 1.0, right: 1.0),
                          ),
                          Text(
                            vehicle.year.toString(), // Year
                            style: TextStyle(fontSize: 20.0),
                          ),
                          Container(margin: EdgeInsets.only(left: 10.0, right: 10.0)),
                          Text(
                            vehicle.vehicleClass, // Class
                            style: TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                          Spacer(),
                          Icon(
                            Icons.favorite,
                            color: Colors.red,
                            size: 35.0,
                          ),
                        ],
                      ),
                      Gap(),
                      Text(vehicle.manufacturerCode ?? "N/A"), // Manufacturer code
                      Divider(),
                      Gap(),
                      Row(
                        children: [
                          Spacer(),
                          Text(
                            "Specifications",
                            style: TextStyle(
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Spacer()
                        ],
                      ),
                      Gap(),
                      Divider(),
                    ]
                    + generateStaticSpecifications(vehicle) // other vehicle stats to show
                    + [Gap(), Divider()]
                    + generateBooleanSpecifications(vehicle)
                    + [Gap(), Divider()],
                  ),
                ),
              ],
            )),
      ),
    );
  }

  List<Widget> generateBooleanSpecifications(Vehicle vehicle) {
      final specs = [
        vehicle.engine.isSupercharged,
        vehicle.engine.isTurbocharged,
        vehicle.engine.fuelEconomy.isGuzzler
      ];

      final headings = ["Supercharger", "Turbocharger", "Guzzler"];
      final defaults = ["No", "No", "No"];

      return zip([specs, headings, defaults]).map((e) {
        if(e[2] != null || (e[0] != null && e[0] != 0)) { // If spec isn't null, or if a default is provided
          return <Widget>[
            Gap(),
            Row(
                children: <Widget>[
                  Expanded(
                    flex: 5,
                    child: Text( // Spec name
                      e[1],
                      style: _keyTextStyle(),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Container(
                      decoration: BoxDecoration(), // this is left in to be filled later
                      child: Text( // Spec value
                        e[0] ? "Yes" : e[2],
                        style: _valueTextStyle(),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                ]
            ),
          ];
        } else return <Widget>[];

      }).expand((i) => i).toList();
  }
  // null safe contructuror of oter types too
  List<Widget> generateStaticSpecifications(Vehicle vehicle) {
    final staticSpecs = [
      vehicle.primaryFuel,
      vehicle.secondaryFuel,
      vehicle.alternateFuelType,
      vehicle.transmission.type,
      vehicle.engine.cylinders,
      vehicle.engine.displacement,
      vehicle.engine.engineType,
      vehicle.engine.evMotor,
      vehicle.engine.fuelEconomy.combinedMpgPrimary,
      vehicle.engine.fuelEconomy.cityMpgPrimary,
      vehicle.engine.fuelEconomy.highwayMpgPrimary,
      vehicle.engine.fuelEconomy.combinedMpgSecondary,
      vehicle.engine.fuelEconomy.cityMpgSecondary,
      vehicle.engine.fuelEconomy.highwayMpgSecondary,
      vehicle.engine.driveTrain,
    ];

    final headings = ["Fuel", "Alternate Fuel", "Alternate Fuel Type", "Transmission", "Cylinders", "Displacement (L)",
      "Engine Type",  "EV Motor", "MpG Combined", "MpG City", "MpG Highway", "MpG Alternate Combined", "MpG Alternate City",
      "MpG Alternate Highway", "Drive Train"];
    final defaults = ["Gasoline", null, null, "-", "-", "-", "-", null, "-", "-", "-", null, null, null, "-"];

    return zip([staticSpecs, headings, defaults]).map((e) {
      if(e[2] != null || (e[0] != null && e[0] != 0)) { // If spec isn't null, or if a default is provided
        return <Widget>[
          Gap(),
          Row(
              children: <Widget>[
                Expanded(
                  flex: 5,
                  child: Text( // Spec name
                    e[1],
                    style: _keyTextStyle(),
                    textAlign: TextAlign.left,
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Container(
                    decoration: BoxDecoration(), // this is left in to be filled later
                    child: Text( // Spec value
                        e[0] != null ? e[0].toString() : e[2],
                        style: _valueTextStyle(),
                        textAlign: TextAlign.left,
                    ),
                  ),
                ),
              ]
          ),
        ];
      } else return <Widget>[];

    }).expand((i) => i).toList();
  }

  Widget noImage() {
    return Center(
      child: Container(
        child: Text("No Image available"),
      ),
    );
  }

  Widget Gap() => Container(margin: EdgeInsets.only(top: 8.0, bottom: 8.0));
  TextStyle _keyTextStyle() => TextStyle(fontSize: 15);
  TextStyle _valueTextStyle() => TextStyle(fontSize: 15, fontWeight: FontWeight.bold);

  Widget imageLayout(Vehicle vehicle, List<VehicleImage> images, double screenWidth, double screenHeight) {
    images.sort((i1, i2) => (i2.width * i2.height).compareTo((i1.width * i1.height)));
    return ListView(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          children: createImagesForVehicle(images, screenWidth, screenHeight)
      );
  }

  List<Widget> createImagesForVehicle(List<VehicleImage> images, double screenWidth, double screenHeight) {
      return images.map((e) => Center(
        child: Container(
          width: screenWidth,
          height: screenHeight,
          child: FittedBox(
            child: e.image,
            fit: BoxFit.fill,
          ),
        ),
      )).toList();
    }

}