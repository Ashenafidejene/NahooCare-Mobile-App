import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/account_entity.dart';

abstract class AccountRepository {
  Future<Either<Failure, AccountEntity>> getAccount();
  Future<Either<Failure, void>> updateAccount(
    AccountEntity account,
    String password,
  );
  Future<Either<Failure, void>> deleteAccount();
}
