// healthcare_search_event.dart
part of 'healthcare_search_bloc.dart';

abstract class HealthcareEvent extends Equatable {
  const HealthcareEvent();

  @override
  List<Object> get props => [];
}

class LoadHealthcareCenters extends HealthcareEvent {}

class SearchHealthcareCenters extends HealthcareEvent {
  final String query;

  const SearchHealthcareCenters(this.query);

  @override
  List<Object> get props => [query];
}

class FilterHealthcareCenters extends HealthcareEvent {
  final List<String> specialties;

  const FilterHealthcareCenters(this.specialties);

  @override
  List<Object> get props => [specialties];
}

class SortHealthcareCenters extends HealthcareEvent {
  final bool sortByDistance;

  const SortHealthcareCenters({required this.sortByDistance});

  @override
  List<Object> get props => [sortByDistance];
}

class ResetHealthcareFilters extends HealthcareEvent {}
