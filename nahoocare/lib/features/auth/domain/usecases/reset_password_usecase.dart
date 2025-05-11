import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/reset_password_entity.dart';
import '../repositories/auth_repository.dart';

class ResetPasswordUseCase implements UseCase<String, ResetPasswordEntity> {
  final AuthRepository repository;

  ResetPasswordUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(ResetPasswordEntity params) async {
    return await repository.resetPassword(params);
  }
}
