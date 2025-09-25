import 'package:equatable/equatable.dart';
import 'package:multi_calculator_app/features/cash_calculator/domain/entities/cash_result.dart';

abstract class CashState extends Equatable {
  @override
  List<Object> get props => [];
}

class CashInitial extends CashState {}

class CashCalculating extends CashState {}

class CashCalculated extends CashState {
  final CashResult result;

  CashCalculated(this.result);

  @override
  List<Object> get props => [result];
}

class CashError extends CashState {
  final String message;

  CashError(this.message);

  @override
  List<Object> get props => [message];
}