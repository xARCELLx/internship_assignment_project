import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/unit_price_result.dart';

abstract class UnitPriceRepository {
  Future<Either<Failure, UnitPriceResult>> calculateUnitPrice(List<Map<String, dynamic>> items);
}