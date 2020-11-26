class SearchSuggestion {
  String _make;
  String _model;
  int _year;

  SearchSuggestion.fromJson(Map<String, dynamic> parsedJson) {
    _make = parsedJson['make'];
    _model = parsedJson['model'];
    _year = parsedJson['year'];
  }

  int get year => _year;

  String get model => _model;

  String get make => _make;

  String toString() => _make + " " + _model + " " + year.toString();
}