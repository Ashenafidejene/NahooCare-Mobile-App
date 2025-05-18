import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/healthcare_entity.dart';
import '../repository/healthcare_repository.dart';

class SearchHealthcare
    implements UseCase<List<HealthcareEntity>, SearchHealthcareParams> {
  final HealthcareRepositorys repository;

  SearchHealthcare(this.repository);

  @override
  Future<Either<Failure, List<HealthcareEntity>>> call(
    SearchHealthcareParams params,
  ) async {
    return await repository.searchHealthcare(
      name: params.name,
      specialties: params.specialties,
      latitude: params.latitude,
      longitude: params.longitude,
      maxDistanceKm: params.maxDistanceKm,
    );
  }
}

class SearchHealthcareParams {
  final String? name;
  final List<String>? specialties;
  final double? latitude;
  final double? longitude;
  final int maxDistanceKm;

  SearchHealthcareParams({
    this.name,
    this.specialties,
    this.latitude,
    this.longitude,
    this.maxDistanceKm = 10,
  });

  // Add validation methods if needed
}
