import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/healthcare_center.dart';
import '../repositories/healthcare_repository.dart';

class GetHealthcareCenterDetails {
  final HealthcareRepository repository;

  GetHealthcareCenterDetails(this.repository);

  Future<Either<Failure, HealthcareCenter>> execute(String centerId) async {
    if (centerId.isEmpty) {
      return Left(ServerFailure('Center ID cannot be empty', 400));
    }
    return await repository.getHealthcareCenterDetails(centerId);
  }
}
