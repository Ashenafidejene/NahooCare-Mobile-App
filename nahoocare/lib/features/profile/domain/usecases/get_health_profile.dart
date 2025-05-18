import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/health_profile.dart';
import '../repositories/health_profile_repository.dart';

class GetHealthProfile implements UseCase<HealthProfile, NoParams> {
  final HealthProfileRepository repository;

  GetHealthProfile(this.repository);

  @override
  Future<Either<Failure, HealthProfile>> call(NoParams params) async {
    try {
      final result = await repository.getHealthProfile();
      return result.fold(
        (failure) => Left(failure),
        (profile) => Right(profile),
      );
    } catch (e) {
      return Left(ServerFailure(e.toString(), 500));
    }
  }
}
