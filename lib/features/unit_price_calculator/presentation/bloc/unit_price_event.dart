import 'package:equatable/equatable.dart';

abstract class UnitPriceEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class CalculateUnitPriceEvent extends UnitPriceEvent {
  final List<Map<String, dynamic>> items;

  CalculateUnitPriceEvent(this.items);

  @override
  List<Object> get props => [items];
}

class SaveUnitPriceHistoryEvent extends UnitPriceEvent {}