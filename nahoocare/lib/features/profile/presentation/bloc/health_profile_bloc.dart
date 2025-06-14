import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:easy_localization/easy_localization.dart';
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
    final result = await getHealthProfile(NoParams());
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
        emit(HealthProfileOperationSuccess('profile_created'.tr()));
        emit(HealthProfileLoaded(profile));
      },
    );
  }

  Future<void> _onUpdateHealthProfile(
    UpdateHealthProfileEvent event,
    Emitter<HealthProfileState> emit,
  ) async {
    emit(HealthProfileUpdating(event.profile));
    final result = await updateHealthProfile(
      UpdateHealthProfileParams(profile: event.profile),
    );
    result.fold(
      (failure) => emit(HealthProfileError(_mapFailureToMessage(failure))),
      (profile) {
        emit(HealthProfileOperationSuccess('profile_updated'.tr()));
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
        emit(HealthProfileOperationSuccess('profile_deleted'.tr()));
        emit(HealthProfileEmpty());
      },
    );
  }

  String _mapFailureToMessage(Failure failure) {
    final message = (failure as dynamic).message ?? '';
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'server_error'.tr(args: [message]);
      case NetworkFailure:
        return 'network_error'.tr(args: [message]);
      case ValidationFailure:
        return 'validation_error'.tr(args: [message]);
      case NotFoundFailure:
        return 'profile_not_found'.tr();
      case UnauthorizedFailure:
        return 'unauthorized'.tr();
      default:
        return 'unexpected_error'.tr(args: [message]);
    }
  }
}
