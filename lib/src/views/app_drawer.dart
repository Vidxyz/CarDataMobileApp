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
            ],
          ),
        ),
      body: _generateBody(selectedMenuItem),
    );
  }

  Widget _generateBody(String selectedMenuItem) {
    switch(selectedMenuItem) {
      case "Vehicle Search": return VehicleSearchTabView();
      default: return Text("Not Found");
    }
  }

  String _getAppBarText(String selectedMenuItem) {
    switch(selectedMenuItem) {
      case "Vehicle Search": return "Find Vehicles";
      default: return "Not Found";
    }
  }
}