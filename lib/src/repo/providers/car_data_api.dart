import 'package:car_data_app/src/models/attribute_values.dart';
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

  final int maxLimit = 500;

  static final sortCriteriaToRawMap = {
    "City Mpg": "city_mpg_primary",
    "Highway Mpg": "highway_mpg_primary",
    "Combined Mpg": "combined_mpg_primary",
    "Annual Fuel Cost": "annual_fuel_cost_primary",
    "Fuel Economy": "fuel_economy_score",
    "CO2 Emissions": "tailpipe_co2_primary",
    "Greenhouse Gas Score": "greenhouse_gas_score_primary",
  };

  String vehicleSearchByAttributesQuery() {
    return r'''
    query SearchVehiclesByAttributes(
      $fuel_type_primary: [String],
      $fuel_type_secondary: [String],
      $fuel_type: [String],
      $make: [String],
      $type: [String],
      $engine_descriptor: [String],
      $year: [int],
      $cylinders: [float],
      $displacement: [float],
      $limit: int!, 
      $offset: int!,
      $sort_by: String!,
      $order: String!) {
      
      attributeSearch(
      make: $make, 
      fuel_type: $fuel_type,
      fuel_type_primary: $fuel_type_primary,
      fuel_type_secondary: $fuel_type_secondary,
      type: $type,
      engine_descriptor: $engine_descriptor,
      displacement: $displacement,
      cylinders: $cylinders,
      year: $year, 
      limit: $limit,
      offset: $offset,
      sort_by: $sort_by,
      order: $order
      ) {
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
            greenhouseGasScorePrimary
            greenhouseGasScoreSecondary
          }
        }
      }
    }
    ''';
  }

  String attributeValuesQuery() {
    return r'''
    query GetAttributeValues {
      attributeValues(attributes: [
        "fuel_type_primary",
        "fuel_type_secondary",
        "fuel_type",
        "make",
        "year",
        "type",
        "cylinders",
        "engine_descriptor"
        "displacement"
      ]) {
        fuel_type_primary,
        fuel_type_secondary,
        fuel_type,
        make,
        year,
        type,
        cylinders,
        engine_descriptor,
        displacement
      }
    }
    ''';
  }

  String searchSuggestionsQuery() {
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

  String vehicleSearchQuery() { return r'''
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

  Future<List<Vehicle>> getVehiclesBySearchQuery(String query, int limit, int offset) async {
    final QueryOptions options = QueryOptions(
      documentNode: gql(vehicleSearchQuery()),
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
      documentNode: gql(searchSuggestionsQuery()),
      variables: <String, dynamic> {
        'queryString': query
      },
    );
    QueryResult result = await _client.query(options);
    final List<dynamic> results = result.data['search'] as List<dynamic>;
    return results.map<SearchSuggestion>((json) => SearchSuggestion.fromJson(json)).toList();

  }

  Future<AttributeValues> getAttributeValues() async {
    final QueryOptions options = QueryOptions(
      documentNode: gql(attributeValuesQuery()),
    );
    QueryResult result = await _client.query(options);
    final response = result.data['attributeValues'] as Map<dynamic, dynamic>;
    return AttributeValues.fromJson(response);
  }

  // This needs to modify certain attributes into double/int values based on their key
  Future<List<Vehicle>> getVehiclesBySelectedAttributes(Map<String, List<String>> selectedAttributes,
      int limit, int offset) async {
    final QueryOptions options = QueryOptions(
      documentNode: gql(vehicleSearchByAttributesQuery()),
      variables: <String, dynamic> {
        'make': selectedAttributes['make'] ?? [],
        'fuel_type': selectedAttributes['fuel_type'] ?? [],
        'fuel_type_primary': selectedAttributes['fuel_type_primary'] ?? [],
        'fuel_type_secondary': selectedAttributes['fuel_type_secondary'] ?? [],
        'type': selectedAttributes['type'] ?? [],
        'engine_descriptor': selectedAttributes['engine_descriptor'] ?? [],
        'displacement': selectedAttributes['displacement']?.map((e) => double.parse(e))?.toList() ?? [],
        'cylinders': selectedAttributes['cylinders']?.map((e) => double.parse(e))?.toList() ?? [],
        'year': selectedAttributes['year']?.map((e) => int.parse(e))?.toList() ?? [],
        'limit': limit,
        'offset': offset,
        'sort_by': selectedAttributes['sort_by'].isEmpty ? "" : sortCriteriaToRawMap[selectedAttributes['sort_by'].first],
        'order': 'desc', // need to work on this
      },

    );
    QueryResult result = await _client.query(options);
    final List<dynamic> results = result.data['attributeSearch'] as List<dynamic>;
    return results.map<Vehicle>((json) => Vehicle.fromJson(json)).toList();
  }

}