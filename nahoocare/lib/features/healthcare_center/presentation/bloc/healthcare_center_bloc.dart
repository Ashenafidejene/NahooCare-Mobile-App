// lib/features/healthcare_center/presentation/bloc/healthcare_center_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/healthcare_center.dart';
import '../../domain/entities/rating.dart';
import '../../domain/usecases/get_healthcare_center_details.dart';
import '../../domain/usecases/get_center_ratings.dart';
import '../../domain/usecases/submit_rating.dart';

part 'healthcare_center_event.dart';
part 'healthcare_center_state.dart';

class HealthcareCenterBloc
    extends Bloc<HealthcareCenterEvent, HealthcareCenterState> {
  final GetHealthcareCenterDetails getHealthcareCenterDetails;
  final GetCenterRatings getCenterRatings;
  final SubmitRating submitRating;

  HealthcareCenterBloc({
    required this.getHealthcareCenterDetails,
    required this.getCenterRatings,
    required this.submitRating,
  }) : super(HealthcareCenterInitial()) {
    on<LoadHealthcareCenterDetails>(_onLoadHealthcareCenterDetails);
    on<LoadCenterRatings>(_onLoadCenterRatings);
    on<SubmitCenterRating>(_onSubmitCenterRating);
  }

  Future<void> _onLoadHealthcareCenterDetails(
    LoadHealthcareCenterDetails event,
    Emitter<HealthcareCenterState> emit,
  ) async {
    emit(HealthcareCenterLoading());

    final result = await getHealthcareCenterDetails.execute(event.centerId);

    result.fold(
      (failure) => emit(HealthcareCenterError(_mapFailureToMessage(failure))),
      (center) => emit(HealthcareCenterLoaded(center: center)),
    );
  }

  Future<void> _onLoadCenterRatings(
    LoadCenterRatings event,
    Emitter<HealthcareCenterState> emit,
  ) async {
    emit(HealthcareCenterLoading());

    final result = await getCenterRatings.execute(event.centerId);

    result.fold(
      (failure) {
        // Special case for "no ratings found" message
        if (failure is NotFoundFailure &&
            failure.message.contains('No ratings found')) {
          if (state is HealthcareCenterLoaded) {
            final currentState = state as HealthcareCenterLoaded;
            emit(currentState.copyWith(ratings: []));
          } else {
            emit(
              HealthcareCenterLoaded(
                center:
                    HealthcareCenter.empty(), // You'll need to add empty constructor
                ratings: [],
              ),
            );
          }
        } else {
          emit(HealthcareCenterError(_mapFailureToMessage(failure)));
        }
      },
      (ratings) {
        if (state is HealthcareCenterLoaded) {
          final currentState = state as HealthcareCenterLoaded;
          emit(currentState.copyWith(ratings: ratings));
        } else {
          emit(HealthcareCenterError('Center details not loaded'));
        }
      },
    );
  }

  Future<void> _onSubmitCenterRating(
    SubmitCenterRating event,
    Emitter<HealthcareCenterState> emit,
  ) async {
    emit(HealthcareCenterLoading());

    final result = await submitRating.execute(
      centerId: event.centerId,
      userId: event.userId,
      ratingValue: event.ratingValue,
      comment: event.comment,
    );

    result.fold(
      (failure) => emit(HealthcareCenterError(_mapFailureToMessage(failure))),
      (_) {
        emit(RatingSubmissionSuccess());
        add(LoadCenterRatings(event.centerId));
      },
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Server error: ${failure.message}';
      case NotFoundFailure:
        return 'Not found: ${failure.message}';
      case ValidationFailure:
        return 'Validation error: ${failure.message}';
      default:
        return 'Unexpected error: ${failure.message}';
    }
  }
}
