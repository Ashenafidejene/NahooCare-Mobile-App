part of 'account_bloc.dart';

abstract class AccountEvent extends Equatable {
  const AccountEvent();

  @override
  List<Object> get props => [];
}

class LoadAccountEvent extends AccountEvent {}

class UpdateAccountEvent extends AccountEvent {
  final AccountEntity account;
  final String password;

  const UpdateAccountEvent({required this.account, required this.password});

  @override
  List<Object> get props => [account, password];
}

class DeleteAccountEvent extends AccountEvent {}
