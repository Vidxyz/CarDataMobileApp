class Dimensions {
  int _fourDoorLuggageVolume = 0;
  int _fourDoorPassengerVolume = 0;
  int _hatchbackLuggageVolume = 0;
  int _hatchbackPassengerVolume = 0;
  int _twoDoorLuggageVolume = 0;
  int _twoDoorPassengerVolume = 0;


  Dimensions() {
    _fourDoorLuggageVolume = 0;
    _fourDoorPassengerVolume = 0;
    _hatchbackLuggageVolume = 0;
    _hatchbackPassengerVolume = 0;
    _twoDoorLuggageVolume = 0;
    _twoDoorPassengerVolume = 0;
  }

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