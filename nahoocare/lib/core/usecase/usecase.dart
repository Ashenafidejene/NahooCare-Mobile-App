import 'package:dartz/dartz.dart';
import '../errors/failures.dart';

/// Base UseCase interface that all use cases should implement
/// [Type] is the return type of the use case
/// [Params] is the parameters required by the use case
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

/// Class to handle use cases that don't require parameters
class NoParams {
  const NoParams();
}

/// Base StreamUseCase interface for use cases that return streams
abstract class StreamUseCase<Type, Params> {
  Stream<Either<Failure, Type>> call(Params params);
}

/// Base FutureUseCase interface for use cases that return futures
abstract class FutureUseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

/// Base SyncUseCase interface for use cases that execute synchronously
abstract class SyncUseCase<Type, Params> {
  Either<Failure, Type> call(Params params);
}

/// Extension for easier use case execution
extension UseCaseExtensions<Type, Params> on UseCase<Type, Params> {
  Future<Either<Failure, Type>> execute(Params params) => call(params);
}

/// Extension for stream use cases
extension StreamUseCaseExtensions<Type, Params> on StreamUseCase<Type, Params> {
  Stream<Either<Failure, Type>> execute(Params params) => call(params);
}

/// Extension for future use cases
extension FutureUseCaseExtensions<Type, Params> on FutureUseCase<Type, Params> {
  Future<Either<Failure, Type>> execute(Params params) => call(params);
}

/// Extension for sync use cases
extension SyncUseCaseExtensions<Type, Params> on SyncUseCase<Type, Params> {
  Either<Failure, Type> execute(Params params) => call(params);
}
