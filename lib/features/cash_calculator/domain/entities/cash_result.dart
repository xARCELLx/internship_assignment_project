import 'package:equatable/equatable.dart';

class CashResult extends Equatable {
  final Map<int, int> denominations; // {denom: qty}
  final double totalNotes;
  final double totalCoins;
  final double grandTotal;

  const CashResult({
    required this.denominations,
    required this.totalNotes,
    required this.totalCoins,
    required this.grandTotal,
  });

  @override
  List<Object> get props => [denominations, totalNotes, totalCoins, grandTotal];
}