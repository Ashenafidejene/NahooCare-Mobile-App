import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/healthcare_entity.dart' show HealthcareEntity;
import '../repository/healthcare_repository.dart';

class SearchBySpecialtys
    implements UseCase<List<HealthcareEntity>, List<String>> {
  final HealthcareRepositorys repository;

  SearchBySpecialtys(this.repository);

  @override
  Future<Either<Failure, List<HealthcareEntity>>> call(
    List<String> specialties,
  ) async {
    return await repository.searchHealthcare(specialties: specialties);
  }
}
