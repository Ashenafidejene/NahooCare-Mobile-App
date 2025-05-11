part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class LoginEvent extends AuthEvent {
  final String phoneNumber;
  final String password;

  const LoginEvent({required this.phoneNumber, required this.password});

  @override
  List<Object> get props => [phoneNumber, password];
}

class RegisterEvent extends AuthEvent {
  final String fullName;
  final String phoneNumber;
  final String password;
  final String secretQuestion;
  final String secretAnswer;

  const RegisterEvent({
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

class GetSecretQuestionEvent extends AuthEvent {
  final String phoneNumber;

  const GetSecretQuestionEvent({required this.phoneNumber});

  @override
  List<Object> get props => [phoneNumber];
}

class ResetPasswordEvent extends AuthEvent {
  final String phoneNumber;
  final String secretAnswer;
  final String newPassword;

  const ResetPasswordEvent({
    required this.phoneNumber,
    required this.secretAnswer,
    required this.newPassword,
  });

  @override
  List<Object> get props => [phoneNumber, secretAnswer, newPassword];
}

class CheckAuthenticationEvent extends AuthEvent {}

class LogoutEvent extends AuthEvent {}
