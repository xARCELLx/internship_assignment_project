import 'package:dartz/dartz.dart';
import 'package:multi_calculator_app/core/error/failure.dart';
import 'package:multi_calculator_app/features/unit_price_calculator/domain/entities/unit_price_result.dart';
import 'package:multi_calculator_app/features/unit_price_calculator/domain/repositories/unit_price_repository.dart';
import 'package:multi_calculator_app/features/history/data/repositories/history_repository.dart';
import 'dart:convert';

class UnitPriceRepositoryImpl implements UnitPriceRepository {
  final HistoryRepository _historyRepository;

  UnitPriceRepositoryImpl(this._historyRepository);

  @override
  Future<Either<Failure, UnitPriceResult>> calculateUnitPrice(List<Map<String, dynamic>> items) async {
    try {
      if (items.isEmpty || items.any((item) => item['quantity'] <= 0 || item['totalPrice'] <= 0)) {
        return Left(CalculationFailure('Quantity and price must be positive numbers'));
      }

      double totalAmount = 0;
      final calculatedItems = <UnitPriceItem>[];

      for (var item in items) {
        final name = item['name'] as String;
        final quantity = item['quantity'] as double;
        final totalPrice = item['totalPrice'] as double;
        final unitPrice = totalPrice / quantity;

        calculatedItems.add(UnitPriceItem(
          name: name,
          quantity: quantity,
          totalPrice: totalPrice,
          unitPrice: unitPrice,
        ));
        totalAmount += totalPrice;
      }

      final result = UnitPriceResult(items: calculatedItems, totalAmount: totalAmount);

      // Prepare history data (list of items)
      final historyData = {'items': items};

      // Save to history
      await _historyRepository.saveHistory('unit_price', historyData, totalAmount);

      return Right(result);
    } catch (e) {
      return Left(CalculationFailure('Calculation failed: ${e.toString()}'));
    }
  }
}
