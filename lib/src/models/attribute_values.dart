class AttributeValues {

  List<String> cylinders;
  List<String> engineDescriptor;
  List<String> fuelType;
  List<String> fuelTypePrimary;
  List<String> fuelTypeSecondary;
  List<String> make;
  List<String> year;
  List<String> transmissionType;

  AttributeValues.fromJson(Map<String, dynamic> parsedJson) {
    cylinders = List<String>.from(parsedJson['cylinders'] as List<dynamic>);
    engineDescriptor = List<String>.from(parsedJson['engine_descriptor'] as List<dynamic>);
    fuelType = List<String>.from(parsedJson['fuel_type'] as List<dynamic>);
    fuelTypePrimary = List<String>.from(parsedJson['fuel_type_primary'] as List<dynamic>);
    fuelTypeSecondary = List<String>.from(parsedJson['fuel_type_secondary'] as List<dynamic>);
    make = List<String>.from(parsedJson['make'] as List<dynamic>);
    year = List<String>.from(parsedJson['year'] as List<dynamic>);
    transmissionType = List<String>.from(parsedJson['type'] as List<dynamic>);
  }
}