import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/cash_result.dart';
import '../repositories/cash_repository.dart';

class CalculateCashUseCase implements UseCase<CashResult, Map<int, int>> {
  final CashRepository repository;

  CalculateCashUseCase(this.repository);

  @override
  Future<Either<Failure, CashResult>> call(Map<int, int> params) async {
    if (params.values.any((qty) => qty < 0)) {
      return Left(CalculationFailure('Quantities cannot be negative'));
    }
    return await repository.calculateCash(params);
  }
}