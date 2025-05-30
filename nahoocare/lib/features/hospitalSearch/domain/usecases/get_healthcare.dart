import '../entities/healthcare_entity.dart';
import '../repository/healthcare_repository.dart';

class GetAllHealthcareCenters {
  final HealthcareRepositories repository;

  GetAllHealthcareCenters(this.repository);

  Future<List<HealthcareEntity>> call() async {
    return await repository.getAllHealthcareCenters();
  }
}
