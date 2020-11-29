import 'package:car_data_app/src/models/vehicle.dart';
import 'package:car_data_app/src/models/vehicle_image.dart';
import 'package:car_data_app/src/models/search_suggestion.dart';
import 'package:car_data_app/src/repo/providers/car_data_api.dart';

class Repo {

  final carDataApiProvider = CarDataApi();

  Future<List<Vehicle>> getVehiclesBySearchQuery(String query, int limit, int offset) =>
      carDataApiProvider.getVehiclesBySearchQuery(query, limit, offset);

  Future<List<VehicleImage>> getVehicleImages(String vehicleId) => carDataApiProvider.getVehicleImages(vehicleId);

  Future<List<SearchSuggestion>> getSuggestions(String query) => carDataApiProvider.getSuggestions(query);

}