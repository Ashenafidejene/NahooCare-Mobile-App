import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../repositories/healthcare_repository.dart';

class SubmitRating {
  final HealthcareRepository repository;

  SubmitRating(this.repository);

  Future<Either<Failure, Unit>> execute({
    required String centerId,
    required String userId,
    required int ratingValue,
    required String comment,
  }) async {
    if (centerId.isEmpty) {
      return Left(ServerFailure('Center ID cannot be empty', 400));
    }
    if (userId.isEmpty) {
      return Left(ServerFailure('User ID cannot be empty', 400));
    }
    if (ratingValue < 1 || ratingValue > 5) {
      return Left(ServerFailure('Rating must be between 1 and 5', 400));
    }

    return await repository.submitRating(
      centerId: centerId,
      ratingValue: ratingValue,
      comment: comment,
    );
  }
}
