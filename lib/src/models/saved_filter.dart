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

  List<String> _getValues(dynamic jsonList) =>
      List<String>.from(jsonList as List<dynamic>).toList();

}