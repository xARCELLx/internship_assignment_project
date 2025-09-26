import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_calculator_app/features/history/data/repositories/history_repository.dart';
import 'history_event.dart';
import 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final HistoryRepository historyRepository;

  HistoryBloc(this.historyRepository) : super(HistoryInitial()) {
    on<FetchHistoryEvent>((event, emit) async {
      emit(HistoryLoading());
      final result = await historyRepository.getAllHistory();
      emit(result.fold(
            (failure) => HistoryError(failure.message),
            (success) => HistoryLoaded(success),
      ));
    });
  }
}