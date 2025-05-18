import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/health_profile.dart';

abstract class HealthProfileRepository {
  Future<Either<Failure, HealthProfile>> getHealthProfile();
  Future<Either<Failure, HealthProfile>> createHealthProfile(HealthProfile profile);
  Future<Either<Failure, HealthProfile>> updateHealthProfile(HealthProfile profile);
  Future<Either<Failure, void>> deleteHealthProfile();
}