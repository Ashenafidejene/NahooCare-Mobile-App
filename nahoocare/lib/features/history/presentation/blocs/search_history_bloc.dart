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
        final serverFailure = failure as ServerFailure;
        switch (serverFailure.statusCode) {
          case 401:
            return 'session_expired_login_again';
          case 403:
            return 'forbidden_action';
          case 404:
            return 'history_not_found';
          case 500:
          case 502:
          case 503:
            return 'server_unavailable_try_later';
          default:
            return 'server_error_occurred';
        }
      case NetworkFailure:
        return 'network_connection_failed';
      case UnauthorizedFailure:
        return 'unauthorized_access';
      case CacheFailure:
        return 'local_storage_error';
      default:
        return 'unexpected_error_occurred';
    }
  }
}
