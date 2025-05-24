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
        Expanded(
          child: ListView.separated(
            itemCount: history.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder:
                (context, index) => HistoryItemWidget(
                  item: history[index],
                  onDelete: () => _deleteItem(context, history[index].searchId),
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
          Text(
            '${history.length} ${history.length == 1 ? 'Item' : 'Items'}',
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  void _deleteItem(BuildContext context, String searchId) {
    context.read<SearchHistoryBloc>().add(DeleteSearchHistory(searchId));
  }
}
