import 'package:equatable/equatable.dart';

abstract class HealthcareSearchEvent extends Equatable {
  const HealthcareSearchEvent();

  @override
  List<Object> get props => [];
}

class SearchByName extends HealthcareSearchEvent {
  final String name;

  const SearchByName(this.name);

  @override
  List<Object> get props => [name];
}

class SearchBySpecialty extends HealthcareSearchEvent {
  final List<String> specialties;

  const SearchBySpecialty(this.specialties);

  @override
  List<Object> get props => [specialties];
}

class SearchByLocation extends HealthcareSearchEvent {
  final double latitude;
  final double longitude;
  final int maxDistanceKm;

  const SearchByLocation({
    required this.latitude,
    required this.longitude,
    this.maxDistanceKm = 10,
  });

  @override
  List<Object> get props => [latitude, longitude, maxDistanceKm];
}

class SearchWithAllFilters extends HealthcareSearchEvent {
  final String? name;
  final List<String>? specialties;
  final double? latitude;
  final double? longitude;
  final int maxDistanceKm;

  const SearchWithAllFilters({
    this.name,
    this.specialties,
    this.latitude,
    this.longitude,
    this.maxDistanceKm = 10,
  });

  @override
  List<Object> get props => [
    if (name != null) name!,
    if (specialties != null) specialties!,
    if (latitude != null) latitude!,
    if (longitude != null) longitude!,
    maxDistanceKm,
  ];
}
