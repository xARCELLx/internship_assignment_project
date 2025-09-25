import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';

abstract class HistoryRepository {
  Future<Either<Failure, void>> saveHistory(String type, Map<String, dynamic> data, double total);
  Future<Either<Failure, List<Map<String, dynamic>>>> getAllHistory();
}