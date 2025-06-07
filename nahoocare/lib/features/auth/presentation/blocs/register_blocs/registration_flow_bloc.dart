// registration_flow_bloc.dart
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/datasources/cloudinary_datasources.dart';
import '../../../domain/entities/register_entity.dart';
import '../../../domain/usecases/register_usecase.dart';

part 'registration_flow_event.dart';
part 'registration_flow_state.dart';

class RegistrationFlowBloc
    extends Bloc<RegistrationFlowEvent, RegistrationFlowState> {
  final RegisterUseCase registerUseCase;
  final CloudinaryDataSource cloudinaryDataSource;

  RegistrationFlowBloc({
    required this.registerUseCase,
    required this.cloudinaryDataSource,
  }) : super(RegistrationInitial()) {
    on<SubmitBasicInfoEvent>(_onSubmitBasicInfo);
    on<SubmitProfilePhotoEvent>(_onSubmitProfilePhoto);
  }

  RegisterEntity? _pendingRegistration;

  Future<void> _onSubmitBasicInfo(
    SubmitBasicInfoEvent event,
    Emitter<RegistrationFlowState> emit,
  ) async {
    emit(RegistrationLoading());

    _pendingRegistration = RegisterEntity(
      fullName: event.fullName,
      phoneNumber: event.phoneNumber,
      password: event.password,
      secretQuestion: event.secretQuestion,
      secretAnswer: event.secretAnswer,
      photoUrl: '', // Will be set later
      gender: '',
      dataOfBirth: '', // Will be set later
    );

    emit(ProfilePhotoRequired());
  }

  Future<void> _onSubmitProfilePhoto(
    SubmitProfilePhotoEvent event,
    Emitter<RegistrationFlowState> emit,
  ) async {
    if (_pendingRegistration == null) {
      emit(RegistrationError('Registration data not found'));
      return;
    }

    emit(RegistrationLoading());

    try {
      // 1. Upload image to Cloudinary
      final photoUrl = await cloudinaryDataSource.uploadImage(event.photo);

      // 2. Complete registration data
      final registrationData = RegisterEntity(
        fullName: _pendingRegistration!.fullName,
        phoneNumber: _pendingRegistration!.phoneNumber,
        password: _pendingRegistration!.password,
        secretQuestion: _pendingRegistration!.secretQuestion,
        secretAnswer: _pendingRegistration!.secretAnswer,
        photoUrl: photoUrl,
        gender: event.gender,
        dataOfBirth: event.dataOfBirth,
      );

      // 3. Call registration API
      final result = await registerUseCase(registrationData);

      result.fold(
        (failure) => emit(RegistrationError(failure.message)),
        (message) => emit(RegistrationSuccess(message)),
      );
    } catch (e) {
      emit(RegistrationError('Failed to complete registration: $e'));
    }
  }
}
