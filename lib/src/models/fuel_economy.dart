class FuelEconomy {
  int _annualFuelCostPrimary=  0;
  int _annualFuelCostSecondary=  0;
  double _barrelsPerYearPrimary=  0;
  double _barrelsPerYearSecondary=  0;
  int _cityMpgPrimary=  0;
  int _cityMpgSecondary=  0;
  int _highwayMpgPrimary=  0;
  int _highwayMpgSecondary=  0;
  int _combinedMpgPrimary=  0;
  int _combinedMpgSecondary=  0;
  double _epaCityRangeSecondary=  0;
  double _epaHighwayRangeSecondary =  0;
  String _epaRangeSecondary = "";
  int _fuelEconomyScore = 0;
  bool _isGuzzler = false;
  double _timeToCharge120v = 0;
  double _timeToCharge240v = 0;
  double _combinedPowerConsumption = 0;


  FuelEconomy() {
    _annualFuelCostPrimary=  0;
    _annualFuelCostSecondary=  0;
    _barrelsPerYearPrimary=  0;
    _barrelsPerYearSecondary=  0;
    _cityMpgPrimary=  0;
    _cityMpgSecondary=  0;
    _highwayMpgPrimary=  0;
    _highwayMpgSecondary=  0;
    _combinedMpgPrimary=  0;
    _combinedMpgSecondary=  0;
    _epaCityRangeSecondary=  0;
    _epaHighwayRangeSecondary =  0;
    _epaRangeSecondary = "";
    _fuelEconomyScore = 0;
    _isGuzzler = false;
    _timeToCharge120v = 0;
    _timeToCharge240v = 0;
    _combinedPowerConsumption = 0;
  }

  FuelEconomy.fromJson(Map<String, dynamic> parsedJson) {
    _annualFuelCostPrimary = parsedJson['annual_fuel_cost_primary'];
    _annualFuelCostSecondary = parsedJson['annual_fuel_cost_secondary'];
    _barrelsPerYearPrimary = parsedJson['barrels_per_year_primary'];
    _barrelsPerYearSecondary = parsedJson['barrels_per_year_secondary'];
    _cityMpgPrimary = parsedJson['city_mpg_primary'];
    _cityMpgSecondary = parsedJson['city_mpg_secondary'];
    _highwayMpgPrimary = parsedJson['highway_mpg_primary'];
    _highwayMpgSecondary = parsedJson['highway_mpg_secondary'];
    _combinedMpgPrimary = parsedJson['combined_mpg_primary'];
    _combinedMpgSecondary = parsedJson['combined_mpg_secondary'];
    _epaCityRangeSecondary = parsedJson['epa_city_range_secondary'];
    _epaHighwayRangeSecondary = parsedJson['epa_highway_range_secondary'];
    _epaRangeSecondary = parsedJson['epa_range_secondary'];
    _fuelEconomyScore = parsedJson['fuel_economy_score'];
    _isGuzzler = parsedJson['is_guzzler'];
    _timeToCharge120v = parsedJson['time_to_charge_120v'];
    _timeToCharge240v = parsedJson['time_to_charge_240v'];
    _combinedPowerConsumption = parsedJson['combined_power_consumption'];
  }


  double get combinedPowerConsumption => _combinedPowerConsumption;

  double get timeToCharge240v => _timeToCharge240v;

  double get timeToCharge120v => _timeToCharge120v;

  bool get isGuzzler => _isGuzzler;

  int get fuelEconomyScore => _fuelEconomyScore;

  String get epaRangeSecondary => _epaRangeSecondary;

  double get epaHighwayRangeSecondary => _epaHighwayRangeSecondary;

  double get epaCityRangeSecondary => _epaCityRangeSecondary;

  int get combinedMpgSecondary => _combinedMpgSecondary;

  int get combinedMpgPrimary => _combinedMpgPrimary;

  int get highwayMpgSecondary => _highwayMpgSecondary;

  int get highwayMpgPrimary => _highwayMpgPrimary;

  int get cityMpgSecondary => _cityMpgSecondary;

  int get cityMpgPrimary => _cityMpgPrimary;

  double get barrelsPerYearSecondary => double.parse(_barrelsPerYearSecondary.toStringAsFixed(2));

  double get barrelsPerYearPrimary => double.parse(_barrelsPerYearPrimary.toStringAsFixed(2));

  int get annualFuelCostSecondary => _annualFuelCostSecondary;

  int get annualFuelCostPrimary => _annualFuelCostPrimary;
}