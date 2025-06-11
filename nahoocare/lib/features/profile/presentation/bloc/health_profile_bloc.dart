import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/health_profile.dart';
import '../../domain/usecases/create_health_profile.dart';
import '../../domain/usecases/delete_health_profile.dart';
import '../../domain/usecases/get_health_profile.dart';
import '../../domain/usecases/update_health_profile.dart';

part 'health_profile_event.dart';
part 'health_profile_state.dart';

class HealthProfileBloc extends Bloc<HealthProfileEvent, HealthProfileState> {
  final GetHealthProfile getHealthProfile;
  final CreateHealthProfile createHealthProfile;
  final UpdateHealthProfile updateHealthProfile;
  final DeleteHealthProfile deleteHealthProfile;

  HealthProfileBloc({
    required this.getHealthProfile,
    required this.createHealthProfile,
    required this.updateHealthProfile,
    required this.deleteHealthProfile,
  }) : super(HealthProfileInitial()) {
    on<LoadHealthProfileEvent>(_onLoadHealthProfile);
    on<CreateHealthProfileEvent>(_onCreateHealthProfile);
    on<UpdateHealthProfileEvent>(_onUpdateHealthProfile);
    on<DeleteHealthProfileEvent>(_onDeleteHealthProfile);
  }

  Future<void> _onLoadHealthProfile(
    LoadHealthProfileEvent event,
    Emitter<HealthProfileState> emit,
  ) async {
    emit(HealthProfileLoading());
    final result = await getHealthProfile(const NoParams());
    result.fold((failure) {
      if (failure is NotFoundFailure) {
        emit(HealthProfileEmpty()); // This will trigger showing the create form
      } else {
        emit(HealthProfileError(_mapFailureToMessage(failure)));
      }
    }, (profile) => emit(HealthProfileLoaded(profile)));
  }

  Future<void> _onCreateHealthProfile(
    CreateHealthProfileEvent event,
    Emitter<HealthProfileState> emit,
  ) async {
    emit(HealthProfileLoading());
    final result = await createHealthProfile(
      CreateHealthProfileParams(profile: event.profile),
    );
    result.fold(
      (failure) => emit(HealthProfileError(_mapFailureToMessage(failure))),
      (profile) {
        emit(HealthProfileOperationSuccess('Profile created successfully'));
        emit(HealthProfileLoaded(profile));
      },
    );
  }

  Future<void> _onUpdateHealthProfile(
    UpdateHealthProfileEvent event,
    Emitter<HealthProfileState> emit,
  ) async {
    emit(HealthProfileUpdating(event.profile)); // New state
    final result = await updateHealthProfile(
      UpdateHealthProfileParams(profile: event.profile),
    );
    result.fold(
      (failure) => emit(HealthProfileError(_mapFailureToMessage(failure))),
      (profile) {
        emit(HealthProfileOperationSuccess('Profile updated successfully'));
        emit(HealthProfileLoaded(profile));
      },
    );
  }

  Future<void> _onDeleteHealthProfile(
    DeleteHealthProfileEvent event,
    Emitter<HealthProfileState> emit,
  ) async {
    emit(HealthProfileLoading());
    final result = await deleteHealthProfile(NoParams());
    result.fold(
      (failure) => emit(HealthProfileError(_mapFailureToMessage(failure))),
      (_) {
        emit(HealthProfileOperationSuccess('Profile deleted successfully'));
        emit(HealthProfileEmpty());
      },
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Server error: ${failure.message}';
      case NetworkFailure:
        return 'Network error: ${failure.message}';
      case ValidationFailure:
        return 'Validation error: ${failure.message}';
      case NotFoundFailure:
        return 'Profile not found';
      case UnauthorizedFailure:
        return 'Unauthorized: Please login again';
      default:
        return 'Unexpected error: ${failure.message}';
    }
  }
}
