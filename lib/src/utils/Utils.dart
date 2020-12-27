import 'package:flutter/material.dart';

class Utils {

  static double getScreenWidth(BuildContext context) => MediaQuery.of(context).size.width;
  static double getScreenHeight(BuildContext context) => MediaQuery.of(context).size.height;

  static Widget gap() => Container(margin: EdgeInsets.only(top: 8.0, bottom: 8.0));

  static void showSnackBar(String text, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: Duration(milliseconds: 1000),
      content: Text(
          text,
          style: TextStyle(color: Colors.white)
      ),
      backgroundColor: Theme.of(context).backgroundColor,
    ));
  }

  static final String SAVED_FILTERS_KEY = "SAVED_FILTERS";
  static final String FAVOURITES_KEY = "vehicle_favourites";

  static final String appName = "CarStats";
  static final String version = "v1.0";

  static final String appRepoUrl = "https://github.com/Vidxyz/CarDataMobileApp";
  static final String serverUrl = "https://github.com/Vidxyz/CarDataApp";
  static final String dataPipelineUrl = "https://github.com/Vidxyz/CarDataPipeline";
  static final String datasetUrl = "https://www.fueleconomy.gov/feg/download.shtml";
  static final String githubUrl = "https://github.com/Vidxyz";
  static final String linkedInUrl = "https://www.linkedin.com/in/vidxyz";

  static final String githubIconPath = "assets/github_icon.png";
  static final String linkedInIconPath = "assets/linkedin_icon.png";
  static final String creatorIconPath = "assets/creator.jpg";

}