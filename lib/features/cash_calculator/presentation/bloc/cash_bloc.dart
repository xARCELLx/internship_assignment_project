import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_calculator_app/features/cash_calculator/domain/usecases/calculate_cash_use_case.dart';
import 'cash_event.dart';
import 'cash_state.dart';
import 'package:multi_calculator_app/features/cash_calculator/domain/entities/cash_result.dart';

class CashBloc extends Bloc<CashEvent, CashState> {
  final CalculateCashUseCase calculateCashUseCase;

  CashResult? currentResult; // To save current result for history

  CashBloc(this.calculateCashUseCase) : super(CashInitial()) {
    on<CalculateCashEvent>((event, emit) async {
      emit(CashCalculating());
      final result = await calculateCashUseCase(event.quantities);
      emit(result.fold(
            (failure) => CashError(failure.message),
            (success) {
          currentResult = success;
          return CashCalculated(success);
        },
      ));
    });

    on<SaveCashHistoryEvent>((event, emit) async {
      if (currentResult != null) {
        // Save already handled in use case, but emit success if needed
        emit(CashCalculated(currentResult!));
      } else {
        emit(CashError('No calculation to save'));
      }
    });
  }
}