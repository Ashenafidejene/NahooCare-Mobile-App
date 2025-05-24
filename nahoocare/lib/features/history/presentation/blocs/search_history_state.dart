part of 'search_history_bloc.dart';

sealed class SearchHistoryState extends Equatable {
  const SearchHistoryState();

  @override
  List<Object> get props => [];
}

final class SearchHistoryInitial extends SearchHistoryState {}

final class SearchHistoryLoading extends SearchHistoryState {}

final class SearchHistoryLoaded extends SearchHistoryState {
  final List<SearchHistoryEntity> history;

  const SearchHistoryLoaded(this.history);

  @override
  List<Object> get props => [history];
}

final class SearchHistoryError extends SearchHistoryState {
  final String message;

  const SearchHistoryError(this.message);

  @override
  List<Object> get props => [message];
}

final class SearchHistoryDeleted extends SearchHistoryState {
  final String message;

  const SearchHistoryDeleted(this.message);

  @override
  List<Object> get props => [message];
}

final class AllSearchHistoryDeleted extends SearchHistoryState {}
