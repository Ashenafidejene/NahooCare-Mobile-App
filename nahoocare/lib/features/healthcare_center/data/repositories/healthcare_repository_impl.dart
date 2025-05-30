import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/repositories/healthcare_repository.dart';
import '../../domain/entities/healthcare_center.dart';
import '../../domain/entities/rating.dart';
import '../datasource/healthcare_remote_data_source.dart';

class HealthcareRepositoryImpl implements HealthcareRepository {
  final HealthcareRemoteDataSource remoteDataSource;

  HealthcareRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, HealthcareCenter>> getHealthcareCenterDetails(
    String centerId,
  ) async {
    return await remoteDataSource.getHealthcareCenterDetails(centerId);
  }

  @override
  Future<Either<Failure, List<Rating>>> getCenterRatings(
    String centerId,
  ) async {
    final value = await remoteDataSource.getCenterRatings(centerId);
    return value.fold(
      (failure) {
        print("Error fetching ratings: ${failure.message}");
        return Left(failure);
      },
      (ratings) {
        if (ratings.isNotEmpty) {
          print(ratings[0].comment);
        }
        return Right(ratings);
      },
    );
  }

  @override
  Future<Either<Failure, Unit>> submitRating({
    required String centerId,

    required int ratingValue,
    required String comment,
  }) async {
    return await remoteDataSource.submitRating(
      centerId: centerId,
      ratingValue: ratingValue,
      comment: comment,
    );
  }

  @override
  Future<Either<Failure, double>> getAverageRating(String centerId) async {
    final ratingsResult = await getCenterRatings(centerId);
    return ratingsResult.fold((failure) => Left(failure), (ratings) {
      if (ratings.isEmpty) return Right(0.0);
      final average =
          ratings.map((r) => r.ratingValue).reduce((a, b) => a + b) /
          ratings.length;
      return Right(average);
    });
  }
}
