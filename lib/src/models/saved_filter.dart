class SavedFilter {
  String id;
  String name;
  Map<String, List<String>> selections;

  SavedFilter.from(String fId, String fName, Map<String, List<String>> fSelections) {
    id = fId;
    name = fName;
    selections = fSelections;
  }

  SavedFilter.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    Map<String, dynamic> rawSelections = json['selections'];
    selections = rawSelections.map((key, value) => MapEntry(key, _getValues(value)));
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'selections': selections
  };
  
  String toString() {
    return selections.entries.map((e) => "|${filterNameToDisplayNameMap[e.key]}| - ${e.value.join(", ")}").toList().join('\n');
  }

  List<String> _getValues(dynamic jsonList) =>
      List<String>.from(jsonList as List<dynamic>).toList();

  static final filterNameToDisplayNameMap = {
    "make": "Make",
    "year": "Year",
    "fuel_type_primary": "Primary Fuel",
    "fuel_type_secondary": "Secondary Fuel",
    "fuel_type": "Fuel Grade",
    "engine_descriptor": "Engine",
    "type": "Transmission",
    "cylinders": "Cylinders",
    "displacement": "Displacement",
    "city_mpg_primary": "City Mpg",
    "highway_mpg_primary": "Highway Mpg",
    "combined_mpg_primary": "Combined Mpg",
    "annual_fuel_cost_primary": "Annual Fuel Cost (\$)",
    "fuel_economy_score": "Fuel Economy Score",
    "tailpipe_co2_primary": "CO2 Emissions",
    "gh_gas_score_primary": "Greenhouse Gas Score",
    "sort_by": "Sort By",
  };

}