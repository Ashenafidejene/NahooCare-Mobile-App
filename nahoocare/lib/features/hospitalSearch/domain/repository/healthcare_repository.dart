import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/healthcare_entity.dart';

abstract class HealthcareRepositorys {
  Future<Either<Failure, List<HealthcareEntity>>> searchHealthcare({
    String? name,
    List<String>? specialties,
    double? latitude,
    double? longitude,
    int maxDistanceKm = 10,
  });
}
