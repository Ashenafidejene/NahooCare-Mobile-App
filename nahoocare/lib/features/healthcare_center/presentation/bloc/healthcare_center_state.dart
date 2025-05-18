// lib/features/healthcare_center/presentation/bloc/healthcare_center_state.dart
part of 'healthcare_center_bloc.dart';

abstract class HealthcareCenterState extends Equatable {
  const HealthcareCenterState();

  @override
  List<Object> get props => [];
}

class HealthcareCenterInitial extends HealthcareCenterState {}

class HealthcareCenterLoading extends HealthcareCenterState {}

class HealthcareCenterLoaded extends HealthcareCenterState {
  final HealthcareCenter center;
  final List<Rating>? ratings;
  final double? averageRating;

  const HealthcareCenterLoaded({
    required this.center,
    this.ratings,
    this.averageRating,
  });
  HealthcareCenterLoaded copyWith({
    HealthcareCenter? center,
    List<Rating>? ratings,
  }) {
    return HealthcareCenterLoaded(
      center: center ?? this.center,
      ratings: ratings ?? this.ratings,
    );
  }

  @override
  List<Object> get props => [center, ratings ?? [], averageRating ?? 0];
}

class RatingSubmissionSuccess extends HealthcareCenterState {}

class HealthcareCenterError extends HealthcareCenterState {
  final String message;

  const HealthcareCenterError(this.message);

  @override
  List<Object> get props => [message];
}
