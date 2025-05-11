part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class LoginSuccess extends AuthState {
  final String token;

  const LoginSuccess(this.token);

  @override
  List<Object> get props => [token];
}

class RegisterSuccess extends AuthState {
  final String message;

  const RegisterSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class SecretQuestionLoaded extends AuthState {
  final String question;

  const SecretQuestionLoaded(this.question);

  @override
  List<Object> get props => [question];
}

class PasswordResetSuccess extends AuthState {
  final String message;

  const PasswordResetSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class Authenticated extends AuthState {}

class NotAuthenticated extends AuthState {}

class LogoutSuccess extends AuthState {}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object> get props => [message];
}
