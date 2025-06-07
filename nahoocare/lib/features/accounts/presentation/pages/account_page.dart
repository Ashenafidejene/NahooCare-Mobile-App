import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

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
        leading: IconButton(
          icon: const Icon(
            Icons.chevron_left,
            size: 30,
            color: Colors.blueAccent,
          ), // Larger back icon
          onPressed: () => Navigator.maybePop(context), // Safer pop
        ),
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
            return Center(
              child: LoadingAnimationWidget.halfTriangleDot(
                color: Colors.blueAccent,
                size: 70,
              ),
            );
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
    return SizedBox(
      width: double.infinity, // Makes button full width
      child: ElevatedButton.icon(
        icon: const Icon(Icons.delete_outline, size: 20),
        label: Text('account.delete'.tr()),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: Colors.redAccent,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        onPressed:
            () => showDialog(
              context: context,
              builder: (_) => const DeleteAccountDialog(),
            ),
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
