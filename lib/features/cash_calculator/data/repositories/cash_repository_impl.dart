import 'package:dartz/dartz.dart';
import 'package:multi_calculator_app/core/error/failure.dart';
import 'package:multi_calculator_app/features/cash_calculator/domain/entities/cash_result.dart';
import 'package:multi_calculator_app/features/cash_calculator/domain/repositories/cash_repository.dart';
import 'package:multi_calculator_app/features/history/data/repositories/history_repository.dart';
import 'dart:convert';

class CashRepositoryImpl implements CashRepository {
  final HistoryRepository _historyRepository;

  CashRepositoryImpl(this._historyRepository);

  @override
  Future<Either<Failure, CashResult>> calculateCash(
      Map<int, int> quantities) async {
    try {
      if (quantities.values.any((qty) => qty < 0)) {
        return Left(CalculationFailure('Quantities cannot be negative'));
      }

      // Define denominations (notes and coins)
      const notes = [2000, 500, 200, 100, 50, 20, 10];
      const coins = [20, 10, 5, 2, 1];

      double totalNotes = 0;
      double totalCoins = 0;

      // Calculate totals
      for (var denom in notes) {
        totalNotes += (denom * (quantities[denom] ?? 0));
      }
      for (var denom in coins) {
        totalCoins += (denom * (quantities[denom] ?? 0));
      }
      final grandTotal = totalNotes + totalCoins;

      final result = CashResult(
        denominations: Map.from(quantities),
        totalNotes: totalNotes,
        totalCoins: totalCoins,
        grandTotal: grandTotal,
      );

      // Convert quantities to Map<String, dynamic> for history
      final historyData = <String, dynamic>{};
      quantities.forEach((denom, qty) {
        historyData[denom.toString()] = qty;
      });

      // Save to history (optional trigger)
      await _historyRepository.saveHistory('cash', historyData, grandTotal);

      return Right(result);
    } catch (e) {
      return Left(CalculationFailure('Calculation failed: ${e.toString()}'));
    }
  }
}