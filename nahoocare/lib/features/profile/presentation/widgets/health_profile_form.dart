import 'package:flutter/material.dart';

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
    return Column(
      children: [
        DropdownButtonFormField<String>(
          value: widget.profile.bloodType,
          decoration: const InputDecoration(
            labelText: 'Blood Type',
            border: OutlineInputBorder(),
          ),
          items:
              bloodTypes
                  .map(
                    (type) => DropdownMenuItem(value: type, child: Text(type)),
                  )
                  .toList(),
          onChanged: (value) {
            if (value != null) {
              _updateProfile(widget.profile.copyWith(bloodType: value));
            }
          },
        ),
        const SizedBox(height: 16),
        _buildListInput(
          controller: _allergyController,
          label: 'Allergies',
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
            final newAllergies = List.from(_allergies);
            newAllergies.removeAt(index);
            _updateProfile(
              widget.profile.copyWith(allergies: newAllergies.cast<String>()),
            );
          },
        ),
        const SizedBox(height: 16),
        _buildListInput(
          controller: _conditionController,
          label: 'Chronic Conditions',
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
            final newConditions = List.from(_chronicConditions);
            newConditions.removeAt(index);
            _updateProfile(
              widget.profile.copyWith(
                chronicConditions: newConditions.cast<String>(),
              ),
            );
          },
        ),
        const SizedBox(height: 16),
        _buildListInput(
          controller: _historyController,
          label: 'Medical History',
          list: _medicalHistory,
          onAdd: () {
            if (_historyController.text.isNotEmpty) {
              _updateProfile(
                widget.profile.copyWith(
                  medicalHistory: [..._medicalHistory, _historyController.text],
                ),
              );
              _historyController.clear();
            }
          },
          onRemove: (index) {
            final newHistory = List.from(_medicalHistory);
            newHistory.removeAt(index);
            _updateProfile(
              widget.profile.copyWith(
                medicalHistory: newHistory.cast<String>(),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildListInput({
    required TextEditingController controller,
    required String label,
    required List<String> list,
    required VoidCallback onAdd,
    required Function(int) onRemove,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: 'Add $label',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: onAdd,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (list.isNotEmpty)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(list.length, (index) {
              return Chip(
                label: Text(list[index]),
                onDeleted: () => onRemove(index),
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
