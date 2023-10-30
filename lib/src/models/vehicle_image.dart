import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

class VehicleImage {
  String _id = "";
  String _vehicle_id = "";
  int _width = 0;
  int _height = 0;
  String _image64 = "";



  Completer<ImageInfo> completer = new Completer<ImageInfo>();
  Image? _image;

  String get id => _id;

  String get vehicleId => _vehicle_id;

  String get image64 => _image64;

  int get height => _height;

  int get width => _width;

  Image? get image => _image;

  VehicleImage.fromJson(Map<String, dynamic> parsedJson) {
    _id = parsedJson['id'];
    _vehicle_id = parsedJson['vehicle_id'];
    _width = parsedJson['width'];
    _height = parsedJson['height'];
    _image64 = parsedJson['image'];
    _image = Image.memory(base64Decode(_image64));
  }

}