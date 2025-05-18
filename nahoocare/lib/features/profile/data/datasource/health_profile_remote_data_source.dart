import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entities/health_profile.dart';

import '../models/health_profile_model.dart';

abstract class HealthProfileRemoteDataSource {
  Future<Either<Failure, HealthProfileModel>> getHealthProfile();
  Future<Either<Failure, HealthProfileModel>> createHealthProfile(
    HealthProfileModel profile,
  );
  Future<Either<Failure, HealthProfileModel>> updateHealthProfile(
    HealthProfileModel profile,
  );
  Future<Either<Failure, void>> deleteHealthProfile();
}

class HealthProfileRemoteDataSourceImpl
    implements HealthProfileRemoteDataSource {
  final ApiClient apiClient;
  HealthProfileRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<Either<Failure, HealthProfileModel>> getHealthProfile() async {
    try {
      final response = await apiClient.get(
        '/api/healthprofile/',
        requiresAuth: true,
      );

      // Check if the response indicates no profile found
      if (response is Map &&
          response['message'] == 'No health profile found for this user') {
        return Left(NotFoundFailure('No health profile found'));
      }

      return Right(HealthProfileModel.fromJson(response));
    } on ApiException catch (e) {
      if (e.response?.statusCode == 404) {
        return Left(NotFoundFailure('No health profile found'));
      }
      return Left(
        ServerFailure(
          e.message ?? 'Server error',
          e.response?.statusCode ?? 500,
        ),
      );
    } catch (e) {
      return Left(ServerFailure(e.toString(), 500));
    }
  }

  @override
  Future<Either<Failure, HealthProfileModel>> createHealthProfile(
    HealthProfileModel profile,
  ) async {
    try {
      final response = await apiClient.post(
        '/api/healthprofile/create',
        profile.toJson(),
        requiresAuth: true,
      );
      return Right(HealthProfileModel.fromJson(response));
    } on ApiException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    } catch (e) {
      return Left(ServerFailure(e.toString(), 500));
    }
  }

  @override
  Future<Either<Failure, HealthProfileModel>> updateHealthProfile(
    HealthProfileModel profile,
  ) async {
    try {
      final response = await apiClient.put(
        '/api/healthprofile/',
        profile.toJson(),
        requiresAuth: true,
      );
      return Right(HealthProfileModel.fromJson(response));
    } on ApiException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    } catch (e) {
      return Left(ServerFailure(e.toString(), 500));
    }
  }

  @override
  Future<Either<Failure, void>> deleteHealthProfile() async {
    try {
      await apiClient.delete('/api/healthprofile/', requiresAuth: true);
      return const Right(null);
    } on ApiException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    } catch (e) {
      return Left(ServerFailure(e.toString(), 500));
    }
  }
}
