import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_calculator_app/features/unit_price_calculator/domain/usecases/calculate_unit_price_use_case.dart';
import 'unit_price_event.dart';
import 'unit_price_state.dart';
import 'package:multi_calculator_app/features/unit_price_calculator/domain/entities/unit_price_result.dart';
class UnitPriceBloc extends Bloc<UnitPriceEvent, UnitPriceState> {
  final CalculateUnitPriceUseCase calculateUnitPriceUseCase;

  UnitPriceResult? currentResult; // Store for history

  UnitPriceBloc(this.calculateUnitPriceUseCase) : super(UnitPriceInitial()) {
    on<CalculateUnitPriceEvent>((event, emit) async {
      emit(UnitPriceCalculating());
      final result = await calculateUnitPriceUseCase(event.items);
      emit(result.fold(
            (failure) => UnitPriceError(failure.message),
            (success) {
          currentResult = success;
          return UnitPriceCalculated(success);
        },
      ));
    });

    on<SaveUnitPriceHistoryEvent>((event, emit) async {
      if (currentResult != null) {
        emit(UnitPriceCalculated(currentResult!)); // Re-emit to confirm save
      } else {
        emit(UnitPriceError('No calculation to save'));
      }
    });
  }
}