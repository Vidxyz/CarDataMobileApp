import 'package:flutter/material.dart';

class Utils {

  static getScreenWidth(BuildContext context) => MediaQuery.of(context).size.width;
  static getScreenHeight(BuildContext context) => MediaQuery.of(context).size.height;

  static Widget Gap() => Container(margin: EdgeInsets.only(top: 8.0, bottom: 8.0));

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
}