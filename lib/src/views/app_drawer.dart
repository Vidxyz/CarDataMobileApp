import 'package:car_data_app/src/views/favourites_screen.dart';
import 'package:car_data_app/src/views/vehicle_search_tab_view.dart';
import 'package:flutter/material.dart';

class GlobalAppDrawer extends StatefulWidget {

  @override
  State createState() {
    return GlobalAppDrawerState();
  }
}

class GlobalAppDrawerState extends State<GlobalAppDrawer> {

  static final String vehicleSearch = 'Vehicle Search';
  static final String favouriteVehicles = 'Favourite Vehicles';
  static final String savedFilters = 'Saved Filters';
  static final String imFeelingLucky = 'I\'m Feeling Lucky';
  static final String credits = 'Credits';

  String selectedMenuItem = "Vehicle Search";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text(_getAppBarText(selectedMenuItem)),
      ),
      drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Text('Drawer Header'),
                decoration: BoxDecoration(
                  color: Colors.teal,
                ),
              ),
              ListTile(
                title: Text(vehicleSearch),
                onTap: () {
                  Navigator.pop(context);
                  if(selectedMenuItem != vehicleSearch) {
                    setState(() {
                      selectedMenuItem = vehicleSearch;
                    });
                  }
                },
              ),
              ListTile(
                title: Text(favouriteVehicles),
                onTap: () {
                  Navigator.pop(context);
                  if(selectedMenuItem != favouriteVehicles) {
                    setState(() {
                      selectedMenuItem = favouriteVehicles;
                    });
                  }
                },
              ),
              ListTile(
                title: Text(savedFilters),
                onTap: () {
                  Navigator.pop(context);
                  if(selectedMenuItem != savedFilters) {
                    setState(() {
                      selectedMenuItem = savedFilters;
                    });
                  }
                },
              ),
              ListTile(
                title: Text(imFeelingLucky),
                onTap: () {
                  Navigator.pop(context);
                  if(selectedMenuItem != imFeelingLucky) {
                    setState(() {
                      selectedMenuItem = imFeelingLucky;
                    });
                  }
                },
              ),
              ListTile(
                title: Text(credits),
                onTap: () {
                  Navigator.pop(context);
                  if(selectedMenuItem != credits) {
                    setState(() {
                      selectedMenuItem = credits;
                    });
                  }
                },
              )
            ],
          ),
        ),
      body: _generateBody(selectedMenuItem),
    );
  }

  Widget _generateBody(String selectedMenuItem) {
    switch(selectedMenuItem) {
      case "Vehicle Search": return VehicleSearchTabView();
      case "Favourite Vehicles": return FavouritesScreen();
      case "Saved Filters": return Text("Saved Filters");
      case "I'm Feeling Lucky": return Text("I'm Feeling Lucky");
      case "Credits": return Text("Credits");
      default: return Text("Not Found");
    }
  }

  String _getAppBarText(String selectedMenuItem) {
    switch(selectedMenuItem) {
      case "Vehicle Search": return "Find Vehicles";
      case "Favourite Vehicles": return "Favourite Vehicles";
      case "Saved Filters": return "Saved Filters";
      case "I'm Feeling Lucky": return "I'm Feeling Lucky";
      case "Credits": return "Credits";
      default: return "Not Found";
    }
  }
}