import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/account_entity.dart';
import '../repository/account_repository.dart';

class GetAccountUseCase implements UseCase<AccountEntity, NoParams> {
  final AccountRepository repository;

  GetAccountUseCase(this.repository);

  @override
  Future<Either<Failure, AccountEntity>> call(NoParams params) async {
    return await repository.getAccount();
  }
}
