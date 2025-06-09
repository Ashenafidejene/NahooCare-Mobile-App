import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../auth/data/datasources/cloudinary_datasources.dart';
import '../../domain/entities/account_entity.dart';
import '../../domain/usecases/delete_account_usecase.dart';
import '../../domain/usecases/get_account_usecase.dart';
import '../../domain/usecases/update_account_usecase.dart';

part 'account_event.dart';
part 'account_state.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  final GetAccountUseCase getAccountUseCase;
  final UpdateAccountUseCase updateAccountUseCase;
  final DeleteAccountUseCase deleteAccountUseCase;
  final CloudinaryDataSource cloudinaryDataSource;
  AccountBloc({
    required this.getAccountUseCase,
    required this.updateAccountUseCase,
    required this.deleteAccountUseCase,
    required this.cloudinaryDataSource,
  }) : super(AccountInitial()) {
    on<LoadAccountEvent>(_onLoadAccount);
    on<UpdateAccountEvent>(_onUpdateAccount);
    on<DeleteAccountEvent>(_onDeleteAccount);
  }

  void initialize() {
    if (state is AccountInitial) {
      add(LoadAccountEvent());
    }
  }

  Future<void> _onLoadAccount(
    LoadAccountEvent event,
    Emitter<AccountState> emit,
  ) async {
    emit(AccountLoading());
    final result = await getAccountUseCase(const NoParams());
    result.fold(
      (failure) => emit(AccountError(_mapFailureToMessage(failure))),
      (account) => emit(AccountLoaded(account)),
    );
  }

  Future<void> _onUpdateAccount(
    UpdateAccountEvent event,
    Emitter<AccountState> emit,
  ) async {
    emit(AccountLoading());

    try {
      String photoUrl = event.account.photoUrl;

      if (event.photo != null) {
        photoUrl = await cloudinaryDataSource.uploadImage(event.photo!);
      }

      final updatedAccount = event.account.copyWith(photoUrl: photoUrl);
      final result = await updateAccountUseCase(
        UpdateAccountParams(account: updatedAccount, password: event.password),
      );

      result.fold(
        (failure) => emit(AccountError(_mapFailureToMessage(failure))),
        (_) => emit(AccountUpdated(updatedAccount)),
      );
    } catch (e) {
      emit(AccountError('errors.image_upload'.tr(args: [e.toString()])));
    }
  }

  Future<void> _onDeleteAccount(
    DeleteAccountEvent event,
    Emitter<AccountState> emit,
  ) async {
    emit(AccountLoading());
    final result = await deleteAccountUseCase(const NoParams());
    result.fold(
      (failure) => emit(AccountError(_mapFailureToMessage(failure))),
      (_) => emit(AccountDeleted()),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return (failure as ServerFailure).message;
      case NetworkFailure:
        return 'errors.network'.tr();
      case ValidationFailure:
        return 'errors.validation'.tr();
      case UnauthorizedFailure:
        return 'errors.unauthorized'.tr();
      case NotFoundFailure:
        return 'errors.account.not_found'.tr();
      default:
        return 'errors.unexpected'.tr();
    }
  }
}
