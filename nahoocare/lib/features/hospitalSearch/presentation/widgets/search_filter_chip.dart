import 'package:flutter/material.dart';

class FilterBottomSheet extends StatefulWidget {
  final List<String> allSpecialties;
  final List<String> selectedSpecialties;
  final Function(List<String>) onApply;

  const FilterBottomSheet({
    super.key,
    required this.allSpecialties,
    required this.selectedSpecialties,
    required this.onApply,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late List<String> _selectedSpecialties;

  @override
  void initState() {
    super.initState();
    _selectedSpecialties = List.from(widget.selectedSpecialties);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Filter by Specialty',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _selectedSpecialties.clear();
                  });
                },
                child: const Text('Clear All'),
              ),
            ],
          ),
          const Divider(),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.6,
            ),
            child: SingleChildScrollView(
              child: Column(
                children:
                    widget.allSpecialties
                        .map(
                          (specialty) => CheckboxListTile(
                            title: Text(specialty),
                            value: _selectedSpecialties.contains(specialty),
                            onChanged: (bool? value) {
                              setState(() {
                                if (value == true) {
                                  _selectedSpecialties.add(specialty);
                                } else {
                                  _selectedSpecialties.remove(specialty);
                                }
                              });
                            },
                            controlAffinity: ListTileControlAffinity.leading,
                            contentPadding: EdgeInsets.zero,
                          ),
                        )
                        .toList(),
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                widget.onApply(_selectedSpecialties);
              },
              child: const Text('Apply Filters'),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
        ],
      ),
    );
  }
}
