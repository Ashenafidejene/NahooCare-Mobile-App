import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/health_profile.dart';
import '../repositories/health_profile_repository.dart';

class CreateHealthProfileParams extends Equatable {
  final HealthProfile profile;

  const CreateHealthProfileParams({required this.profile});

  @override
  List<Object> get props => [profile];
}

class CreateHealthProfile
    implements UseCase<HealthProfile, CreateHealthProfileParams> {
  final HealthProfileRepository repository;

  CreateHealthProfile(this.repository);

  @override
  Future<Either<Failure, HealthProfile>> call(
    CreateHealthProfileParams params,
  ) async {
    try {
      // Validate input
      if (params.profile.bloodType.isEmpty) {
        return Left(
          ValidationFailure({
            'bloodType': ['blood_type_required'.tr()],

          }),
        );
      }

      final result = await repository.createHealthProfile(params.profile);
      return result.fold(
        (failure) => Left(failure),
        (profile) => Right(profile),
      );
    } catch (e) {
      return Left(ServerFailure(e.toString(), 500));
    }
  }
}
