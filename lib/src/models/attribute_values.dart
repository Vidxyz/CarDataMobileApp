class AttributeValues {

  Map<String, List<String>> attributeValues;

  List<String> _cylinders;
  List<String> _engineDescriptor;
  List<String> _fuelType;
  List<String> _fuelTypePrimary;
  List<String> _fuelTypeSecondary;
  List<String> _make;
  List<String> _year;
  List<String> _transmissionType;

  AttributeValues.fromJson(Map<String, dynamic> parsedJson) {
    _cylinders = List<String>.from(parsedJson['cylinders'] as List<dynamic>);
    _engineDescriptor = List<String>.from(parsedJson['engine_descriptor'] as List<dynamic>);
    _fuelType = List<String>.from(parsedJson['fuel_type'] as List<dynamic>);
    _fuelTypePrimary = List<String>.from(parsedJson['fuel_type_primary'] as List<dynamic>);
    _fuelTypeSecondary = List<String>.from(parsedJson['fuel_type_secondary'] as List<dynamic>);
    _make = List<String>.from(parsedJson['make'] as List<dynamic>);
    _year = List<String>.from(parsedJson['year'] as List<dynamic>);
    _transmissionType = List<String>.from(parsedJson['type'] as List<dynamic>);

    attributeValues = {
      "cylinders": _cylinders,
      "engine_descriptor": _engineDescriptor,
      "fuel_type": _fuelType,
      "fuel_type_primary": _fuelTypePrimary,
      "fuel_type_secondary": _fuelTypeSecondary,
      "make": _make,
      "model": _year,
      "type": _transmissionType
    };
  }
}