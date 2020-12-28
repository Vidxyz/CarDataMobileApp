import 'package:car_data_app/src/models/attribute_values.dart';
import 'package:car_data_app/src/models/more_attribute_values.dart';
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

  static final policies = Policies(
    fetch: FetchPolicy.networkOnly,
  );

  final GraphQLClient _noCacheClient = GraphQLClient(
    link: _link,
    cache: InMemoryCache(),
    defaultPolicies: DefaultPolicies(
      watchQuery: policies,
      query: policies,
    )
  );

  final int maxLimit = 500;

  static final sortCriteriaToRawMap = {
    "City Mpg": "city_mpg_primary",
    "Highway Mpg": "highway_mpg_primary",
    "Combined Mpg": "combined_mpg_primary",
    "Annual Fuel Cost": "annual_fuel_cost_primary",
    "Fuel Economy": "fuel_economy_score",
    "CO2 Emissions": "tailpipe_co2_primary",
    "Greenhouse Score": "gh_gas_score_primary",
  };

  static final sortOrderToRawMap = {
    "Descending": "desc",
    "Ascending": "asc",
  };


  static final yesNoToBooleanMap = {
    "Yes": true,
    "No": false,
  };

  String vehicleSearchCountByAttributesQuery() {
    return r'''
    query CountVehiclesByAttributes(
      $fuel_type_primary: [String],
      $fuel_type_secondary: [String],
      $fuel_type: [String],
      $make: [String],
      $type: [String],
      $vehicle_class: [String],
      $engine_descriptor: [String],
      $year: [int],
      $cylinders: [float],
      $displacement: [float],
      $is_supercharged: [boolean],
      $is_turbocharged: [boolean],
      $is_guzzler: [boolean],
      $city_mpg_primary: [int],
      $highway_mpg_primary: [int],
      $combined_mpg_primary: [int],
      $annual_fuel_cost_primary: [int],
      $fuel_economy_score: [int],
      $tailpipe_co2_primary: [float],
      $gh_gas_score_primary: [int],
      $sort_by: String!,
      $order: String!) {
      
      attributeSearchCount(
        make: $make, 
        fuel_type: $fuel_type,
        fuel_type_primary: $fuel_type_primary,
        fuel_type_secondary: $fuel_type_secondary,
        type: $type,
        vehicle_class: $vehicle_class,
        engine_descriptor: $engine_descriptor,
        displacement: $displacement,
        cylinders: $cylinders,
        year: $year, 
        is_supercharged: $is_supercharged, 
        is_turbocharged: $is_turbocharged, 
        is_guzzler: $is_guzzler, 
        city_mpg_primary: $city_mpg_primary,
        highway_mpg_primary: $highway_mpg_primary,
        combined_mpg_primary: $combined_mpg_primary,
        annual_fuel_cost_primary: $annual_fuel_cost_primary,
        fuel_economy_score: $fuel_economy_score,
        tailpipe_co2_primary: $tailpipe_co2_primary,
        gh_gas_score_primary: $gh_gas_score_primary,
        sort_by: $sort_by,
        order: $order
      ) 
    }
    ''';
  }

  String vehicleSearchByAttributesQuery() {
    return r'''
    query SearchVehiclesByAttributes(
      $fuel_type_primary: [String],
      $fuel_type_secondary: [String],
      $fuel_type: [String],
      $make: [String],
      $type: [String],
      $vehicle_class: [String],
      $engine_descriptor: [String],
      $year: [int],
      $cylinders: [float],
      $displacement: [float],
      $is_supercharged: [boolean],
      $is_turbocharged: [boolean],
      $is_guzzler: [boolean],
      $city_mpg_primary: [int],
      $highway_mpg_primary: [int],
      $combined_mpg_primary: [int],
      $annual_fuel_cost_primary: [int],
      $fuel_economy_score: [int],
      $tailpipe_co2_primary: [float],
      $gh_gas_score_primary: [int],
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
      vehicle_class: $vehicle_class,
      engine_descriptor: $engine_descriptor,
      displacement: $displacement,
      cylinders: $cylinders,
      year: $year, 
      is_supercharged: $is_supercharged, 
      is_turbocharged: $is_turbocharged, 
      is_guzzler: $is_guzzler, 
      city_mpg_primary: $city_mpg_primary,
      highway_mpg_primary: $highway_mpg_primary,
      combined_mpg_primary: $combined_mpg_primary,
      annual_fuel_cost_primary: $annual_fuel_cost_primary,
      fuel_economy_score: $fuel_economy_score,
      tailpipe_co2_primary: $tailpipe_co2_primary,
      gh_gas_score_primary: $gh_gas_score_primary,
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
            greenhouse_gas_score_primary
            greenhouse_gas_score_secondary
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
        "displacement",
        "vehicle_class"
      ]) {
        fuel_type_primary,
        fuel_type_secondary,
        fuel_type,
        make,
        year,
        type,
        cylinders,
        engine_descriptor,
        displacement,
        vehicle_class
      }
    }
    ''';
  }

  String moreAttributeValuesQuery() {
    return r'''
    query GetMoreAttributeValues {
      attributeValues(attributes: [
        "city_mpg_primary",
        "highway_mpg_primary",
        "combined_mpg_primary",
        "annual_fuel_cost_primary",
        "fuel_economy_score",
        "tailpipe_co2_primary",
        "gh_gas_score_primary"
      ]) {
          city_mpg_primary,
          highway_mpg_primary,
          combined_mpg_primary,
          annual_fuel_cost_primary,
          fuel_economy_score,
          tailpipe_co2_primary,
          gh_gas_score_primary
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

  String fetchVehiclesByIds() { return r'''
  query FetchVehiclesByIds($vehicleIds: [id]!, $limit: int!, $offset: int!) {
    vehicles_by_id(ids: $vehicleIds, limit: $limit, offset: $offset) {
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

  String randomVehicleQuery() { return r'''
  query RandomVehicle {
    random_vehicle {
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

  String vehicleCountSearchQuery() { return r'''
  query CountSearchVehicles($queryString: String!){
    searchCount(query: $queryString)
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

  Future<Vehicle> getRandomVehicle() async {
    final QueryOptions options = QueryOptions(
      documentNode: gql(randomVehicleQuery()),
    );
    QueryResult result = await _noCacheClient.query(options);
    return Vehicle.fromJson(result.data['random_vehicle']);
  }

  Future<int> getVehiclesCountBySearchQuery(String query) async {
    final QueryOptions options = QueryOptions(
      documentNode: gql(vehicleCountSearchQuery()),
      variables: <String, dynamic> {
        'queryString': query,
      },
    );
    QueryResult result = await _client.query(options);
    final int resultCount = result.data['searchCount'] as int;
    return resultCount;
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

  Future<List<Vehicle>> getVehiclesByIds(List<String> vehicleIds, int limit, int offset) async {
    final QueryOptions options = QueryOptions(
      documentNode: gql(fetchVehiclesByIds()),
      variables: <String, dynamic> {
        'vehicleIds': vehicleIds,
        'limit': limit,
        'offset': offset
      },

    );
    QueryResult result = await _client.query(options);
    final List<dynamic> results = result.data['vehicles_by_id'] as List<dynamic>;
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
      return null;
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

  Future<MoreAttributeValues> getMoreAttributeValues() async {
    final QueryOptions options = QueryOptions(
      documentNode: gql(moreAttributeValuesQuery()),
    );
    QueryResult result = await _client.query(options);
    final response = result.data['attributeValues'] as Map<dynamic, dynamic>;
    return MoreAttributeValues.fromJson(response);
  }

  Future<int> getVehicleCountBySelectedAttributes(Map<String, List<String>> selectedAttributes) async {
    final QueryOptions options = QueryOptions(
      documentNode: gql(vehicleSearchCountByAttributesQuery()),
      variables: <String, dynamic> {
        'make': selectedAttributes['make'] ?? [],
        'fuel_type': selectedAttributes['fuel_type'] ?? [],
        'fuel_type_primary': selectedAttributes['fuel_type_primary'] ?? [],
        'fuel_type_secondary': selectedAttributes['fuel_type_secondary'] ?? [],
        'type': selectedAttributes['type'] ?? [],
        'vehicle_class': selectedAttributes['vehicle_class'] ?? [],
        'engine_descriptor': selectedAttributes['engine_descriptor'] ?? [],
        'displacement': selectedAttributes['displacement']?.map((e) => double.parse(e))?.toList() ?? [],
        'cylinders': selectedAttributes['cylinders']?.map((e) => double.parse(e))?.toList() ?? [],
        'year': selectedAttributes['year']?.map((e) => int.parse(e))?.toList() ?? [],
        'is_supercharged': selectedAttributes['is_supercharged']?.map((e) => yesNoToBooleanMap[e])?.toList() ?? [],
        'is_turbocharged': selectedAttributes['is_turbocharged']?.map((e) => yesNoToBooleanMap[e])?.toList() ?? [],
        'is_guzzler': selectedAttributes['is_guzzler']?.map((e) => yesNoToBooleanMap[e])?.toList() ?? [],
        'city_mpg_primary': selectedAttributes['city_mpg_primary']?.map((e) => int.parse(e))?.toList() ?? [],
        'highway_mpg_primary': selectedAttributes['highway_mpg_primary']?.map((e) => int.parse(e))?.toList() ?? [],
        'combined_mpg_primary': selectedAttributes['combined_mpg_primary']?.map((e) => int.parse(e))?.toList() ?? [],
        'annual_fuel_cost_primary': selectedAttributes['annual_fuel_cost_primary']?.map((e) => int.parse(e))?.toList() ?? [],
        'fuel_economy_score': selectedAttributes['fuel_economy_score']?.map((e) => int.parse(e))?.toList() ?? [],
        'gh_gas_score_primary': selectedAttributes['gh_gas_score_primary']?.map((e) => int.parse(e))?.toList() ?? [],
        'tailpipe_co2_primary': selectedAttributes['tailpipe_co2_primary']?.map((e) => double.parse(e))?.toList() ?? [],
        'sort_by': selectedAttributes['sort_by'] == null ? "" :
        (selectedAttributes['sort_by'].isEmpty ? "" : sortCriteriaToRawMap[selectedAttributes['sort_by'].first]),
        'order': selectedAttributes['sort_order'] == null ? "desc" :
        (selectedAttributes['sort_order'].isEmpty ? "desc" : sortOrderToRawMap[selectedAttributes['sort_order'].first]),
      },

    );
    QueryResult result = await _client.query(options);
    final int resultCount = result.data['attributeSearchCount'] as int;
    return resultCount;
  }

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
        'vehicle_class': selectedAttributes['vehicle_class'] ?? [],
        'engine_descriptor': selectedAttributes['engine_descriptor'] ?? [],
        'displacement': selectedAttributes['displacement']?.map((e) => double.parse(e))?.toList() ?? [],
        'cylinders': selectedAttributes['cylinders']?.map((e) => double.parse(e))?.toList() ?? [],
        'year': selectedAttributes['year']?.map((e) => int.parse(e))?.toList() ?? [],
        'is_supercharged': selectedAttributes['is_supercharged']?.map((e) => yesNoToBooleanMap[e])?.toList() ?? [],
        'is_turbocharged': selectedAttributes['is_turbocharged']?.map((e) => yesNoToBooleanMap[e])?.toList() ?? [],
        'is_guzzler': selectedAttributes['is_guzzler']?.map((e) => yesNoToBooleanMap[e])?.toList() ?? [],
        'city_mpg_primary': selectedAttributes['city_mpg_primary']?.map((e) => int.parse(e))?.toList() ?? [],
        'highway_mpg_primary': selectedAttributes['highway_mpg_primary']?.map((e) => int.parse(e))?.toList() ?? [],
        'combined_mpg_primary': selectedAttributes['combined_mpg_primary']?.map((e) => int.parse(e))?.toList() ?? [],
        'annual_fuel_cost_primary': selectedAttributes['annual_fuel_cost_primary']?.map((e) => int.parse(e))?.toList() ?? [],
        'fuel_economy_score': selectedAttributes['fuel_economy_score']?.map((e) => int.parse(e))?.toList() ?? [],
        'gh_gas_score_primary': selectedAttributes['gh_gas_score_primary']?.map((e) => int.parse(e))?.toList() ?? [],
        'tailpipe_co2_primary': selectedAttributes['tailpipe_co2_primary']?.map((e) => double.parse(e))?.toList() ?? [],
        'limit': limit,
        'offset': offset,
        'sort_by': selectedAttributes['sort_by'] == null ? "" :
        (selectedAttributes['sort_by'].isEmpty ? "" : sortCriteriaToRawMap[selectedAttributes['sort_by'].first]),
        'order': selectedAttributes['sort_order'] == null ? "desc" :
        (selectedAttributes['sort_order'].isEmpty ? "desc" : sortOrderToRawMap[selectedAttributes['sort_order'].first]),
      },

    );
    QueryResult result = await _client.query(options);
    final List<dynamic> results = result.data['attributeSearch'] as List<dynamic>;
    return results.map<Vehicle>((json) => Vehicle.fromJson(json)).toList();
  }

}