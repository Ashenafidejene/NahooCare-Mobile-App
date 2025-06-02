import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import '../blocs/account_bloc.dart';

class DeleteAccountDialog extends StatelessWidget {
  const DeleteAccountDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('account.delete_title'.tr()),
      content: Text('account.delete_message'.tr()),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('account.cancel'.tr()),
        ),
        TextButton(
          onPressed: () {
            context.read<AccountBloc>().add(DeleteAccountEvent());
            Navigator.pop(context);
          },
          child: Text(
            'account.delete'.tr(),
            style: const TextStyle(color: Colors.red),
          ),
        ),
      ],
    );
  }
}
