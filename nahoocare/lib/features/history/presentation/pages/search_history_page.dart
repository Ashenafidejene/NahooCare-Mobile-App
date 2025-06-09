import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import '../blocs/search_history_bloc.dart';
import '../widgets/empty_history_widget.dart';
import '../widgets/history_list_widget.dart';

class SearchHistoryPage extends StatelessWidget {
  const SearchHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SearchHistoryBloc, SearchHistoryState>(
      listener: (context, state) {
        if (state is SearchHistoryError &&
            _isUnauthorizedError(state.message)) {
          _showLoginRequiredDialog(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.chevron_left,
              size: 30,
              color: Colors.blueAccent,
            ),
            onPressed: () => Navigator.maybePop(context),
          ),
          title: Text('search_history.title'.tr()),
          actions: [
            BlocBuilder<SearchHistoryBloc, SearchHistoryState>(
              builder: (context, state) {
                if (state is! SearchHistoryLoaded || state.history.isEmpty) {
                  return const SizedBox.shrink();
                }
                return IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  tooltip: 'search_history.clear_all'.tr(),
                  onPressed: () => _showDeleteAllDialog(context),
                );
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: BlocBuilder<SearchHistoryBloc, SearchHistoryState>(
            builder: (context, state) {
              if (state is SearchHistoryLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is SearchHistoryError) {
                if (_isUnauthorizedError(state.message)) {
                  return _buildLoginRequiredUI(context);
                }
                return Center(child: Text(state.message));
              }
              if (state is SearchHistoryLoaded) {
                return state.history.isEmpty
                    ? EmptyHistoryWidget(
                      onRefresh:
                          () => context.read<SearchHistoryBloc>().add(
                            LoadSearchHistory(),
                          ),
                    )
                    : HistoryListWidget(history: state.history);
              }
              return EmptyHistoryWidget(
                onRefresh:
                    () => context.read<SearchHistoryBloc>().add(
                      LoadSearchHistory(),
                    ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLoginRequiredUI(BuildContext context) {
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
              'search_history.login_required_message'.tr(),
              style: Theme.of(context).textTheme.titleMedium,
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
                onPressed: () => _navigateToLogin(context),
                child: Text(
                  'search_history.login'.tr(),
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLoginRequiredDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            title: Text('search_history.login_required'.tr()),
            content: Text('search_history.login_required_message'.tr()),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'.tr()),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _navigateToLogin(context);
                },
                child: Text('search_history.login'.tr()),
              ),
            ],
          ),
    );
  }

  void _showDeleteAllDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text('search_history.clear_all_title'.tr()),
            content: Text('search_history.clear_all_confirmation'.tr()),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'.tr()),
              ),
              FilledButton(
                style: FilledButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () {
                  context.read<SearchHistoryBloc>().add(
                    DeleteAllSearchHistory(),
                  );
                  Navigator.pop(context);
                },
                child: Text('search_history.delete'.tr()),
              ),
            ],
          ),
    );
  }

  void _navigateToLogin(BuildContext context) {
    Navigator.of(context).pushReplacementNamed('/login');
  }

  bool _isUnauthorizedError(String message) {
    return message.contains('401') ||
        message.toLowerCase().contains('unauthorized') ||
        message.contains('session_expired');
  }
}
