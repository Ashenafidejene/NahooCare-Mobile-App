import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/healthcare_entity.dart';

import '../../domain/repository/healthcare_repository.dart';
import '../datasources/healthcare_remote_data_source.dart';

class HealthcareRepositoryImpls implements HealthcareRepositorys {
  final HealthcareRemoteDataSources remoteDataSource;

  HealthcareRepositoryImpls({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<HealthcareEntity>>> searchHealthcare({
    String? name,
    List<String>? specialties,
    double? latitude,
    double? longitude,
    int maxDistanceKm = 10,
  }) async {
    return await remoteDataSource.searchHealthcare(
      name: name,
      specialties: specialties,
      latitude: latitude,
      longitude: longitude,
      maxDistanceKm: maxDistanceKm,
    );
  }
}
