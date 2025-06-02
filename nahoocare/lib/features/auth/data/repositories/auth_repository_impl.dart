import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/auth_entity.dart';
import '../../domain/entities/register_entity.dart';
import '../../domain/entities/reset_password_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import 'package:easy_localization/easy_localization.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/auth_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, AuthEntity>> login(
    String phoneNumber,
    String password,
  ) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure('network.no_connection'.tr()));
    }

    try {
      final response = await remoteDataSource.login(phoneNumber, password);
      final authModel = AuthModel.fromJson(response);
      await remoteDataSource.cacheToken(authModel.token);
      return Right(authModel.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode, code: e.code));
    } on AuthenticationException catch (e) {
      return Left(AuthenticationFailure(e.message, code: e.code));
    } on CacheException {
      return Left(CacheFailure('cache.cache_failed'.tr()));
    } catch (e) {
      return Left(UnexpectedFailure(e));
    }
  }

  @override
  Future<Either<Failure, String>> register(
    RegisterEntity registerEntity,
  ) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure('network.no_connection'.tr()));
    }
    try {
      final response = await remoteDataSource.register(
        fullName: registerEntity.fullName,
        phoneNumber: registerEntity.phoneNumber,
        password: registerEntity.password,
        secretQuestion: registerEntity.secretQuestion,
        secretAnswer: registerEntity.secretAnswer,
        photoUrl: registerEntity.photoUrl, // Add this
        gender: registerEntity.gender,
        dataOfBirth: registerEntity.dataOfBirth, // Add this
      );
      return Right(response['message']);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode, code: e.code));
    } on ConflictException catch (e) {
      return Left(ConflictFailure(e.message, code: e.code));
    } catch (e) {
      return Left(UnexpectedFailure(e));
    }
  }

  @override
  Future<Either<Failure, String>> getSecretQuestion(String phoneNumber) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure('network.no_connection'.tr()));
    }

    try {
      final question = await remoteDataSource.getSecretQuestion(phoneNumber);
      return Right(question);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode, code: e.code));
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(e.message, code: e.code));
    } catch (e) {
      return Left(UnexpectedFailure(e));
    }
  }

  @override
  Future<Either<Failure, String>> resetPassword(
    ResetPasswordEntity resetPasswordEntity,
  ) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure('network.no_connection'.tr()));
    }

    try {
      final response = await remoteDataSource.resetPassword(
        phoneNumber: resetPasswordEntity.phoneNumber,
        secretAnswer: resetPasswordEntity.secretAnswer,
        newPassword: resetPasswordEntity.newPassword,
      );
      return Right(response['message']);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode, code: e.code));
    } on AuthenticationException catch (e) {
      return Left(AuthenticationFailure(e.message, code: e.code));
    } catch (e) {
      return Left(UnexpectedFailure(e));
    }
  }

  @override
  Future<Either<Failure, bool>> isAuthenticated() async {
    try {
      final token = await remoteDataSource.getCachedToken();
      return Right(token != null);
    } on CacheException {
      return Left(CacheFailure('cache.get_failed'.tr()));
    } catch (e) {
      return Left(UnexpectedFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> cacheToken(String token) async {
    try {
      await remoteDataSource.cacheToken(token);
      return const Right(null);
    } on CacheException {
      return Left(CacheFailure('cache.cache_failed'.tr()));
    } catch (e) {
      return Left(UnexpectedFailure(e));
    }
  }

  @override
  Future<Either<Failure, String?>> getCachedToken() async {
    try {
      final token = await remoteDataSource.getCachedToken();
      return Right(token);
    } on CacheException {
      return Left(CacheFailure('cache.get_failed'.tr()));
    } catch (e) {
      return Left(UnexpectedFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await remoteDataSource.clearToken();
      return const Right(null);
    } on CacheException {
      return Left(CacheFailure('cache.clear_failed'.tr()));
    } catch (e) {
      return Left(UnexpectedFailure(e));
    }
  }
}

extension on AuthModel {
  AuthEntity toEntity() {
    return AuthEntity(token: token, tokenType: tokenType);
  }
}
