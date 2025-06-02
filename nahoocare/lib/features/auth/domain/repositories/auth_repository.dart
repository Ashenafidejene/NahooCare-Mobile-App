import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/auth_entity.dart';
import '../entities/register_entity.dart';
import '../entities/reset_password_entity.dart';

abstract class AuthRepository {
  // Login with phone number and password
  Future<Either<Failure, AuthEntity>> login(
    String phoneNumber,
    String password,
  );

  // Register new account
  Future<Either<Failure, String>> register(RegisterEntity registerEntity);

  // Get secret question for password reset
  Future<Either<Failure, String>> getSecretQuestion(String phoneNumber);

  // Reset password with secret answer
  Future<Either<Failure, String>> resetPassword(
    ResetPasswordEntity resetPasswordEntity,
  );

  // Check if user is authenticated
  Future<Either<Failure, bool>> isAuthenticated();

  // Cache authentication token
  Future<Either<Failure, void>> cacheToken(String token);

  // Get cached token
  Future<Either<Failure, String?>> getCachedToken();

  // Logout user
  Future<Either<Failure, void>> logout();
}
