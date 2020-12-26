import 'package:equatable/equatable.dart';

abstract class RandomVehicleEvent extends Equatable {
  const RandomVehicleEvent();
}

class RandomVehicleRequested extends RandomVehicleEvent {

  const RandomVehicleRequested();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'RandomVehicleRequested { }';
}