import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/register_entity.dart';
import '../repositories/auth_repository.dart';

class RegisterUseCase implements UseCase<String, RegisterEntity> {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(RegisterEntity params) async {
    return await repository.register(params);
  }
}
