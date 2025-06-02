// registration_flow_event.dart
part of 'registration_flow_bloc.dart';

abstract class RegistrationFlowEvent extends Equatable {
  const RegistrationFlowEvent();

  @override
  List<Object> get props => [];
}

class SubmitBasicInfoEvent extends RegistrationFlowEvent {
  final String fullName;
  final String phoneNumber;
  final String password;
  final String secretQuestion;
  final String secretAnswer;

  const SubmitBasicInfoEvent({
    required this.fullName,
    required this.phoneNumber,
    required this.password,
    required this.secretQuestion,
    required this.secretAnswer,
  });

  @override
  List<Object> get props => [
    fullName,
    phoneNumber,
    password,
    secretQuestion,
    secretAnswer,
  ];
}

class SubmitProfilePhotoEvent extends RegistrationFlowEvent {
  final File photo;
  final String gender;
  final String dataOfBirth;

  const SubmitProfilePhotoEvent({
    required this.photo,
    required this.dataOfBirth,
    required this.gender,
  });

  @override
  List<Object> get props => [photo, dataOfBirth, gender];
}
