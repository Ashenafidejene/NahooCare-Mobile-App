import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/errors/failures.dart'
    show Failure, ServerFailure, ValidationFailure;
import '../../../../core/usecase/usecase.dart';
import '../entities/health_profile.dart';
import '../repositories/health_profile_repository.dart';

class UpdateHealthProfileParams extends Equatable {
  final HealthProfile profile;

  const UpdateHealthProfileParams({required this.profile});

  @override
  List<Object> get props => [profile];
}

class UpdateHealthProfile
    implements UseCase<HealthProfile, UpdateHealthProfileParams> {
  final HealthProfileRepository repository;

  UpdateHealthProfile(this.repository);

  @override
  Future<Either<Failure, HealthProfile>> call(
    UpdateHealthProfileParams params,
  ) async {
    try {
      // Validate input
      if (params.profile.bloodType.isEmpty) {
        return Left(
          ValidationFailure({
            'bloodType': ['blood type is required'.tr()],
          }),
        );
      }

      final result = await repository.updateHealthProfile(params.profile);
      return result.fold(
        (failure) => Left(failure),
        (profile) => Right(profile),
      );
    } catch (e) {
      return Left(ServerFailure(e.toString(), 500));
    }
  }
}
