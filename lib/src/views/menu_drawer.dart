import 'dart:ui';

import 'package:car_data_app/src/blocs/favourite_vehicles_bloc/favourite_vehicles_bloc.dart';
import 'package:car_data_app/src/blocs/menu_navigation_bloc/menu_navigation_bloc.dart';
import 'package:car_data_app/src/blocs/menu_navigation_bloc/menu_navigation_event.dart';
import 'package:car_data_app/src/blocs/menu_navigation_bloc/menu_navigation_state.dart';
import 'package:car_data_app/src/blocs/random_vehicle_bloc/random_vehicle_bloc.dart';
import 'package:car_data_app/src/repo/repo.dart';
import 'package:car_data_app/src/utils/Utils.dart';
import 'package:car_data_app/src/views/menu_items/credits_screen.dart';
import 'package:car_data_app/src/views/menu_items/favourites_screen.dart';
import 'package:car_data_app/src/views/menu_items/random_vehicle_screen.dart';
import 'package:car_data_app/src/views/menu_items/saved_filters.dart';
import 'package:car_data_app/src/views/vehicle_search_tab_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class GlobalMenuDrawer extends StatefulWidget {

  @override
  State createState() {
    return GlobalMenuDrawerState();
  }
}

class GlobalMenuDrawerState extends State<GlobalMenuDrawer> {

  static final String vehicleSearch = 'Vehicle Search';
  static final String favouriteVehicles = 'Favourite Vehicles';
  static final String savedFilters = 'Saved Filters';
  static final String imFeelingLucky = 'I\'m Feeling Lucky';
  static final String credits = 'Credits';

  String selectedMenuItem = vehicleSearch;

  MenuNavigationBloc _menuNavigationBloc;

  @override
  void initState() {
    super.initState();
    _menuNavigationBloc = BlocProvider.of<MenuNavigationBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MenuNavigationBloc, MenuNavigationState>(
        builder: (BuildContext context, MenuNavigationState state) {
          if(state is SavedFilterSelected) {
            selectedMenuItem = vehicleSearch;
          }
          if (state is MenuItemSelected) {
            selectedMenuItem = state.selectedMenuItem;
          }
          return Scaffold(
            appBar: new AppBar(
              title: Text(_getAppBarText(selectedMenuItem)),
              actions: _addAppBarIcons(selectedMenuItem),
            ),
            drawer: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  _drawerHeader(),
                  ListTile(
                    title: Text(vehicleSearch),
                    onTap: () {
                      Navigator.pop(context);
                      if(selectedMenuItem != vehicleSearch) {
                        _menuNavigationBloc.add(MenuItemChosen(selectedMenuItem: vehicleSearch));
                      }
                    },
                  ),
                  ListTile(
                    title: Text(favouriteVehicles),
                    onTap: () {
                      Navigator.pop(context);
                      if(selectedMenuItem != favouriteVehicles) {
                        _menuNavigationBloc.add(MenuItemChosen(selectedMenuItem: favouriteVehicles));
                      }
                    },
                  ),
                  ListTile(
                    title: Text(savedFilters),
                    onTap: () {
                      Navigator.pop(context);
                      if(selectedMenuItem != savedFilters) {
                        _menuNavigationBloc.add(MenuItemChosen(selectedMenuItem: savedFilters));
                      }
                    },
                  ),
                  ListTile(
                    title: Text(imFeelingLucky),
                    onTap: () {
                      Navigator.pop(context);
                      if(selectedMenuItem != imFeelingLucky) {
                        _menuNavigationBloc.add(MenuItemChosen(selectedMenuItem: imFeelingLucky));
                      }
                    },
                  ),
                  ListTile(
                    title: Text(credits),
                    onTap: () {
                      Navigator.pop(context);
                      if(selectedMenuItem != credits) {
                        _menuNavigationBloc.add(MenuItemChosen(selectedMenuItem: credits));
                      }
                    },
                  )
                ],
              ),
            ),
            body: _generateBody(selectedMenuItem),
          );
        }
    );
  }

  Widget _drawerHeader() =>
    Container(
      height: 300,
      child: DrawerHeader(
        child: Column(
          children: [
            Expanded(
                flex: 3,
                child:
                  Center(
                      child:
                      Text(
                        Utils.appName,
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold
                        ),
                      )
                  )
            ),
            Expanded(
                flex: 8,
                child:
                Center(child: _circleImageView(Utils.appRepoUrl, Utils.creatorIconPath))
            ),
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  Expanded(child: _circleImageView(Utils.githubUrl, Utils.githubIconPath)),
                  Expanded(child: _circleImageView(Utils.linkedInUrl, Utils.linkedInIconPath)),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                child: Text(Utils.version),
              ) ,
            )
          ],
        ),
        decoration: BoxDecoration(
          color: Colors.teal,
        ),
      ),
    );

  Widget _circleImageView(String url, String assetPath) =>
      GestureDetector(
        onTap: () async {
          if (await canLaunch(url)) {
            await launch(url);
          }
          else {
            throw "Could not launch $url";
          }
        },
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
                image: AssetImage(assetPath),
                fit: BoxFit.fitHeight
            ),
          ),
        ),
      );

  Widget _generateBody(String selectedMenuItem) {
    switch(selectedMenuItem) {
      case "Vehicle Search":
        return  VehicleSearchTabView();
      case "Favourite Vehicles":
        return BlocProvider(
          create: (context) => FavouriteVehiclesBloc(repository: Repo()),
          child: FavouritesScreen(),
        );
      case "Saved Filters":
        return  SavedFiltersScreen();
      case "I'm Feeling Lucky":
        return BlocProvider(
          create: (context) => RandomVehicleBloc(repository: Repo()),
          child: RandomVehicleScreen(),
        );
      case "Credits":
        return CreditsScreen();
      default:
        return Text("Not Found");
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

  List<Widget> _addAppBarIcons(String selectedMenuItem) {
    if (selectedMenuItem == vehicleSearch) {
      return [
        IconButton(
          icon: Icon(
              Icons.filter_list_alt
          ),
          onPressed: () {
            _menuNavigationBloc.add(MenuItemChosen(selectedMenuItem: savedFilters));
          },
        )
      ];
    }
    else
      return [];
  }
}