import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/search_history_entity.dart';
import '../../domain/usecases/delete_all_history_usecase.dart';
import '../../domain/usecases/delete_single_history_usecase.dart';
import '../../domain/usecases/get_history_usecase.dart';

part 'search_history_event.dart';
part 'search_history_state.dart';

class SearchHistoryBloc extends Bloc<SearchHistoryEvent, SearchHistoryState> {
  final GetHistoryUseCase getHistory;
  final DeleteSingleHistoryUseCase deleteHistory;
  final DeleteAllHistoryUseCase deleteAllHistory;

  SearchHistoryBloc({
    required this.getHistory,
    required this.deleteHistory,
    required this.deleteAllHistory,
  }) : super(SearchHistoryInitial()) {
    on<LoadSearchHistory>(_onLoadSearchHistory);
    on<DeleteSearchHistory>(_onDeleteSearchHistory);
    on<DeleteAllSearchHistory>(_onDeleteAllSearchHistory);
  }

  Future<void> _onLoadSearchHistory(
    LoadSearchHistory event,
    Emitter<SearchHistoryState> emit,
  ) async {
    emit(SearchHistoryLoading());
    final Either<Failure, List<SearchHistoryEntity>> result = await getHistory(
      NoParams(),
    );

    result.fold(
      (failure) => emit(SearchHistoryError(_mapFailureToMessage(failure))),
      (history) => emit(SearchHistoryLoaded(history)),
    );
  }

  Future<void> _onDeleteSearchHistory(
    DeleteSearchHistory event,
    Emitter<SearchHistoryState> emit,
  ) async {
    final Either<Failure, void> result = await deleteHistory(event.searchId);

    result.fold(
      (failure) => emit(SearchHistoryError(_mapFailureToMessage(failure))),
      (_) {
        emit(SearchHistoryDeleted('History deleted successfully'));
        add(LoadSearchHistory()); // Refresh the list
      },
    );
  }

  Future<void> _onDeleteAllSearchHistory(
    DeleteAllSearchHistory event,
    Emitter<SearchHistoryState> emit,
  ) async {
    final Either<Failure, void> result = await deleteAllHistory(NoParams());

    result.fold(
      (failure) => emit(SearchHistoryError(_mapFailureToMessage(failure))),
      (_) => emit(AllSearchHistoryDeleted()),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Server error: ${failure.message}';
      case CacheFailure:
        return 'Local storage error: ${failure.message}';
      default:
        return 'Unexpected error: ${failure.message}';
    }
  }
}
