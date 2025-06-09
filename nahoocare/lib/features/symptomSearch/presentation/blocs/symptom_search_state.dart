part of 'symptom_search_bloc.dart';

abstract class SymptomSearchState extends Equatable {
  const SymptomSearchState();

  @override
  List<Object> get props => [];
}

class SymptomSearchInitial extends SymptomSearchState {}

class LocationLoading extends SymptomSearchState {}

class LocationLoaded extends SymptomSearchState {
  final LatLng position;

  const LocationLoaded(this.position);

  @override
  List<Object> get props => [position];
}

class SearchLoading extends SymptomSearchState {}

class SearchLoaded extends SymptomSearchState {
  final SearchResponse response;

  const SearchLoaded(this.response);

  @override
  List<Object> get props => [response];
}

class SearchError extends SymptomSearchState {
  final String message;

  const SearchError(this.message);

  @override
  List<Object> get props => [message];
}

class LocationError extends SymptomSearchState {
  final String message;

  const LocationError(this.message);

  @override
  List<Object> get props => [message];
}

class Unauthenticated extends SymptomSearchState {
  final String message;

  const Unauthenticated(this.message);

  @override
  List<Object> get props => [message];
}
