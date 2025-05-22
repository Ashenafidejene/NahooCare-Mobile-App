import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/account_bloc.dart';

class DeleteAccountDialog extends StatelessWidget {
  const DeleteAccountDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete Account'),
      content: const Text(
        'Are you sure you want to delete your account? '
        'This action cannot be undone.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            context.read<AccountBloc>().add(DeleteAccountEvent());
            Navigator.pop(context);
          },
          child: const Text('Delete', style: TextStyle(color: Colors.red)),
        ),
      ],
    );
  }
}
