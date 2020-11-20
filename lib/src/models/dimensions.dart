class Dimensions {
  int _fourDoorLuggageVolume;
  int _fourDoorPassengerVolume;
  int _hatchbackLuggageVolume;
  int _hatchbackPassengerVolume;
  int _twoDoorLuggageVolume;
  int _twoDoorPassengerVolume;

  Dimensions.fromJson(Map<String, dynamic> parsedJson) {
    _fourDoorLuggageVolume = parsedJson['four_door_luggage_volume'];
    _fourDoorPassengerVolume = parsedJson['four_door_passenger_volume'];
    _hatchbackLuggageVolume = parsedJson['hatchback_luggage_volume'];
    _hatchbackPassengerVolume = parsedJson['hatchback_passenger_volume'];
    _twoDoorLuggageVolume = parsedJson['two_door_luggage_volume'];
    _twoDoorPassengerVolume = parsedJson['two_door_passenger_volume'];
  }

  int get twoDoorPassengerVolume => _twoDoorPassengerVolume;

  int get twoDoorLuggageVolume => _twoDoorLuggageVolume;

  int get hatchbackPassengerVolume => _hatchbackPassengerVolume;

  int get hatchbackLuggageVolume => _hatchbackLuggageVolume;

  int get fourDoorPassengerVolume => _fourDoorPassengerVolume;

  int get fourDoorLuggageVolume => _fourDoorLuggageVolume;
}