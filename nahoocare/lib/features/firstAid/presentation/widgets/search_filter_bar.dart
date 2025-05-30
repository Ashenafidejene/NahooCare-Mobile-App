import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search first aid guides...',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surfaceVariant,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: widget.onSearch,
                ),
              ),
              const SizedBox(width: 12),
              Material(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(30),
                child: InkWell(
                  onTap: () => setState(() => showFilters = !showFilters),
                  borderRadius: BorderRadius.circular(30),
                  child: const Padding(
                    padding: EdgeInsets.all(10),
                    child: Icon(Icons.filter_alt, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          if (showFilters) ...[
            const SizedBox(height: 12),
            Align(
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
                        selectedColor:
                            Theme.of(context).colorScheme.primaryContainer,
                        backgroundColor:
                            Theme.of(context).colorScheme.surfaceVariant,
                        labelStyle: TextStyle(
                          color:
                              isSelected
                                  ? Theme.of(
                                    context,
                                  ).colorScheme.onPrimaryContainer
                                  : Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                        ),
                      );
                    }).toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
