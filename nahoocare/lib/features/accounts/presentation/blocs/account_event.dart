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
  final File? photo;

  const UpdateAccountEvent({
    required this.account,
    required this.password,
    this.photo,
  });

  @override
  List<Object> get props => [account, password, photo ?? ''];
}

class DeleteAccountEvent extends AccountEvent {}
