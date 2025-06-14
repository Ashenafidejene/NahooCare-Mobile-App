import 'package:dartz/dartz.dart';
import 'package:nahoocare/core/network/api_client.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/healthcare_center.dart';
import '../../domain/entities/rating.dart';
import '../models/healthcare_center_model.dart';
import '../models/rating_model.dart';
import 'package:easy_localization/easy_localization.dart';

abstract class HealthcareRemoteDataSource {
  Future<Either<Failure, HealthcareCenter>> getHealthcareCenterDetails(
    String centerId,
  );
  Future<Either<Failure, List<Rating>>> getCenterRatings(String centerId);
  Future<Either<Failure, Unit>> submitRating({
    required String centerId,
    required int ratingValue,
    required String comment,
  });
}

class HealthcareRemoteDataSourceImpl implements HealthcareRemoteDataSource {
  final ApiClient apiClient;

  HealthcareRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<Either<Failure, HealthcareCenter>> getHealthcareCenterDetails(
    String centerId,
  ) async {
    try {
      final response = await apiClient.get(
        '/api/healthcare/get_healthcare/user/$centerId',
        requiresAuth: true,
      );
      //  print("Raw response: ${response.length}");

      // Add type checking
      if (response is! Map<String, dynamic>) {
        throw FormatException('Invalid response format'.tr());
      }

      final center = HealthcareCenterModel.fromJson(response);
      // print("Mapped center: ${center.toString()}");
      return Right(center);
    } on FormatException catch (e) {
      return Left(ServerFailure('Invalid data format: ${e.message}'.tr(), 400));
    } on ApiException catch (e) {
      if (e.response?.statusCode == 404) {
        return Left(NotFoundFailure('Healthcare center not found'.tr()));

      }
      return Left(
        ServerFailure(
          e.response?.data['message'] ?? 'Failed to load center details'.tr(),
          e.statusCode,
        ),
      );
    } catch (e, stackTrace) {
      print("Error details: $e\n$stackTrace".tr());
      return Left(ServerFailure('Unexpected error occurred'.tr(), 500));
    }
  }

  @override
  Future<Either<Failure, List<Rating>>> getCenterRatings(
    String centerId,
  ) async {
    try {
      final response = await apiClient.get(
        '/api/rating/$centerId',
        requiresAuth: false,
      );
      print("Raw ratings response: ${response.toString()}".tr());

      // Handle both array and message responses
      if (response is Map && response.containsKey('message')) {
        if (response['message'] ==
            'No ratings found for this healthcare center'.tr()) {
          return const Right([]);
        }
        return Left(NotFoundFailure(response['message'.tr()]));
      }

      if (response is! List) {
        throw FormatException('Expected array but got ${response.runtimeType}'.tr());
      }

      final ratings =
          response.map((json) {
            try {
              return RatingModel.fromJson(json);
            } catch (e) {
              throw FormatException('Failed to parse rating: $e'.tr());
            }
          }).toList();

      return Right(ratings);
    } on FormatException catch (e) {
      return Left(ServerFailure('Invalid data format: ${e.message}.tr()', 400));
    } on ApiException catch (e) {
      if (e.response?.statusCode == 404) {
        return const Right([]);
      }
      return Left(
        ServerFailure(
          e.response?.data['message'] ?? 'Failed to load ratings'.tr(),
          e.statusCode,
        ),
      );
    } catch (e, stackTrace) {
      print("Error details: $e\n$stackTrace".tr());
      return Left(ServerFailure('Unexpected error occurred'.tr(), 500));
    }
  }

  @override
  Future<Either<Failure, Unit>> submitRating({
    required String centerId,
    required int ratingValue,
    required String comment,
  }) async {
    try {
      await apiClient.post('/api/rating/submit', {
        'center_id': centerId,
        'rating_value': ratingValue,
        'comment': comment,
      }, requiresAuth: true);

      return const Right(unit);
    } on ApiException catch (e) {
      if (e.response?.statusCode == 400) {
        return Left(
          ValidationFailure(
            e.response?.data['message'] ?? 'Invalid rating data'.tr(),
          ),
        );
      }
      return Left(
        ServerFailure(
          e.response?.data['message'] ?? 'Failed to submit rating'.tr(),
          e.statusCode,
        ),
      );
    } catch (e) {
      return Left(ServerFailure('Unexpected error occurred'.tr(), 500));
    }
  }
}
