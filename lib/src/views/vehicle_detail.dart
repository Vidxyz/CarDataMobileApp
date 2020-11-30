import 'package:car_data_app/src/blocs/bloc_provider.dart';
import 'package:car_data_app/src/blocs/vehicle_images_bloc.dart';
import 'package:car_data_app/src/models/vehicle.dart';
import 'package:car_data_app/src/models/vehicle_image.dart';
import 'package:car_data_app/src/utils/Utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quiver/iterables.dart';

class VehicleDetail extends StatefulWidget {
  final Vehicle vehicle;

  VehicleDetail({this.vehicle});

  @override
  State createState() {
    return VehicleDetailState(vehicle: vehicle);
  }
}

class VehicleDetailState extends State<VehicleDetail> {
  
  final Vehicle vehicle;
  
  VehicleImagesBloc vehicleImagesBloc;
  
  VehicleDetailState({this.vehicle});

  @override
  void dispose() {
    print("Vehicle Detail screen dispose method");
    vehicleImagesBloc.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    print("Vehicle Detail screen didChangeDependencies method");
    vehicleImagesBloc = BlocProvider.of<VehicleImagesBloc>(context);
    vehicleImagesBloc.fetchImagesByVehicleId(vehicle.id);
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
                    stream: vehicleImagesBloc.vehicleImages,
                    builder: (context,
                        AsyncSnapshot<Future<List<VehicleImage>>> snapshot) {
                      if (snapshot.hasData) {
                        return FutureBuilder(
                          future: snapshot.data,
                          builder: (context,
                              AsyncSnapshot<List<VehicleImage>> itemSnapShot) {
                            if (itemSnapShot.hasData) {
                              if (itemSnapShot.data.length > 0)
                                return imageLayout(vehicle, itemSnapShot.data, Utils.getScreenWidth(context), Utils.getScreenHeight(context));
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
                          Text(
                            vehicle.year.toString(), // Year
                            style: TextStyle(fontSize: 20.0),
                          ),
                          Container(margin: EdgeInsets.only(left: 10.0, right: 10.0)),
                          Spacer(),
                          Icon(
                            Icons.favorite,
                            color: Colors.red,
                            size: 35.0,
                          ),
                        ],
                      ),
                      Gap(),
                      Text(
                        vehicle.vehicleClass, // Class
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                      Gap(),
                      Text(vehicle.manufacturerCode ?? "N/A", style: TextStyle(fontSize: 15.0),), // Manufacturer code
                      Gap(),
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
                    + [Gap(), Divider()]
                    + generateAccordionLists(vehicle)
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
            Container(
              margin: EdgeInsets.only(left: 10),
              child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 5,
                      child: Container(
                        child: Text( // Spec name
                          e[1],
                          style: _keyTextStyle(),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Container(
                        margin: EdgeInsets.only(left:15),
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
            ),
          ];
        } else return <Widget>[];

      }).expand((i) => i).toList();
  }


  List<Widget> generateFuelEconomySpecifics(Vehicle vehicle) {
    final fuelEconomies = [
      vehicle.engine.fuelEconomy.barrelsPerYearPrimary,
      vehicle.engine.fuelEconomy.barrelsPerYearSecondary,
      vehicle.engine.fuelEconomy.annualFuelCostPrimary,
      vehicle.engine.fuelEconomy.annualFuelCostSecondary,
      vehicle.engine.fuelEconomy.fuelEconomyScore,
      vehicle.engine.fuelEconomy.combinedPowerConsumption,
      vehicle.engine.fuelEconomy.epaCityRangeSecondary,
      vehicle.engine.fuelEconomy.epaHighwayRangeSecondary,
      vehicle.engine.fuelEconomy.epaRangeSecondary,
      vehicle.engine.fuelEconomy.timeToCharge120v,
      vehicle.engine.fuelEconomy.timeToCharge240v,
    ];

    final headings = ["Yearly Barrels", "Yearly Barrels Secondary",
      "Annual Fuel Cost (\$)", "Secondary Fuel Cost", "Fuel Economy Score",
    "Power Consumption", "EPA City Range", "EPA Highway Range", "EPA Range", "Charging time (120V)", "Charging Time (240V)"];

    final defaults = [null, null, null, null, null, null, null, null, null, null, null];

    return zip([fuelEconomies, headings, defaults]).map((e) {
      if(e[2] != null || (e[0] != null && e[0] != 0)) { // If spec isn't null, or if a default is provided
        return <Widget>[
          Container(
            margin: EdgeInsets.only(top: 10.0, bottom: 10.0, left:15),
            child: Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: Container(
                      child: Text( // Spec name
                        e[1],
                        style: _keyTextStyle(),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Container(
                      margin: EdgeInsets.only(left:10),
                      decoration: BoxDecoration(), // this is left in to be filled later
                      child: Text( // Spec value
                        e[0].toString(),
                        style: _valueTextStyle(),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                ]
            ),
          )
        ];
      } else return <Widget>[];

    }).expand((i) => i).toList();

  }

  List<Widget> generateFuelEmissionSpecifics(Vehicle vehicle) {
    final dimensions = [
      vehicle.engine.fuelEmission.greenhouseScorePrimary,
      vehicle.engine.fuelEmission.greenhouseScoreSecondary,
      vehicle.engine.fuelEmission.tailpipeCo2Primary,
      vehicle.engine.fuelEmission.tailpipeCo2Secondary,
    ];

    final headings = ["Greenhouse Score", "Greenhouse Score Secondary", "Tailpipe CO2",
      "Tailpipe CO2 Seconadry"];

    final defaults = [null, null, null, null];

    return zip([dimensions, headings, defaults]).map((e) {
      if(e[2] != null || (e[0] != null && e[0] != 0)) { // If spec isn't null, or if a default is provided
        return <Widget>[
          Container(
            margin: EdgeInsets.only(top: 10.0, bottom: 10.0, left:15),
            child: Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: Container(
                      child: Text( // Spec name
                        e[1],
                        style: _keyTextStyle(),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Container(
                      margin: EdgeInsets.only(left:10),
                      decoration: BoxDecoration(), // this is left in to be filled later
                      child: Text( // Spec value
                        e[0].toString(),
                        style: _valueTextStyle(),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                ]
            ),
          )
        ];
      } else return <Widget>[];

    }).expand((i) => i).toList();

  }


  List<Widget> generateDimensionSpecs(Vehicle vehicle) {
    final dimensions = [
      vehicle.dimensions.fourDoorLuggageVolume,
      vehicle.dimensions.fourDoorPassengerVolume,
      vehicle.dimensions.hatchbackLuggageVolume,
      vehicle.dimensions.hatchbackPassengerVolume,
      vehicle.dimensions.twoDoorLuggageVolume,
      vehicle.dimensions.fourDoorLuggageVolume,
    ];

    final headings = ["4Dr Luggage Volume", "4Dr Passenger Volume", "Hatchback Luggage Volume",
      "Hatchback Passenger Volume", "2Dr Luggage Volume", "2Dr Passenger Volume"];

    final defaults = [null, null, null, null, null, null];

    return zip([dimensions, headings, defaults]).map((e) {
      if(e[2] != null || (e[0] != null && e[0] != 0)) { // If spec isn't null, or if a default is provided
      return <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 10.0, bottom: 10.0, left:15),
                    child: Row(
                      children: [
                      Expanded(
                        flex: 5,
                        child: Container(
                          child: Text( // Spec name
                            e[1],
                            style: _keyTextStyle(),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: Container(
                          margin: EdgeInsets.only(left:10),
                          decoration: BoxDecoration(), // this is left in to be filled later
                          child: Text( // Spec value
                            e[0].toString() + " litres",
                            style: _valueTextStyle(),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                        ]
                    ),
                  )
                ];
      } else return <Widget>[];

    }).expand((i) => i).toList();

  }

  List<Widget> generateAccordionLists(Vehicle vehicle) {
    return <Widget>[
      Container(
        // padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ExpansionTile(
          title: Text(
            "More Info",
            textAlign: TextAlign.start,
            style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.bold
            ),
          ),
          children: <Widget> [
            ExpansionTile(
              title: Text(
                "Dimensions",
                style: TextStyle(
                    fontSize: 17.0,
                ),
              ),
              children: generateDimensionSpecs(vehicle)
            ),
            ExpansionTile(
                title: Text(
                  "Fuel Economy",
                  style: TextStyle(
                    fontSize: 17.0,
                  ),
                ),
                children: generateFuelEconomySpecifics(vehicle)
            ),
            ExpansionTile(
                title: Text(
                  "Fuel Emissions",
                  style: TextStyle(
                    fontSize: 17.0,
                  ),
                ),
                children: generateFuelEmissionSpecifics(vehicle)
            ),

        ]),
      )];
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
          Container(
            margin: EdgeInsets.only(left: 10),
            child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 5,
                    child: Container(
                      child: Text( // Spec name
                        e[1],
                        style: _keyTextStyle(),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Container(
                      margin: EdgeInsets.only(left:15),
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