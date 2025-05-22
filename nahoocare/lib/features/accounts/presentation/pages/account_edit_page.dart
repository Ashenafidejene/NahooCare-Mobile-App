import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/account_entity.dart';
import '../blocs/account_bloc.dart';
import '../widgets/account_edit_form.dart';

class AccountEditPage extends StatelessWidget {
  final AccountEntity initialAccount;

  const AccountEditPage({super.key, required this.initialAccount});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Account'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () => _saveChanges(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: AccountEditForm(initialAccount: initialAccount),
      ),
    );
  }

  void _saveChanges(BuildContext context) {
    final formKey = context.read<AccountEditForm>().formKey;
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      final form = context.read<AccountEditForm>();
      context.read<AccountBloc>().add(
        UpdateAccountEvent(
          account: AccountEntity(
            fullName: form.fullName!,
            phoneNumber: form.phoneNumber!,
            secretQuestion: form.secretQuestion!,
            secretAnswer: form.secretAnswer!,
          ),
          password: form.password!,
        ),
      );
      Navigator.pop(context);
    }
  }
}
