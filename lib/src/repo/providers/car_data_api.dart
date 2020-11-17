import 'package:car_data_app/src/models/vehicle.dart';
import 'package:graphql/client.dart';
import 'dart:async';

class CarDataApi {
  
  static final HttpLink _httpLink = HttpLink(uri: 'http://localhost:4000/api/graphql');

  static final ErrorLink _errorLink = ErrorLink(errorHandler: (ErrorResponse response) {
    OperationException exception = response.exception;
    print(exception.toString());
  });

  static final Link _link = Link.from([_errorLink, _httpLink]);
  final GraphQLClient _client = GraphQLClient(link: _link, cache: InMemoryCache());

  final int limit = 500;

  final String vehicleDataQuery = r'''
  query {
    vehicles(limit: 500) {
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

  String vehicleSearchQuery(String query) { return r'''
  query SearchVehicles($queryString: String!){
    search(query: $queryString) {
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

  Future<List<Vehicle>> getVehiclesBySearchQuery(String query) async {
    final QueryOptions options = QueryOptions(
      documentNode: gql(vehicleSearchQuery(query)),
      variables: <String, dynamic> {
        'queryString': query
      },

    );
    QueryResult result = await _client.query(options);

    final List<dynamic> results = result.data['search'] as List<dynamic>;
    return results.map<Vehicle>((json) => Vehicle.fromJson(json)).toList();

  }

}