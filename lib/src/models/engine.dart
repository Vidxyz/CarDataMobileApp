import 'package:CarPedia/src/models/fuel_economy.dart';
import 'package:CarPedia/src/models/fuel_emission.dart';

class Engine {
  double _cylinders;
  double _displacement;
  String _driveTrain;
  String _engineType;
  String _evMotor;
  bool _isTurbocharged;
  bool _isSupercharged;

  FuelEconomy _fuelEconomy;
  FuelEmission _fuelEmission;

  Engine.fromJson(Map<String, dynamic> parsedJson) {
    _cylinders = parsedJson['cylinders'];
    _displacement = parsedJson['displacement'];
    _driveTrain = parsedJson['drive_type'];
    _engineType = parsedJson['engine_descriptor'];
    _evMotor = parsedJson['ev_motor'];
    _isTurbocharged = parsedJson['is_turbocharged'];
    _isSupercharged = parsedJson['is_supercharged'];

    _fuelEconomy = FuelEconomy.fromJson(parsedJson['fuel_economy']);
    _fuelEmission = FuelEmission.fromJson(parsedJson['fuel_emission']);
  }


  FuelEconomy get fuelEconomy => _fuelEconomy;

  bool get isSupercharged => _isSupercharged;

  bool get isTurbocharged => _isTurbocharged;

  String get evMotor => _evMotor;

  String get engineType => _engineType;

  String get driveTrain => _driveTrain;

  double get displacement => _displacement;

  double get cylinders => _cylinders;

  FuelEmission get fuelEmission => _fuelEmission;
}