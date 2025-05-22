import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/first_aid_entity.dart';
import '../../domain/usecase/get_first_aid_guides.dart';

part 'first_aid_event.dart';
part 'first_aid_state.dart';

class FirstAidBloc extends Bloc<FirstAidEvent, FirstAidState> {
  final GetFirstAidGuides getFirstAidGuides;

  FirstAidBloc({required this.getFirstAidGuides}) : super(FirstAidInitial()) {
    on<LoadFirstAidGuides>(_onLoadFirstAidGuides);
    on<SearchFirstAid>(_onSearchFirstAid);
    on<FilterFirstAid>(_onFilterFirstAid);
  }

  Future<void> _onLoadFirstAidGuides(
    LoadFirstAidGuides event,
    Emitter<FirstAidState> emit,
  ) async {
    emit(const FirstAidLoading());

    final Either<Failure, List<FirstAidEntity>> result =
        await getFirstAidGuides();

    result.fold(
      (failure) => emit(FirstAidError(_mapFailureToMessage(failure))),
      (guides) =>
          emit(FirstAidLoaded(allGuides: guides, displayedGuides: guides)),
    );
  }

  void _onSearchFirstAid(SearchFirstAid event, Emitter<FirstAidState> emit) {
    if (state is! FirstAidLoaded) return;

    final currentState = state as FirstAidLoaded;
    final query = event.query.toLowerCase();

    if (query.isEmpty) {
      emit(currentState.copyWith(displayedGuides: currentState.allGuides));
      return;
    }

    final filtered =
        currentState.allGuides
            .where(
              (guide) => guide.emergencyTitle.toLowerCase().contains(query),
            )
            .toList();

    emit(currentState.copyWith(displayedGuides: filtered));
  }

  void _onFilterFirstAid(FilterFirstAid event, Emitter<FirstAidState> emit) {
    if (state is! FirstAidLoaded) return;

    final currentState = state as FirstAidLoaded;
    final category = event.category;

    if (category.isEmpty) {
      emit(currentState.copyWith(displayedGuides: currentState.allGuides));
      return;
    }

    final filtered =
        currentState.allGuides
            .where(
              (guide) => guide.category.toLowerCase() == category.toLowerCase(),
            )
            .toList();

    emit(currentState.copyWith(displayedGuides: filtered));
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Server error: ${failure.message}';
      case CacheFailure:
        return 'Local data error: ${failure.message}';
      case NetworkFailure:
        return 'Network error: ${failure.message}';
      default:
        return 'Unexpected error: ${failure.message}';
    }
  }
}
