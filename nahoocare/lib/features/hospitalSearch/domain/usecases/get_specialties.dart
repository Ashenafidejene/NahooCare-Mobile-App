import '../repository/healthcare_repository.dart';

class GetAllSpecialties {
  final HealthcareRepositories repository;

  GetAllSpecialties(this.repository);

  Future<List<String>> call() async {
    return await repository.getAllSpecialties();
  }
}
