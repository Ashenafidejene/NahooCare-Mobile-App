import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/healthcare_entity.dart';
import '../entities/search_param.dart';
import '../repository/healthcare_repository.dart';

class SearchByLocations
    implements UseCase<List<HealthcareEntity>, SearchByLocationParams> {
  final HealthcareRepositorys repository;

  SearchByLocations(this.repository);

  @override
  Future<Either<Failure, List<HealthcareEntity>>> call(
    SearchByLocationParams params,
  ) async {
    return await repository.searchHealthcare(
      latitude: params.latitude,
      longitude: params.longitude,
      maxDistanceKm: params.maxDistanceKm,
    );
  }
}
