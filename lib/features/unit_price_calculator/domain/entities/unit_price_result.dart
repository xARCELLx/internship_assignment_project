import 'package:equatable/equatable.dart';

class UnitPriceItem extends Equatable {
  final String name;
  final double quantity;
  final double totalPrice;
  final double unitPrice;

  const UnitPriceItem({
    required this.name,
    required this.quantity,
    required this.totalPrice,
    required this.unitPrice,
  });

  @override
  List<Object?> get props => [name, quantity, totalPrice, unitPrice];
}

class UnitPriceResult extends Equatable {
  final List<UnitPriceItem> items;
  final double totalAmount;

  const UnitPriceResult({
    required this.items,
    required this.totalAmount,
  });

  @override
  List<Object?> get props => [items, totalAmount];
}