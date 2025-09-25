import 'package:equatable/equatable.dart';

abstract class CashEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class CalculateCashEvent extends CashEvent {
  final Map<int, int> quantities;

  CalculateCashEvent(this.quantities);

  @override
  List<Object> get props => [quantities];
}

class SaveCashHistoryEvent extends CashEvent {}