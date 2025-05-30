import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/auth_repository.dart';

class CacheTokenUseCase implements UseCase<void, String> {
  final AuthRepository repository;

  CacheTokenUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(String token) async {
    return await repository.cacheToken(token);
  }
}
