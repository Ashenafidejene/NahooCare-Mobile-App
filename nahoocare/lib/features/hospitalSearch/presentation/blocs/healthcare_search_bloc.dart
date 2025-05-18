import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/healthcare_entity.dart';

import '../../domain/entities/search_param.dart';
import '../../domain/usecases/search_by_location.dart';
import '../../domain/usecases/search_by_name.dart';
import '../../domain/usecases/search_by_specialty.dart';
import '../../domain/usecases/search_healthcare.dart';
import 'healthcare_search_event.dart';
import 'healthcare_search_state.dart';

class HealthcareSearchBloc
    extends Bloc<HealthcareSearchEvent, HealthcareSearchState> {
  final SearchByNames searchByName;
  final SearchBySpecialtys searchBySpecialty;
  final SearchByLocations searchByLocation;
  final SearchHealthcare searchHealthcare;

  HealthcareSearchBloc({
    required this.searchByName,
    required this.searchBySpecialty,
    required this.searchByLocation,
    required this.searchHealthcare,
  }) : super(SearchInitial()) {
    on<HealthcareSearchEvent>((event, emit) async {
      if (event is SearchByName) {
        await _handleSearchByName(event, emit);
      } else if (event is SearchBySpecialty) {
        await _handleSearchBySpecialty(event, emit);
      } else if (event is SearchByLocation) {
        await _handleSearchByLocation(event, emit);
      } else if (event is SearchWithAllFilters) {
        await _handleSearchWithAllFilters(event, emit);
      }
    });
  }

  Future<void> _handleSearchByName(
    SearchByName event,
    Emitter<HealthcareSearchState> emit,
  ) async {
    emit(SearchLoading());
    final result = await searchByName(event.name);
    _handleResult(result, emit);
  }

  Future<void> _handleSearchBySpecialty(
    SearchBySpecialty event,
    Emitter<HealthcareSearchState> emit,
  ) async {
    emit(SearchLoading());
    final result = await searchBySpecialty(event.specialties);
    _handleResult(result, emit);
  }

  Future<void> _handleSearchByLocation(
    SearchByLocation event,
    Emitter<HealthcareSearchState> emit,
  ) async {
    emit(SearchLoading());
    final result = await searchByLocation(
      SearchByLocationParams(
        latitude: event.latitude,
        longitude: event.longitude,
        maxDistanceKm: event.maxDistanceKm,
      ),
    );
    _handleResult(result, emit);
  }

  Future<void> _handleSearchWithAllFilters(
    SearchWithAllFilters event,
    Emitter<HealthcareSearchState> emit,
  ) async {
    emit(SearchLoading());
    final result = await searchHealthcare(
      SearchHealthcareParams(
        name: event.name,
        specialties: event.specialties,
        latitude: event.latitude,
        longitude: event.longitude,
        maxDistanceKm: event.maxDistanceKm,
      ),
    );
    _handleResult(result, emit);
  }

  void _handleResult(
    Either<Failure, List<HealthcareEntity>> result,
    Emitter<HealthcareSearchState> emit,
  ) {
    result.fold(
      (failure) => emit(SearchError(_mapFailureToMessage(failure))),
      (results) => emit(SearchLoaded(results)),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Server error';
      case NetworkFailure:
        return 'Network error';
      default:
        return 'Unexpected error';
    }
  }
}
