import 'dart:async';
import 'package:car_data_app/src/blocs/bloc.dart';
import 'package:car_data_app/src/models/vehicle_image.dart';
import 'package:car_data_app/src/repo/repo.dart';
import 'package:rxdart/rxdart.dart';


class VehicleImagesBloc implements Bloc {

  final _repo = Repo();
  final _vehicleId = PublishSubject<String>();
  final _images = BehaviorSubject<Future<List<VehicleImage>>>();

  Function(String) get fetchImagesByVehicleId => _vehicleId.sink.add;
  Stream<Future<List<VehicleImage>>> get vehicleImages => _images.stream;

  VehicleImagesBloc() {
    _vehicleId.stream.transform(_itemTransformer()).pipe(_images);
  }


  _itemTransformer() {
    return ScanStreamTransformer(
        (Future<List<VehicleImage>> images, String vehicleId, int index) {
          images = _repo.getVehicleImages(vehicleId);
          return images;
        }
    );
  }

  @override
  void dispose() async {
    _vehicleId.close();
    await _images.drain();
    _images.close();
  }


}