import 'package:car_data_app/src/models/transmission.dart';

class Vehicle {
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

  Vehicle.fromJson(Map<String, dynamic> parsedJson) {
    _id = parsedJson['id'];
    _make = parsedJson['make'];
    _model = parsedJson['model'];
    _year = parsedJson['year'];
    _primaryFuel = parsedJson['fuel_type_primary'];
    _secondaryFuel = parsedJson['fuel_type_secondary'];
    _fuelType = parsedJson['fuel_type'];
    _manufacturerCode = parsedJson['manufacturer_code'];
    _recordId = parsedJson['record_id'];
    _alternateFuelType = parsedJson['alternative_fuel_type'];
    _vehicleClass = parsedJson['vehicle_class'];
    _transmission =  Transmission.fromJson(parsedJson['transmission']);
  }
  String get id => _id;

  String get make => _make;

  String get model => _model;

  int get year => _year;

  String get primary_fuel => _primaryFuel;

  String get secondary_fuel => _secondaryFuel;

  String get fuel_type => _fuelType;

  String get manufacturer_code => _manufacturerCode;

  int get record_id => _recordId;

  String get alternate_fuel_type => _alternateFuelType;

  String get vehicle_class => _vehicleClass;

  Transmission get transmission => _transmission;
}