import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../symptomSearch/data/datasources/location_data_source.dart';
import '../../domain/entities/healthcare_entity.dart';
import '../../domain/usecases/filter_healthcare.dart';
import '../../domain/usecases/get_healthcare.dart';
import '../../domain/usecases/get_specialties.dart';
import '../../domain/usecases/sort_healthcare.dart';

part 'healthcare_search_event.dart';
part 'healthcare_search_state.dart';

class HealthcareBloc extends Bloc<HealthcareEvent, HealthcareState> {
  final GetAllHealthcareCenters getAllHealthcareCenters;
  final GetAllSpecialties getAllSpecialties;
  final FilterHealthcareCenter filterHealthcareCenters;
  final SortHealthcareCenter sortHealthcareCenters;
  final LocationDataSource locationService;

  HealthcareBloc({
    required this.getAllHealthcareCenters,
    required this.getAllSpecialties,
    required this.filterHealthcareCenters,
    required this.sortHealthcareCenters,
    required this.locationService,
  }) : super(const HealthcareState()) {
    on<LoadHealthcareCenters>(_onLoadHealthcareCenters);
    on<SearchHealthcareCenters>(_onSearchHealthcareCenters);
    on<FilterHealthcareCenters>(_onFilterHealthcareCenters);
    on<SortHealthcareCenters>(_onSortHealthcareCenters);
    on<ResetHealthcareFilters>(_onResetFilters);
  }

  Future<void> _onLoadHealthcareCenters(
    LoadHealthcareCenters event,
    Emitter<HealthcareState> emit,
  ) async {
    emit(state.copyWith(status: HealthcareStatus.loading));

    try {
      final centers = await getAllHealthcareCenters();
      final specialties = await getAllSpecialties();

      emit(
        state.copyWith(
          status: HealthcareStatus.success,
          allCenters: centers,
          filteredCenters: centers,
          allSpecialties: specialties,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: HealthcareStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onSearchHealthcareCenters(
    SearchHealthcareCenters event,
    Emitter<HealthcareState> emit,
  ) async {
    final filtered = filterHealthcareCenters(
      centers: state.allCenters,
      searchQuery: event.query,
      selectedSpecialties: state.selectedSpecialties,
    );

    emit(
      state.copyWith(
        filteredCenters: _applySort(filtered),
        searchQuery: event.query,
      ),
    );
  }

  Future<void> _onFilterHealthcareCenters(
    FilterHealthcareCenters event,
    Emitter<HealthcareState> emit,
  ) async {
    final filtered = filterHealthcareCenters(
      centers: state.allCenters,
      searchQuery: state.searchQuery,
      selectedSpecialties: event.specialties,
    );

    emit(
      state.copyWith(
        filteredCenters: _applySort(filtered),
        selectedSpecialties: event.specialties,
      ),
    );
  }

  Future<void> _onSortHealthcareCenters(
    SortHealthcareCenters event,
    Emitter<HealthcareState> emit,
  ) async {
    if (!event.sortByDistance) {
      // Reset to original order (filtered but not sorted)
      final filtered = filterHealthcareCenters(
        centers: state.allCenters,
        searchQuery: state.searchQuery,
        selectedSpecialties: state.selectedSpecialties,
      );

      emit(state.copyWith(filteredCenters: filtered, sortByDistance: false));
      return;
    }

    emit(state.copyWith(status: HealthcareStatus.loading));

    try {
      final userLocation = await locationService.getCurrentLocation();
      final sorted = sortHealthcareCenters(
        centers: state.filteredCenters,
        userLocation: userLocation,
      );

      emit(
        state.copyWith(
          status: HealthcareStatus.success,
          filteredCenters: sorted,
          sortByDistance: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: HealthcareStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onResetFilters(
    ResetHealthcareFilters event,
    Emitter<HealthcareState> emit,
  ) async {
    emit(
      state.copyWith(
        filteredCenters: _applySort(state.allCenters),
        selectedSpecialties: const [],
        searchQuery: '',
        sortByDistance: false,
      ),
    );
  }

  List<HealthcareEntity> _applySort(List<HealthcareEntity> centers) {
    if (!state.sortByDistance) return centers;

    // This is a simplified version - actual sorting would require location
    return centers; // Real implementation would sort here
  }
}
