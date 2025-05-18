import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/health_profile.dart';
import '../bloc/health_profile_bloc.dart';

class CreateHealthProfileForm extends StatefulWidget {
  const CreateHealthProfileForm({super.key});

  @override
  State<CreateHealthProfileForm> createState() =>
      _CreateHealthProfileFormState();
}

class _CreateHealthProfileFormState extends State<CreateHealthProfileForm> {
  final _formKey = GlobalKey<FormState>();
  final _bloodTypeController = TextEditingController();
  final _allergyController = TextEditingController();
  final _conditionController = TextEditingController();
  final _historyController = TextEditingController();

  final List<String> _allergies = [];
  final List<String> _chronicConditions = [];
  final List<String> _medicalHistory = [];

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
  void dispose() {
    _bloodTypeController.dispose();
    _allergyController.dispose();
    _conditionController.dispose();
    _historyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Create Health Profile',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Blood Type',
                border: OutlineInputBorder(),
              ),
              items:
                  bloodTypes
                      .map(
                        (type) =>
                            DropdownMenuItem(value: type, child: Text(type)),
                      )
                      .toList(),
              onChanged: (value) {
                _bloodTypeController.text = value!;
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select your blood type';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildListInput(
              controller: _allergyController,
              label: 'Allergies',
              list: _allergies,
              onAdd: () {
                if (_allergyController.text.isNotEmpty) {
                  setState(() {
                    _allergies.add(_allergyController.text);
                    _allergyController.clear();
                  });
                }
              },
              onRemove: (index) {
                setState(() {
                  _allergies.removeAt(index);
                });
              },
            ),
            const SizedBox(height: 16),
            _buildListInput(
              controller: _conditionController,
              label: 'Chronic Conditions',
              list: _chronicConditions,
              onAdd: () {
                if (_conditionController.text.isNotEmpty) {
                  setState(() {
                    _chronicConditions.add(_conditionController.text);
                    _conditionController.clear();
                  });
                }
              },
              onRemove: (index) {
                setState(() {
                  _chronicConditions.removeAt(index);
                });
              },
            ),
            const SizedBox(height: 16),
            _buildListInput(
              controller: _historyController,
              label: 'Medical History',
              list: _medicalHistory,
              onAdd: () {
                if (_historyController.text.isNotEmpty) {
                  setState(() {
                    _medicalHistory.add(_historyController.text);
                    _historyController.clear();
                  });
                }
              },
              onRemove: (index) {
                setState(() {
                  _medicalHistory.removeAt(index);
                });
              },
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Create Profile'),
              ),
            ),
          ],
        ),
      ),
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

  void _submitForm() {
    if (_formKey.currentState!.validate() &&
        _bloodTypeController.text.isNotEmpty) {
      final profile = HealthProfile(
        bloodType: _bloodTypeController.text,
        allergies: _allergies,
        chronicConditions: _chronicConditions,
        medicalHistory: _medicalHistory,
      );
      context.read<HealthProfileBloc>().add(CreateHealthProfileEvent(profile));
    }
  }
}
