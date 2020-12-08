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
  List<String> _displacement;

  AttributeValues.fromJson(Map<String, dynamic> parsedJson) {
    _cylinders = _getValues(parsedJson['cylinders']);
    _displacement = _getValues(parsedJson['displacement']);
    _engineDescriptor = _getValues(parsedJson['engine_descriptor']);
    _fuelTypePrimary = _getValues(parsedJson['fuel_type_primary']);
    _fuelTypeSecondary = _getValues(parsedJson['fuel_type_secondary']);
    _fuelType = _getValues(parsedJson['fuel_type']);
    _make = _getValues(parsedJson['make']);
    _year = _getValues(parsedJson['year']);
    _transmissionType = _getValues(parsedJson['type']);

    attributeValues = {
      "cylinders": _cylinders,
      "engine_descriptor": _engineDescriptor,
      "fuel_type": _fuelType,
      "fuel_type_primary": _fuelTypePrimary,
      "fuel_type_secondary": _fuelTypeSecondary,
      "make": _make,
      "year": _year,
      "type": _transmissionType,
      "displacement": _displacement
    };
  }

  List<String> _getValues(dynamic jsonList) =>
      List<String>.from(jsonList as List<dynamic>).where((element) => element != null).toList();
}