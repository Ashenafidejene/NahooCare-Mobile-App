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
      context.read<AccountBloc>().add(LoadAccountEvent());
    });
    return Scaffold(
      appBar: AppBar(
        title: Text('account.my_account'.tr()),
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
            icon: const Icon(Icons.edit),
            onPressed: () => _navigateToEdit(context),
          ),
        ],
      ),
      body: BlocConsumer<AccountBloc, AccountState>(
        listener: (context, state) {
          if (state is AccountError && _isUnauthorizedError(state.message)) {
            _showLoginRequiredDialog(context);
          } else if (state is AccountError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                duration: const Duration(seconds: 3),
              ),
            );
          }
          if (state is AccountDeleted) {
            _redirectToLogin(
              context,
              showMessage: 'account.deleted_successfully'.tr(),
            );
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
          if (state is AccountError && _isUnauthorizedError(state.message)) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.login_rounded,
                      size: 64,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'account.login_required_message'.tr(),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () => _redirectToLogin(context),
                        child: Text(
                          'account.login'.tr(),
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          if (state is AccountError) {
            return Center(child: Text(state.message));
          }
          return Center(child: Text('account.no_data'.tr()));
        },
      ),
    );
  }

  void _showLoginRequiredDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            title: Text('account.login_required'.tr()),
            content: Text('account.login_required_message'.tr()),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'.tr()),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                ),
                onPressed: () {
                  Navigator.pop(context);
                  _redirectToLogin(context);
                },
                child: Text('account.login'.tr()),
              ),
            ],
          ),
    );
  }

  bool _isUnauthorizedError(String message) {
    return message.contains('401') ||
        message.toLowerCase().contains('unauthorized') ||
        message.contains('errors.account.fetch_failed');
  }

  void _redirectToLogin(BuildContext context, {String? showMessage}) {
    if (showMessage != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(showMessage)));
    }
    Navigator.of(context).pushReplacementNamed('/login');
  }

  Widget _buildDeleteButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
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
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('account.load_data_first'.tr())));
    }
  }
}
