import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecase/usecase.dart';
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

  AccountBloc({
    required this.getAccountUseCase,
    required this.updateAccountUseCase,
    required this.deleteAccountUseCase,
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
    final result = await getAccountUseCase(NoParams());
    result.fold(
      (failure) => emit(AccountError(failure.message)),
      (account) => emit(AccountLoaded(account)),
    );
  }

  Future<void> _onUpdateAccount(
    UpdateAccountEvent event,
    Emitter<AccountState> emit,
  ) async {
    emit(AccountLoading());
    final result = await updateAccountUseCase(
      UpdateAccountParams(account: event.account, password: event.password),
    );
    result.fold(
      (failure) => emit(AccountError(failure.message)),
      (_) => emit(AccountUpdated(event.account)),
    );
  }

  Future<void> _onDeleteAccount(
    DeleteAccountEvent event,
    Emitter<AccountState> emit,
  ) async {
    emit(AccountLoading());
    final result = await deleteAccountUseCase(NoParams());
    result.fold(
      (failure) => emit(AccountError(failure.message)),
      (_) => emit(AccountDeleted()),
    );
  }
}
