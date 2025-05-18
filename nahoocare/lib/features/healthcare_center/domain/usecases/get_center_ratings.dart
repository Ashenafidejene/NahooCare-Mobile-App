// lib/features/healthcare_center/domain/usecases/get_center_ratings.dart
import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/rating.dart';
import '../repositories/healthcare_repository.dart';

class GetCenterRatings {
  final HealthcareRepository repository;

  GetCenterRatings(this.repository);

  Future<Either<Failure, List<Rating>>> execute(String centerId) async {
    if (centerId.isEmpty) {
      return Left(ServerFailure('Center ID cannot be empty', 400));
    }
    return await repository.getCenterRatings(centerId);
  }
}
