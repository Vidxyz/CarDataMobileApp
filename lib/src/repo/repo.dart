import 'package:car_data_app/src/models/attribute_values.dart';
import 'package:car_data_app/src/models/more_attribute_values.dart';
import 'package:car_data_app/src/models/vehicle.dart';
import 'package:car_data_app/src/models/vehicle_image.dart';
import 'package:car_data_app/src/models/search_suggestion.dart';
import 'package:car_data_app/src/repo/providers/car_data_api.dart';

class Repo {

  final _carDataApiProvider = CarDataApi();

  Future<Vehicle> getRandomVehicle() =>
    _carDataApiProvider.getRandomVehicle();

  Future<int> getVehiclesCountBySearchQuery(String query) =>
      _carDataApiProvider.getVehiclesCountBySearchQuery(query);

  Future<List<Vehicle>> getVehiclesBySearchQuery(String query, int limit, int offset) =>
      _carDataApiProvider.getVehiclesBySearchQuery(query, limit, offset);

  Future<List<Vehicle>> getVehiclesByIds(List<String> vehicleIds, int limit, int offset) =>
      _carDataApiProvider.getVehiclesByIds(vehicleIds, limit, offset);

  Future<List<VehicleImage>> getVehicleImages(String vehicleId) => _carDataApiProvider.getVehicleImages(vehicleId);

  Future<List<SearchSuggestion>> getSuggestions(String query) => _carDataApiProvider.getSuggestions(query);

  Future<AttributeValues> getAttributeValues() => _carDataApiProvider.getAttributeValues();

  Future<MoreAttributeValues> getMoreAttributeValues() => _carDataApiProvider.getMoreAttributeValues();

  Future<List<Vehicle>> getVehiclesBySelectedAttributes(Map<String, List<String>> selectedAttributes, int limit, int offset) =>
      _carDataApiProvider.getVehiclesBySelectedAttributes(selectedAttributes, limit, offset);

  Future<int> getVehicleCountBySelectedAttributes(Map<String, List<String>> selectedAttributes) =>
      _carDataApiProvider.getVehicleCountBySelectedAttributes(selectedAttributes);

}