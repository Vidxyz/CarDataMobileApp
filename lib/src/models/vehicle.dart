import 'package:CarPedia/src/models/dimensions.dart';
import 'package:CarPedia/src/models/engine.dart';
import 'package:CarPedia/src/models/transmission.dart';

class
Vehicle {
  String _id;
  String _make;
  String _model;
  int _year;
  String _primaryFuel;
  String _secondaryFuel;
  String _fuelType;
  String _manufacturerCode;
  int _recordId;
  String _alternateFuelType;
  String _vehicleClass;

  Transmission _transmission;
  Engine _engine;
  Dimensions _dimensions;

  Vehicle.fromJson(Map<String, dynamic> parsedJson) {
    _id = parsedJson['id'];
    _make = parsedJson['make'];
    _model = parsedJson['model'];
    _year = parsedJson['year'];
    _primaryFuel = parsedJson['primary_fuel'];
    _secondaryFuel = parsedJson['alternate_fuel'];
    _fuelType = parsedJson['fuel_type'];
    _manufacturerCode = parsedJson['manufacturer_code'];
    _recordId = parsedJson['record_id'];
    _alternateFuelType = parsedJson['alternative_fuel_type'];
    _vehicleClass = parsedJson['vehicle_class'];

    _transmission =  Transmission.fromJson(parsedJson['transmission']);
    _engine = Engine.fromJson(parsedJson['engine']);
    _dimensions = Dimensions.fromJson(parsedJson['dimensions']);

  }

  Dimensions get dimensions => _dimensions;

  Engine get engine => _engine;

  Transmission get transmission => _transmission;

  String get vehicleClass => _vehicleClass;

  String get alternateFuelType => _alternateFuelType;

  int get recordId => _recordId;

  String get manufacturerCode => _manufacturerCode;

  String get fuelType => _fuelType;

  String get secondaryFuel => _secondaryFuel;

  String get primaryFuel => _primaryFuel;

  int get year => _year;

  String get model => _model;

  String get make => _make;

  String get id => _id;

  String toString() => _model + " " + _make + " " + _year.toString();

}