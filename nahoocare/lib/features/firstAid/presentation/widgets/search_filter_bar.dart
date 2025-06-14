import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class SearchFilterBar extends StatefulWidget {
  final List<String> categories;
  final Function(String) onSearch;
  final Function(String) onFilter;

  const SearchFilterBar({
    super.key,
    required this.categories,
    required this.onSearch,
    required this.onFilter,
  });

  @override
  State<SearchFilterBar> createState() => _SearchFilterBarState();
}

class _SearchFilterBarState extends State<SearchFilterBar> {
  bool showFilters = false;
  String _selectedCategory = 'All';
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search first aid guides...'.tr(),
                    prefixIcon: Icon(
                      Icons.search,
                      color: theme.iconTheme.color,
                    ),
                    filled: true,
                    fillColor: theme.colorScheme.surfaceVariant,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 0,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: widget.onSearch,
                ),
              ),
              const SizedBox(width: 12),
              IconButton(
                icon: Icon(Icons.filter_alt, color: theme.colorScheme.primary),
                onPressed: () => setState(() => showFilters = !showFilters),
                tooltip: 'Filter options'.tr(),
              ),
            ],
          ),
        ),
        if (showFilters) ...[
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Wrap(
                spacing: 10,
                runSpacing: 8,
                children:
                    widget.categories.map((category) {
                      final isSelected = category == _selectedCategory;
                      return ChoiceChip(
                        label: Text(category),
                        selected: isSelected,
                        onSelected: (_) {
                          setState(() => _selectedCategory = category);
                          widget.onFilter(category);
                        },
                        selectedColor: theme.colorScheme.primaryContainer,
                        backgroundColor: theme.colorScheme.surfaceVariant,
                        labelStyle: TextStyle(
                          color:
                              isSelected
                                  ? theme.colorScheme.onPrimaryContainer
                                  : theme.colorScheme.onSurfaceVariant,
                        ),
                      );
                    }).toList(),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
