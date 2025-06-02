// registration_flow_state.dart
part of 'registration_flow_bloc.dart';

abstract class RegistrationFlowState extends Equatable {
  const RegistrationFlowState();

  @override
  List<Object> get props => [];
}

class RegistrationInitial extends RegistrationFlowState {}

class RegistrationLoading extends RegistrationFlowState {}

class ProfilePhotoRequired extends RegistrationFlowState {}

class RegistrationSuccess extends RegistrationFlowState {
  final String message;

  const RegistrationSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class RegistrationError extends RegistrationFlowState {
  final String message;

  const RegistrationError(this.message);

  @override
  List<Object> get props => [message];
}
