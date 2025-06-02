import 'package:equatable/equatable.dart';

/// Base failure class for all app failures
abstract class Failure extends Equatable {
  final String message;
  final int statusCode;
  final String? code;

  const Failure(this.message, this.statusCode, {this.code});

  @override
  List<Object?> get props => [message, statusCode, code];

  @override
  String toString() => 'Failure: $message (status: $statusCode, code: $code)';
}

/// Server-related failures
class ServerFailure extends Failure {
  const ServerFailure(super.message, super.statusCode, {super.code});
}

/// Network-related failures
class NetworkFailure extends Failure {
  const NetworkFailure(String message)
    : super(message, 503, code: 'network_error');
}

/// Authentication-related failures
class AuthenticationFailure extends Failure {
  const AuthenticationFailure(String message, {String? code})
    : super(message, 401, code: code);
}

/// Authorization-related failures
class AuthorizationFailure extends Failure {
  const AuthorizationFailure(String message, {String? code})
    : super(message, 403, code: code);
}

/// Validation-related failures
class ValidationFailure extends Failure {
  final Map<String, List<String>> errors;

  const ValidationFailure(this.errors, {String? code})
    : super('Validation failed', 422, code: code);

  @override
  List<Object?> get props => [errors, ...super.props];

  @override
  String toString() => 'ValidationFailure: $message (errors: $errors)';
}

/// Not Found failures
class NotFoundFailure extends Failure {
  const NotFoundFailure(String message, {String? code})
    : super(message, 404, code: code);
}

/// Conflict failures (e.g., duplicate entries)
class ConflictFailure extends Failure {
  const ConflictFailure(String message, {String? code})
    : super(message, 409, code: code);
}

/// Rate limiting failures
class RateLimitFailure extends Failure {
  final Duration retryAfter;

  const RateLimitFailure(String message, this.retryAfter, {String? code})
    : super(message, 429, code: code);

  @override
  List<Object?> get props => [retryAfter, ...super.props];

  @override
  String toString() =>
      'RateLimitFailure: $message (retry after: ${retryAfter.inSeconds}s)';
}

/// Cache-related failures
class CacheFailure extends Failure {
  const CacheFailure(String message, {String? code})
    : super(message, 500, code: code ?? 'cache_error');
}

/// Database-related failures
class DatabaseFailure extends Failure {
  const DatabaseFailure(String message, {String? code})
    : super(message, 500, code: code ?? 'database_error');
}

/// Feature-specific failures
class FeatureDisabledFailure extends Failure {
  const FeatureDisabledFailure(String featureName, {String? code})
    : super('$featureName is currently disabled', 403, code: code);
}

/// Maintenance mode failure
class MaintenanceFailure extends Failure {
  final DateTime? estimatedEndTime;

  const MaintenanceFailure(
    String message, {
    this.estimatedEndTime,
    String? code,
  }) : super(message, 503, code: code ?? 'maintenance_mode');

  @override
  List<Object?> get props => [estimatedEndTime, ...super.props];

  @override
  String toString() =>
      'MaintenanceFailure: $message '
      '(estimated end: ${estimatedEndTime?.toIso8601String()})';
}

/// Unexpected failures
class UnexpectedFailure extends Failure {
  final dynamic error;
  final StackTrace? stackTrace;

  const UnexpectedFailure(this.error, {this.stackTrace, String? code})
    : super('An unexpected error occurred', 500, code: code ?? 'unexpected');

  @override
  List<Object?> get props => [error, stackTrace, ...super.props];

  @override
  String toString() => 'UnexpectedFailure: $message (error: $error)';
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure(String message, {String? code})
    : super(message, 401, code: code);
}

class InvalidInputFailure extends Failure {
  const InvalidInputFailure(String message, {String? code})
    : super(message, 400, code: code);
}

class UnknownFailure extends Failure {
  const UnknownFailure({String? message, int statusCode = 500})
    : super(message ?? 'Unknown error occurred', statusCode);
}
