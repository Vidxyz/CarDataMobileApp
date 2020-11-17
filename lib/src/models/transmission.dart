class Transmission {
  String _type;
  String _descriptor;

  Transmission.fromJson(Map<String, dynamic> parsedJson) {
    _type = parsedJson['type'];
    _descriptor = parsedJson['transmission_descriptor'];
  }
}