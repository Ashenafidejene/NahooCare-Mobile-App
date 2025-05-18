import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart' show Failure;
import '../../domain/entities/health_profile.dart';
import '../../domain/repositories/health_profile_repository.dart';

import '../datasource/health_profile_remote_data_source.dart';
import '../models/health_profile_model.dart';

class HealthProfileRepositoryImpl implements HealthProfileRepository {
  final HealthProfileRemoteDataSource remoteDataSource;

  HealthProfileRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, HealthProfile>> getHealthProfile() async {
    final result = await remoteDataSource.getHealthProfile();
    return result.fold(
      (failure) => Left(failure),
      (model) => Right(model.toEntity()),
    );
  }

  @override
  Future<Either<Failure, HealthProfile>> createHealthProfile(
    HealthProfile profile,
  ) async {
    final result = await remoteDataSource.createHealthProfile(
      HealthProfileModel.fromEntity(profile),
    );
    return result.fold(
      (failure) => Left(failure),
      (model) => Right(model.toEntity()),
    );
  }

  @override
  Future<Either<Failure, HealthProfile>> updateHealthProfile(
    HealthProfile profile,
  ) async {
    final result = await remoteDataSource.updateHealthProfile(
      HealthProfileModel.fromEntity(profile),
    );
    return result.fold(
      (failure) => Left(failure),
      (model) => Right(model.toEntity()),
    );
  }

  @override
  Future<Either<Failure, void>> deleteHealthProfile() async {
    return await remoteDataSource.deleteHealthProfile();
  }
}
