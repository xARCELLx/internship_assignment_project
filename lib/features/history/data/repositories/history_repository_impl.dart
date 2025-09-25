import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../repositories/history_repository.dart';
import '../datasources/history_database.dart';
import 'dart:convert';

class HistoryRepositoryImpl implements HistoryRepository {
  final HistoryDatabase _database;

  HistoryRepositoryImpl() : _database = HistoryDatabase.instance;

  @override
  Future<Either<Failure, void>> saveHistory(String type, Map<String, dynamic> data, double total) async {
    try {
      final timestamp = DateTime.now().toIso8601String();
      final jsonData = jsonEncode(data);
      await _database.saveHistory(type, jsonData, total, timestamp);
      return const Right(null);
    } catch (e) {
      return Left(CalculationFailure('Failed to save history: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getAllHistory() async {
    try {
      final histories = await _database.getAllHistory();
      return Right(histories);
    } catch (e) {
      return Left(CalculationFailure('Failed to load history: ${e.toString()}'));
    }
  }
}