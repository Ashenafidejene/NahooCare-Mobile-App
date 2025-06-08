part of 'health_profile_bloc.dart';

abstract class HealthProfileEvent extends Equatable {
  const HealthProfileEvent();

  @override
  List<Object> get props => [];
}

class LoadHealthProfileEvent extends HealthProfileEvent {}

class CreateHealthProfileEvent extends HealthProfileEvent {
  final HealthProfile profile;

  const CreateHealthProfileEvent(this.profile);

  @override
  List<Object> get props => [profile];
}

class UpdateHealthProfileEvent extends HealthProfileEvent {
  final HealthProfile profile;

  const UpdateHealthProfileEvent(this.profile);

  @override
  List<Object> get props => [profile];
}

class DeleteHealthProfileEvent extends HealthProfileEvent {}

class HealthProfileUpdating extends HealthProfileState {
  final HealthProfile profile;

  const HealthProfileUpdating(this.profile);

  @override
  List<Object> get props => [profile];
}
