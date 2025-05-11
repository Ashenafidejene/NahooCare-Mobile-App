import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/auth_repository.dart';

class GetSecretQuestionUseCase implements UseCase<String, String> {
  final AuthRepository repository;

  GetSecretQuestionUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(String phoneNumber) async {
    return await repository.getSecretQuestion(phoneNumber);
  }
}
