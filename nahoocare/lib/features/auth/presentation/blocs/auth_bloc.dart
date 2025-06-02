import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/login_entity.dart';
import '../../domain/entities/register_entity.dart';
import '../../domain/entities/reset_password_entity.dart';
import '../../domain/usecases/is_authenticated_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/get_secret_question_usecase.dart';
import '../../domain/usecases/reset_password_usecase.dart';

import '../../domain/usecases/logout_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final GetSecretQuestionUseCase getSecretQuestionUseCase;
  final ResetPasswordUseCase resetPasswordUseCase;
  final IsAuthenticatedUseCase isAuthenticatedUseCase;
  final LogoutUseCase logoutUseCase;

  AuthBloc({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.getSecretQuestionUseCase,
    required this.resetPasswordUseCase,
    required this.isAuthenticatedUseCase,
    required this.logoutUseCase,
  }) : super(AuthInitial()) {
    on<LoginEvent>(_onLogin);
    on<RegisterEvent>(_onRegister);
    on<GetSecretQuestionEvent>(_onGetSecretQuestion);
    on<ResetPasswordEvent>(_onResetPassword);
    on<CheckAuthenticationEvent>(_onCheckAuthentication);
    on<LogoutEvent>(_onLogout);
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await loginUseCase(
      LoginEntity(phoneNumber: event.phoneNumber, password: event.password),
    );
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (authEntity) => emit(LoginSuccess(authEntity.token)),
    );
  }

  Future<void> _onRegister(RegisterEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await registerUseCase(
      RegisterEntity(
        fullName: event.fullName,
        phoneNumber: event.phoneNumber,
        password: event.password,
        secretQuestion: event.secretQuestion,
        secretAnswer: event.secretAnswer,
        photoUrl: event.photoUrl, // Add this
        gender: event.gender,
        dataOfBirth: event.dataOfBirth, // Add this
      ),
    );
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (message) => emit(RegisterSuccess(message)),
    );
  }

  Future<void> _onGetSecretQuestion(
    GetSecretQuestionEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await getSecretQuestionUseCase(event.phoneNumber);
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (question) => emit(SecretQuestionLoaded(question)),
    );
  }

  Future<void> _onResetPassword(
    ResetPasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await resetPasswordUseCase(
      ResetPasswordEntity(
        phoneNumber: event.phoneNumber,
        secretAnswer: event.secretAnswer,
        newPassword: event.newPassword,
      ),
    );
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (message) => emit(PasswordResetSuccess(message)),
    );
  }

  Future<void> _onCheckAuthentication(
    CheckAuthenticationEvent event,
    Emitter<AuthState> emit,
  ) async {
    final result = await isAuthenticatedUseCase(NoParams());
    result.fold(
      (failure) => emit(NotAuthenticated()),
      (isAuthenticated) =>
          emit(isAuthenticated ? Authenticated() : NotAuthenticated()),
    );
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await logoutUseCase(NoParams());
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(LogoutSuccess()),
    );
  }
}
