import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/search_history_entity.dart';
import '../repositories/search_history_repository.dart';

class GetHistoryUseCase
    implements UseCase<List<SearchHistoryEntity>, NoParams> {
  final SearchHistoryRepository repository;

  GetHistoryUseCase(this.repository);

  @override
  Future<Either<Failure, List<SearchHistoryEntity>>> call(
    NoParams params,
  ) async {
    return await repository.getSearchHistory();
  }
}
