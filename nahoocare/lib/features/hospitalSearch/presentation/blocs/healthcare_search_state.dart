part of 'healthcare_search_bloc.dart';

enum HealthcareStatus { initial, loading, success, failure }

class HealthcareState extends Equatable {
  final HealthcareStatus status;
  final List<HealthcareEntity> allCenters;
  final List<HealthcareEntity> filteredCenters;
  final List<String> allSpecialties;
  final List<String> selectedSpecialties;
  final String searchQuery;
  final bool sortByDistance;
  final String? errorMessage;

  const HealthcareState({
    this.status = HealthcareStatus.initial,
    this.allCenters = const [],
    this.filteredCenters = const [],
    this.allSpecialties = const [],
    this.selectedSpecialties = const [],
    this.searchQuery = '',
    this.sortByDistance = false,
    this.errorMessage,
  });

  bool get isInitial => status == HealthcareStatus.initial;
  bool get isLoading => status == HealthcareStatus.loading;
  bool get isSuccess => status == HealthcareStatus.success;
  bool get isFailure => status == HealthcareStatus.failure;

  HealthcareState copyWith({
    HealthcareStatus? status,
    List<HealthcareEntity>? allCenters,
    List<HealthcareEntity>? filteredCenters,
    List<String>? allSpecialties,
    List<String>? selectedSpecialties,
    String? searchQuery,
    bool? sortByDistance,
    String? errorMessage,
  }) {
    return HealthcareState(
      status: status ?? this.status,
      allCenters: allCenters ?? this.allCenters,
      filteredCenters: filteredCenters ?? this.filteredCenters,
      allSpecialties: allSpecialties ?? this.allSpecialties,
      selectedSpecialties: selectedSpecialties ?? this.selectedSpecialties,
      searchQuery: searchQuery ?? this.searchQuery,
      sortByDistance: sortByDistance ?? this.sortByDistance,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    allCenters,
    filteredCenters,
    allSpecialties,
    selectedSpecialties,
    searchQuery,
    sortByDistance,
    errorMessage,
  ];
}
