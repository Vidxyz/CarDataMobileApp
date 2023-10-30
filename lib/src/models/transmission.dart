class Transmission {
  String _type = "";
  String _descriptor = "";


  Transmission(this._type, this._descriptor);

  Transmission.fromJson(Map<String, dynamic> parsedJson) {
    _type = parsedJson['type'];
    _descriptor = parsedJson['transmission_descriptor'];
  }

  String get descriptor => _descriptor;

  String get type => _type;
}