import 'package:equatable/equatable.dart';
import '../../domain/entities/healthcare_entity.dart';

abstract class HealthcareSearchState extends Equatable {
  const HealthcareSearchState();

  @override
  List<Object> get props => [];
}

class SearchInitial extends HealthcareSearchState {}

class SearchLoading extends HealthcareSearchState {}

class SearchLoaded extends HealthcareSearchState {
  final List<HealthcareEntity> results;

  const SearchLoaded(this.results);

  @override
  List<Object> get props => [results];
}

class SearchError extends HealthcareSearchState {
  final String message;

  const SearchError(this.message);

  @override
  List<Object> get props => [message];
}
