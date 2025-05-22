import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/account_entity.dart';
import '../repository/account_repository.dart';

class UpdateAccountParams {
  final AccountEntity account;
  final String password;

  UpdateAccountParams({required this.account, required this.password});
}

class UpdateAccountUseCase implements UseCase<void, UpdateAccountParams> {
  final AccountRepository repository;

  UpdateAccountUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(UpdateAccountParams params) async {
    return await repository.updateAccount(params.account, params.password);
  }
}
