import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/search_history_entity.dart';
import '../blocs/search_history_bloc.dart';
import 'history_item_widget.dart';

class HistoryListWidget extends StatelessWidget {
  final List<SearchHistoryEntity> history;

  const HistoryListWidget({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(context),
        const Divider(thickness: 1),
        Expanded(
          child: ListView.separated(
            itemCount: history.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder:
                (context, index) => HistoryItemWidget(
                  item: history[index],
                  onDelete:
                      () => context.read<SearchHistoryBloc>().add(
                        DeleteSearchHistory(history[index].searchId),
                      ),
                ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(Icons.history, color: Colors.blueAccent),
          const SizedBox(width: 8),
          Text(
            '${history.length} ${history.length == 1 ? 'item' : 'items'}',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
