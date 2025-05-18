import 'package:dartz/dartz.dart';


import '../../../../core/errors/failures.dart';
import '../../../../core/usecase/usecase.dart' show NoParams, UseCase;
import '../repositories/health_profile_repository.dart';

class DeleteHealthProfile implements UseCase<void, NoParams> {
  final HealthProfileRepository repository;

  DeleteHealthProfile(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    try {
      final result = await repository.deleteHealthProfile();
      return result.fold(
        (failure) => Left(failure),
        (_) => const Right(null),
      );
    } catch (e) {
      return Left(ServerFailure(e.toString(), 500));
    }
  }
}