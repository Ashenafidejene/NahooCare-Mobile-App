import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/search_history_repository.dart';

class DeleteSingleHistoryUseCase implements UseCase<void, String> {
  final SearchHistoryRepository repository;

  DeleteSingleHistoryUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(String searchId) async {
    return await repository.deleteSearchHistory(searchId);
  }
}
