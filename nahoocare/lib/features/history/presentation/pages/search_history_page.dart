import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/search_history_bloc.dart';
import '../widgets/empty_history_widget.dart';
import '../widgets/history_list_widget.dart';

class SearchHistoryPage extends StatelessWidget {
  const SearchHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<SearchHistoryBloc>().add(LoadSearchHistory());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            tooltip: 'Clear All',
            onPressed: () => _showDeleteAllDialog(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: BlocBuilder<SearchHistoryBloc, SearchHistoryState>(
          builder: (context, state) {
            if (state is SearchHistoryLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is SearchHistoryLoaded) {
              return state.history.isEmpty
                  ? const EmptyHistoryWidget()
                  : HistoryListWidget(history: state.history);
            } else if (state is SearchHistoryError) {
              return Center(child: Text(state.message));
            }
            return const EmptyHistoryWidget();
          },
        ),
      ),
    );
  }

  void _showDeleteAllDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Clear All History'),
            content: const Text(
              'Are you sure you want to delete all search history?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              FilledButton(
                style: FilledButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () {
                  context.read<SearchHistoryBloc>().add(
                    DeleteAllSearchHistory(),
                  );
                  Navigator.pop(context);
                },
                child: const Text('Delete'),
              ),
            ],
          ),
    );
  }
}
