import 'package:car_data_app/src/models/fuel_economy.dart';
import 'package:car_data_app/src/models/fuel_emission.dart';

class Engine {
  double _cylinders = 0;
  double _displacement = 0;
  String _driveTrain = "";
  String _engineType = "";
  String _evMotor = "";
  bool _isTurbocharged = false;
  bool _isSupercharged = false;

  FuelEconomy _fuelEconomy = FuelEconomy();
  FuelEmission _fuelEmission = FuelEmission();


  Engine() {
    _cylinders = 0;
    _displacement = 0;
    _driveTrain = "";
    _engineType = "";
    _evMotor = "";
    _isTurbocharged = false;
    _isSupercharged = false;
    _fuelEconomy = FuelEconomy();
    _fuelEmission = FuelEmission();
  }

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