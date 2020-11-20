class FuelEmission {
  int _greenhouseScorePrimary;
  int _greenhouseScoreSecondary;
  double _tailpipeCo2Primary;
  double _tailpipeCo2Secondary;

  FuelEmission.fromJson(Map<String, dynamic> parsedJson) {
    _greenhouseScorePrimary = parsedJson['greenhouse_gas_score_primary'];
    _greenhouseScoreSecondary = parsedJson['greenhouse_gas_score_secondary'];
    _tailpipeCo2Primary = parsedJson['tailpipe_co2_primary'];
    _tailpipeCo2Secondary = parsedJson['tailpipe_co2_secondary'];
  }

  double get tailpipeCo2Secondary => _tailpipeCo2Secondary;

  double get tailpipeCo2Primary => _tailpipeCo2Primary;

  int get greenhouseScoreSecondary => _greenhouseScoreSecondary;

  int get greenhouseScorePrimary => _greenhouseScorePrimary;
}