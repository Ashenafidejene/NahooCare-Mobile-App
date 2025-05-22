import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/account_entity.dart';
import '../../domain/repository/account_repository.dart';
import '../datasources/account_remote_data_source.dart';
import '../models/account_model.dart';

class AccountRepositoryImpl implements AccountRepository {
  final AccountRemoteDataSource remoteDataSource;

  AccountRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, AccountEntity>> getAccount() async {
    try {
      final account = await remoteDataSource.getAccount();
      return Right(account.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString(), 500));
    }
  }

  @override
  Future<Either<Failure, void>> updateAccount(
    AccountEntity account,
    String password,
  ) async {
    try {
      final request = UpdateAccountRequest.fromEntity(
        entity: account,
        password: password,
      );
      await remoteDataSource.updateAccount(request);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString(), 500));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAccount() async {
    try {
      await remoteDataSource.deleteAccount();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString(), 500));
    }
  }
}
