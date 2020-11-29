import 'package:car_data_app/src/models/search_suggestion.dart';
import 'package:car_data_app/src/models/vehicle.dart';
import 'package:car_data_app/src/models/vehicle_image.dart';
import 'package:graphql/client.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' show Client;

class CarDataApi {

  static final String BASE_URL = "http://localhost:4000/api/vehicle/image?vehicle_id=";
  static final HttpLink _httpLink = HttpLink(uri: 'http://localhost:4000/api/graphql');
  static final Client httpClient = Client();

  static final ErrorLink _errorLink = ErrorLink(errorHandler: (ErrorResponse response) {
    OperationException exception = response.exception;
    print(exception.toString());
  });

  static final Link _link = Link.from([_errorLink, _httpLink]);
  final GraphQLClient _client = GraphQLClient(link: _link, cache: InMemoryCache());

  final int max_limit = 500;

  final String vehicleDataQuery = r'''
  query {
    vehicles(limit: 500) {
      id
      make
      model 
      year
      primaryFuel
      alternateFuel
      fuel_type
      manufacturer_code
      record_id
      alternate_fuel_type
      vehicle_class
      transmission {
        transmission_descriptor
         type
      }
    }
  }
  ''';

  String searchSuggestionsQuery(String query) {
    return r'''
    query GetSuggestions($queryString: String!) {
      search(query: $queryString, limit: 5) {
        make
        model
        year
      }
    } 
  ''';
  }

  String vehicleSearchQuery(String query, int limit, int offset) { return r'''
  query SearchVehicles($queryString: String!, $limit: int!, $offset: int!){
    search(query: $queryString, limit: $limit, offset: $offset) {
      id
      make
      model 
      year
      primary_fuel
      alternate_fuel
      fuel_type
      manufacturer_code
      record_id
      alternate_fuel_type
      vehicle_class
      dimensions {
        hatchback_luggage_volume
        hatchback_passenger_volume
        two_door_luggage_volume
        four_door_luggage_volume
        two_door_passenger_volume
        four_door_passenger_volume
      }
      transmission {
        transmission_descriptor
        type
      }
      engine {
        cylinders
        displacement
        engine_id
        engine_descriptor
        ev_motor
        is_supercharged
        is_turbocharged
        drive_type
        fuel_economy {
          barrels_per_year_primary
          barrels_per_year_secondary
          city_mpg_primary
          city_mpg_secondary
          highway_mpg_primary
          highway_mpg_secondary
          combined_mpg_primary
          combined_mpg_secondary
          annual_fuel_cost_primary
          annual_fuel_cost_secondary
          combined_power_consumption
          fuel_economy_score
          epa_range_secondary
          epa_city_range_secondary
          epa_highway_range_secondary
          is_guzzler
          time_to_charge_120v
          time_to_charge_240v
        }
        fuel_emission {
          tailpipe_co2_primary
          tailpipe_co2_secondary
          greenhouse_gas_score_primary
          greenhouse_gas_score_secondary
        }
      }
    }
  }
  ''';
  }

  Future<List<Vehicle>> getAllVehicles() async {
    QueryResult result;
    final QueryOptions options = QueryOptions(
      documentNode: gql(vehicleDataQuery)
    );

    result = await _client.query(options);

    final List<dynamic> results = result.data['vehicles'] as List<dynamic>;
    return results.map<Vehicle>((json) => Vehicle.fromJson(json)).toList();
  }

  Future<List<Vehicle>> getVehiclesBySearchQuery(String query, int limit, int offset) async {
    final QueryOptions options = QueryOptions(
      documentNode: gql(vehicleSearchQuery(query, limit, offset)),
      variables: <String, dynamic> {
        'queryString': query,
        'limit': limit,
        'offset': offset
      },

    );
    QueryResult result = await _client.query(options);
    final List<dynamic> results = result.data['search'] as List<dynamic>;
    return results.map<Vehicle>((json) => Vehicle.fromJson(json)).toList();

  }


  Future<List<VehicleImage>> getVehicleImages(String vehicleId) async {
    final response = await httpClient.get("$BASE_URL$vehicleId");
    if (response.statusCode == 200) {
      final List<dynamic> results = json.decode(response.body)['data'] as List<dynamic>;
      return results.map<VehicleImage>((json) => VehicleImage.fromJson(json)).toList();
    }
    else {
      print("Bad response: Status code " + response.statusCode.toString());
    }
  }

  Future<List<SearchSuggestion>> getSuggestions(String query) async {
    final QueryOptions options = QueryOptions(
      documentNode: gql(searchSuggestionsQuery(query)),
      variables: <String, dynamic> {
        'queryString': query
      },
    );
    QueryResult result = await _client.query(options);
    final List<dynamic> results = result.data['search'] as List<dynamic>;
    return results.map<SearchSuggestion>((json) => SearchSuggestion.fromJson(json)).toList();

  }

}