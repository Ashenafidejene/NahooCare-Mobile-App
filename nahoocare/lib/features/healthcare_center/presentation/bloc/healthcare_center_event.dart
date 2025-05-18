// lib/features/healthcare_center/presentation/bloc/healthcare_center_event.dart
part of 'healthcare_center_bloc.dart';

abstract class HealthcareCenterEvent extends Equatable {
  const HealthcareCenterEvent();

  @override
  List<Object> get props => [];
}

class LoadHealthcareCenterDetails extends HealthcareCenterEvent {
  final String centerId;

  const LoadHealthcareCenterDetails(this.centerId);

  @override
  List<Object> get props => [centerId];
}

class LoadCenterRatings extends HealthcareCenterEvent {
  final String centerId;

  const LoadCenterRatings(this.centerId);

  @override
  List<Object> get props => [centerId];
}

class SubmitCenterRating extends HealthcareCenterEvent {
  final String centerId;
  final String userId;
  final int ratingValue;
  final String comment;

  const SubmitCenterRating({
    required this.centerId,
    required this.userId,
    required this.ratingValue,
    required this.comment,
  });

  @override
  List<Object> get props => [centerId, userId, ratingValue, comment];
}
