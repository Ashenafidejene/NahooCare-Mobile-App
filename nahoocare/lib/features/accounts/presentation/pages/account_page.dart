import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import '../blocs/account_bloc.dart';
import '../widgets/account_info_card.dart';
import '../widgets/delete_account_dialog.dart';
import 'account_edit_page.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AccountBloc>().initialize();
    });
    return Scaffold(
      appBar: AppBar(
        title: Text('account.my_account'.tr()),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _navigateToEdit(context),
          ),
        ],
      ),
      body: BlocConsumer<AccountBloc, AccountState>(
        listener: (context, state) {
          if (state is AccountError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
          if (state is AccountDeleted) {
            Navigator.of(context).pushReplacementNamed('/login');
          }
        },
        builder: (context, state) {
          if (state is AccountLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is AccountLoaded || state is AccountUpdated) {
            final account =
                (state is AccountLoaded)
                    ? state.account
                    : (state as AccountUpdated).account;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  AccountInfoCard(account: account),
                  const SizedBox(height: 20),
                  _buildDeleteButton(context),
                ],
              ),
            );
          }
          return Center(child: Text('account.no_data'.tr()));
        },
      ),
    );
  }

  Widget _buildDeleteButton(BuildContext context) {
    return ElevatedButton.icon(
      icon: const Icon(Icons.delete, color: Colors.red),
      label: Text(
        'account.delete'.tr(),
        style: const TextStyle(color: Colors.red),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red.withOpacity(0.1),
      ),
      onPressed:
          () => showDialog(
            context: context,
            builder: (_) => const DeleteAccountDialog(),
          ),
    );
  }

  void _navigateToEdit(BuildContext context) {
    final state = context.read<AccountBloc>().state;
    if (state is AccountLoaded || state is AccountUpdated) {
      final account =
          (state is AccountLoaded)
              ? state.account
              : (state as AccountUpdated).account;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => AccountEditPage(initialAccount: account),
        ),
      );
    }
  }
}
