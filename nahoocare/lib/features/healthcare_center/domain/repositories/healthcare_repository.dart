// lib/features/healthcare_center/domain/repositories/healthcare_repository.dart
import 'package:dartz/dartz.dart';
import 'package:nahoocare/core/errors/failures.dart';
import '../entities/healthcare_center.dart';
import '../entities/rating.dart';

abstract class HealthcareRepository {
  Future<Either<Failure, HealthcareCenter>> getHealthcareCenterDetails(
    String centerId,
  );
  Future<Either<Failure, List<Rating>>> getCenterRatings(String centerId);
  Future<Either<Failure, Unit>> submitRating({
    required String centerId,
    required int ratingValue,
    required String comment,
  });
  Future<Either<Failure, double>> getAverageRating(String centerId);
}
