import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/healthcare_entity.dart';
import '../repository/healthcare_repository.dart';

class SearchByNames implements UseCase<List<HealthcareEntity>, String> {
  final HealthcareRepositorys repository;

  SearchByNames(this.repository);

  @override
  Future<Either<Failure, List<HealthcareEntity>>> call(String name) async {
    return await repository.searchHealthcare(name: name);
  }
}
