import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';

import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/search_response.dart';
import '../../domain/usecase/get_current_location.dart';
import '../../domain/usecase/search_nearby_centers.dart';
part 'symptom_search_event.dart';
part 'symptom_search_state.dart';

class SymptomSearchBloc extends Bloc<SymptomSearchEvent, SymptomSearchState> {
  final SearchNearbyCenters searchNearbyCenters;
  final GetCurrentLocation getCurrentLocation;

  SymptomSearchBloc({
    required this.searchNearbyCenters,
    required this.getCurrentLocation,
  }) : super(SymptomSearchInitial()) {
    on<PerformSearch>(_onPerformSearch);
    on<GetUserLocation>(_onGetUserLocation);
  }

  Future<void> _onPerformSearch(
    PerformSearch event,
    Emitter<SymptomSearchState> emit,
  ) async {
    emit(SearchLoading());
    final result = await searchNearbyCenters(
      SearchParams(
        symptoms: event.symptoms,
        latitude: event.latitude,
        longitude: event.longitude,
        maxDistanceKm: event.maxDistanceKm,
      ),
    );

    result.fold(
      (failure) {
        if (failure.message.contains('401')) {
          emit(Unauthenticated('Please login to search for centers'));
        } else {
          emit(SearchError(failure.message));
        }
      },
      (response) {
        emit(SearchLoaded(response));
      },
    );
  }

  Future<void> _onGetUserLocation(
    GetUserLocation event,
    Emitter<SymptomSearchState> emit,
  ) async {
    emit(LocationLoading());
    final result = await getCurrentLocation(NoParams());

    result.fold(
      (failure) {
        emit(LocationError(failure.message));
      },
      (latLng) {
        emit(LocationLoaded(latLng));
      },
    );
  }
}
