import 'dart:async';

import 'package:car_data_app/src/blocs/bloc.dart';

class AppPropertiesBloc extends Bloc {

  StreamController<String> _title = StreamController<String>();

  Stream<String> get titleStream => _title.stream;

  updateTitle(String newTitle){
    _title.sink.add(newTitle);
  }

  @override
  void dispose() {
    print("approp bloc dispose called");
    _title.close();
  }
}