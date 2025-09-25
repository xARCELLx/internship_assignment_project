import 'package:get_it/get_it.dart';
import 'package:multi_calculator_app/features/cash_calculator/data/repositories/cash_repository_impl.dart';
import 'package:multi_calculator_app/features/cash_calculator/domain/repositories/cash_repository.dart';
import 'package:multi_calculator_app/features/cash_calculator/domain/usecases/calculate_cash_use_case.dart';
import 'package:multi_calculator_app/features/history/data/repositories/history_repository_impl.dart';
import 'package:multi_calculator_app/features/history/data/repositories/history_repository.dart';
import 'package:multi_calculator_app/features/unit_price_calculator/data/repositories/unit_price_repository_impl.dart';
import 'package:multi_calculator_app/features/unit_price_calculator/domain/repositories/unit_price_repository.dart';
import 'package:multi_calculator_app/features/unit_price_calculator/domain/usecases/calculate_unit_price_use_case.dart';
import 'package:multi_calculator_app/features/cash_calculator/presentation/bloc/cash_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Repositories
  sl.registerLazySingleton<HistoryRepository>(() => HistoryRepositoryImpl());
  sl.registerLazySingleton<CashRepository>(() => CashRepositoryImpl(sl()));
  sl.registerLazySingleton<UnitPriceRepository>(() => UnitPriceRepositoryImpl(sl()));

  // Use Cases
  sl.registerLazySingleton(() => CalculateCashUseCase(sl()));
  sl.registerLazySingleton(() => CalculateUnitPriceUseCase(sl()));
  sl.registerFactory(() => CashBloc(sl()));
}