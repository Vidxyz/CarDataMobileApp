class MoreAttributeValues {

  Map<String, List<String>> attributeValues = {};

  List<String> _cityMpg = [];
  List<String> _highwayMpg = [];
  List<String> _combinedMpg = [];
  List<String> _annualFuelCost = [];
  List<String> _tailpipeCO2 = [];
  List<String> _ghScore = [];
  List<String> _fuelEconomyScore = [];


  MoreAttributeValues.fromJson(Map<String, dynamic> parsedJson) {
    _cityMpg = _getValues(parsedJson['city_mpg_primary']);
    _highwayMpg = _getValues(parsedJson['highway_mpg_primary']);
    _combinedMpg = _getValues(parsedJson['combined_mpg_primary']);
    _tailpipeCO2 = _getValues(parsedJson['tailpipe_co2_primary']);
    _annualFuelCost = _getValues(parsedJson['annual_fuel_cost_primary']);
    _ghScore = _getValues(parsedJson['gh_gas_score_primary']);
    _fuelEconomyScore = _getValues(parsedJson['fuel_economy_score']);

    attributeValues = {
      "city_mpg_primary": _cityMpg,
      "highway_mpg_primary": _highwayMpg,
      "combined_mpg_primary": _combinedMpg,
      "tailpipe_co2_primary": _tailpipeCO2,
      "annual_fuel_cost_primary": _annualFuelCost,
      "gh_gas_score_primary": _ghScore,
      "fuel_economy_score": _fuelEconomyScore,
    };
  }

  List<String> _getValues(dynamic jsonList) =>
      List<String>.from(jsonList as List<dynamic>).where((element) => element != null).toList();
}