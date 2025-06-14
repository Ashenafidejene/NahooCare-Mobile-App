import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/account_entity.dart';
import '../blocs/account_bloc.dart';
import '../widgets/account_edit_form.dart';
import 'package:easy_localization/easy_localization.dart';

class AccountEditPage extends StatelessWidget {
  const AccountEditPage({super.key, required this.initialAccount});

  final AccountEntity initialAccount;

  void _saveChanges(BuildContext context, AccountEditForm formWidget) {
    final formKey = formWidget.formKey;
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      final updatedAccount = formWidget.updatedAccount;
      final password = formWidget.password;
      final photo = formWidget.selectedImage;

      if (password == null || password.isEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Password is required'.tr())));
        return;
      }

      context.read<AccountBloc>().add(
        UpdateAccountEvent(
          account: updatedAccount,
          password: password,
          photo: photo,
        ),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final formWidget = AccountEditForm(initialAccount: initialAccount);

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Account'.tr()),
        leading: IconButton(
          icon: const Icon(
            Icons.chevron_left,
            size: 30,
            color: Colors.blueAccent,
          ),
          onPressed: () => Navigator.maybePop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () => _saveChanges(context, formWidget),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: formWidget,
      ),
    );
  }
}
