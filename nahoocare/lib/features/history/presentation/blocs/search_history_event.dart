part of 'search_history_bloc.dart';

abstract class SearchHistoryEvent extends Equatable {
  const SearchHistoryEvent();

  @override
  List<Object> get props => [];
}

class LoadSearchHistory extends SearchHistoryEvent {}

class DeleteSearchHistory extends SearchHistoryEvent {
  final String searchId;

  const DeleteSearchHistory(this.searchId);

  @override
  List<Object> get props => [searchId];
}

class DeleteAllSearchHistory extends SearchHistoryEvent {}
