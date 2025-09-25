import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/cash_result.dart';

abstract class CashRepository {
  Future<Either<Failure, CashResult>> calculateCash(Map<int, int> quantities);
}