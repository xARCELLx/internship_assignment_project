import 'package:equatable/equatable.dart';
import 'package:multi_calculator_app/features/unit_price_calculator/domain/entities/unit_price_result.dart';

abstract class UnitPriceState extends Equatable {
  @override
  List<Object> get props => [];
}

class UnitPriceInitial extends UnitPriceState {}

class UnitPriceCalculating extends UnitPriceState {}

class UnitPriceCalculated extends UnitPriceState {
  final UnitPriceResult result;

  UnitPriceCalculated(this.result);

  @override
  List<Object> get props => [result];
}

class UnitPriceError extends UnitPriceState {
  final String message;

  UnitPriceError(this.message);

  @override
  List<Object> get props => [message];
}