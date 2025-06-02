import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../domain/entities/health_profile.dart';

class HealthProfileForm extends StatefulWidget {
  final HealthProfile profile;
  final ValueChanged<HealthProfile> onProfileChanged;

  const HealthProfileForm({
    super.key,
    required this.profile,
    required this.onProfileChanged,
  });

  @override
  State<HealthProfileForm> createState() => _HealthProfileFormState();
}

class _HealthProfileFormState extends State<HealthProfileForm> {
  late final TextEditingController _bloodTypeController;
  late final TextEditingController _allergyController;
  late final TextEditingController _conditionController;
  late final TextEditingController _historyController;

  late List<String> _allergies;
  late List<String> _chronicConditions;
  late List<String> _medicalHistory;

  final List<String> bloodTypes = [
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-',
  ];

  @override
  void initState() {
    super.initState();
    _bloodTypeController = TextEditingController(
      text: widget.profile.bloodType,
    );
    _allergyController = TextEditingController();
    _conditionController = TextEditingController();
    _historyController = TextEditingController();

    _allergies = List.from(widget.profile.allergies);
    _chronicConditions = List.from(widget.profile.chronicConditions);
    _medicalHistory = List.from(widget.profile.medicalHistory);
  }

  @override
  void dispose() {
    _bloodTypeController.dispose();
    _allergyController.dispose();
    _conditionController.dispose();
    _historyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownButtonFormField<String>(
            value: widget.profile.bloodType,
            decoration: _inputDecoration('health_profile.blood_type'.tr()),
            items:
                bloodTypes
                    .map(
                      (type) =>
                          DropdownMenuItem(value: type, child: Text(type)),
                    )
                    .toList(),
            onChanged: (value) {
              if (value != null) {
                _updateProfile(widget.profile.copyWith(bloodType: value));
              }
            },
          ),
          const SizedBox(height: 20),
          _buildListInput(
            controller: _allergyController,
            labelKey: 'health_profile.allergies',
            list: _allergies,
            onAdd: () {
              if (_allergyController.text.isNotEmpty) {
                _updateProfile(
                  widget.profile.copyWith(
                    allergies: [..._allergies, _allergyController.text],
                  ),
                );
                _allergyController.clear();
              }
            },
            onRemove: (index) {
              final newList = List<String>.from(_allergies)..removeAt(index);
              _updateProfile(widget.profile.copyWith(allergies: newList));
            },
          ),
          const SizedBox(height: 20),
          _buildListInput(
            controller: _conditionController,
            labelKey: 'health_profile.chronic_conditions',
            list: _chronicConditions,
            onAdd: () {
              if (_conditionController.text.isNotEmpty) {
                _updateProfile(
                  widget.profile.copyWith(
                    chronicConditions: [
                      ..._chronicConditions,
                      _conditionController.text,
                    ],
                  ),
                );
                _conditionController.clear();
              }
            },
            onRemove: (index) {
              final newList = List<String>.from(_chronicConditions)
                ..removeAt(index);
              _updateProfile(
                widget.profile.copyWith(chronicConditions: newList),
              );
            },
          ),
          const SizedBox(height: 20),
          _buildListInput(
            controller: _historyController,
            labelKey: 'health_profile.medical_history',
            list: _medicalHistory,
            onAdd: () {
              if (_historyController.text.isNotEmpty) {
                _updateProfile(
                  widget.profile.copyWith(
                    medicalHistory: [
                      ..._medicalHistory,
                      _historyController.text,
                    ],
                  ),
                );
                _historyController.clear();
              }
            },
            onRemove: (index) {
              final newList = List<String>.from(_medicalHistory)
                ..removeAt(index);
              _updateProfile(widget.profile.copyWith(medicalHistory: newList));
            },
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      hintText: '${'health_profile.add'.tr()} $label',
      filled: true,
      fillColor: Colors.grey.shade100,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }

  Widget _buildListInput({
    required TextEditingController controller,
    required String labelKey,
    required List<String> list,
    required VoidCallback onAdd,
    required Function(int) onRemove,
  }) {
    final label = labelKey.tr();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: controller,
                decoration: _inputDecoration(label),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: onAdd,
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(10),
              ),
              child: const Icon(Icons.add, size: 20),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (list.isNotEmpty)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(list.length, (index) {
              return Chip(
                label: Text(list[index]),
                deleteIcon: const Icon(Icons.close),
                onDeleted: () => onRemove(index),
                backgroundColor: Colors.blue.shade50,
              );
            }),
          ),
      ],
    );
  }

  void _updateProfile(HealthProfile newProfile) {
    setState(() {
      _allergies = newProfile.allergies;
      _chronicConditions = newProfile.chronicConditions;
      _medicalHistory = newProfile.medicalHistory;
    });
    widget.onProfileChanged(newProfile);
  }
}
