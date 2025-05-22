part of 'account_bloc.dart';

abstract class AccountState extends Equatable {
  const AccountState();

  @override
  List<Object> get props => [];
}

class AccountInitial extends AccountState {}

class AccountLoading extends AccountState {}

class AccountLoaded extends AccountState {
  final AccountEntity account;

  const AccountLoaded(this.account);

  @override
  List<Object> get props => [account];
}

class AccountUpdated extends AccountState {
  final AccountEntity account;

  const AccountUpdated(this.account);

  @override
  List<Object> get props => [account];
}

class AccountDeleted extends AccountState {}

class AccountError extends AccountState {
  final String message;

  const AccountError(this.message);

  @override
  List<Object> get props => [message];
}
