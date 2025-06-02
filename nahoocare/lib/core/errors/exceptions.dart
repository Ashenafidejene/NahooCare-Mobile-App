import 'dart:io';

/// Base exception class for all app exceptions
abstract class AppException implements Exception {
  final String message;
  final int statusCode;
  final String? code;

  AppException(this.message, this.statusCode, {this.code});

  @override
  String toString() =>
      'AppException: $message (status: $statusCode, code: $code)';
}

/// Server-related exceptions
class ServerException extends AppException {
  ServerException(super.message, super.statusCode, {super.code});
}

/// Network-related exceptions
class NetworkException extends AppException {
  NetworkException(String message) : super(message, 503, code: 'network_error');
}

/// Authentication-related exceptions
class AuthenticationException extends AppException {
  AuthenticationException(String message, {String? code})
    : super(message, 401, code: code);
}

/// Authorization-related exceptions
class AuthorizationException extends AppException {
  AuthorizationException(String message, {String? code})
    : super(message, 403, code: code);
}

/// Validation-related exceptions
class ValidationException extends AppException {
  final Map<String, List<String>> errors;

  ValidationException(this.errors, {String? code})
    : super('Validation failed', 422, code: code);

  @override
  String toString() => 'ValidationException: $message (errors: $errors)';
}

/// Not Found exceptions
class NotFoundException extends AppException {
  NotFoundException(String message, {String? code})
    : super(message, 404, code: code);
}

/// Conflict exceptions (e.g., duplicate entries)
class ConflictException extends AppException {
  ConflictException(String message, {String? code})
    : super(message, 409, code: code);
}

/// Rate limiting exceptions
class RateLimitException extends AppException {
  final Duration retryAfter;

  RateLimitException(String message, this.retryAfter, {String? code})
    : super(message, 429, code: code);

  @override
  String toString() =>
      'RateLimitException: $message (retry after: ${retryAfter.inSeconds}s)';
}

/// Cache-related exceptions
class CacheException extends AppException {
  CacheException(String message, {String? code})
    : super(message, 500, code: code ?? 'cache_error');
}

/// Database-related exceptions
class DatabaseException extends AppException {
  DatabaseException(String message, {String? code})
    : super(message, 500, code: code ?? 'database_error');
}

/// Feature-specific exceptions
class FeatureDisabledException extends AppException {
  FeatureDisabledException(String featureName, {String? code})
    : super('$featureName is currently disabled', 403, code: code);
}

/// Maintenance mode exception
class MaintenanceException extends AppException {
  final DateTime? estimatedEndTime;

  MaintenanceException(String message, {this.estimatedEndTime, String? code})
    : super(message, 503, code: code ?? 'maintenance_mode');

  @override
  String toString() =>
      'MaintenanceException: $message '
      '(estimated end: ${estimatedEndTime?.toIso8601String()})';
}
