part of 'health_profile_bloc.dart';

abstract class HealthProfileState extends Equatable {
  const HealthProfileState();

  @override
  List<Object> get props => [];
}

class HealthProfileInitial extends HealthProfileState {}

class HealthProfileLoading extends HealthProfileState {}

class HealthProfileLoaded extends HealthProfileState {
  final HealthProfile profile;

  const HealthProfileLoaded(this.profile);

  @override
  List<Object> get props => [profile];
}

class HealthProfileEmpty extends HealthProfileState {}

class HealthProfileError extends HealthProfileState {
  final String message;

  const HealthProfileError(this.message);

  @override
  List<Object> get props => [message];
}

class HealthProfileOperationSuccess extends HealthProfileState {
  final String message;

  const HealthProfileOperationSuccess(this.message);

  @override
  List<Object> get props => [message];
}
