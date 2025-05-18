part of 'symptom_search_bloc.dart';

abstract class SymptomSearchEvent extends Equatable {
  const SymptomSearchEvent();

  @override
  List<Object> get props => [];
}

class PerformSearch extends SymptomSearchEvent {
  final String symptoms;
  final double latitude;
  final double longitude;
  final double maxDistanceKm;

  const PerformSearch({
    required this.symptoms,
    required this.latitude,
    required this.longitude,
    this.maxDistanceKm = 10,
  });

  @override
  List<Object> get props => [symptoms, latitude, longitude, maxDistanceKm];
}

class GetUserLocation extends SymptomSearchEvent {}
