import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/unit_price_result.dart';
import '../repositories/unit_price_repository.dart';

class CalculateUnitPriceUseCase implements UseCase<UnitPriceResult, List<Map<String, dynamic>>> {
  final UnitPriceRepository repository;

  CalculateUnitPriceUseCase(this.repository);

  @override
  Future<Either<Failure, UnitPriceResult>> call(List<Map<String, dynamic>> params) async {
    if (params.isEmpty || params.any((item) => item['quantity'] <= 0 || item['totalPrice'] <= 0)) {
      return Left(CalculationFailure('Quantity and price must be positive numbers'));
    }
    return await repository.calculateUnitPrice(params);
  }
}