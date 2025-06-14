import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/health_profile.dart';
import '../bloc/health_profile_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

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
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Create Health Profile'.tr(),
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 24),

            DropdownButtonFormField<String>(
              decoration: _inputDecoration('Blood Type'.tr()),
              items:
                  bloodTypes.map((type) {
                    return DropdownMenuItem(value: type, child: Text(type));
                  }).toList(),
              onChanged: (value) => _bloodTypeController.text = value ?? '',
              validator:
                  (value) =>
                      (value == null || value.isEmpty)
                          ? 'Please select your blood type.tr()'
                          : null,
            ),

            const SizedBox(height: 24),
            _buildListInput(
              context,
              controller: _allergyController,
              label: 'Allergies'.tr(),
              list: _allergies,
              onAdd: () {
                if (_allergyController.text.isNotEmpty) {
                  setState(() {
                    _allergies.add(_allergyController.text.trim());
                    _allergyController.clear();
                  });
                }
              },
              onRemove: (index) => setState(() => _allergies.removeAt(index)),
            ),

            const SizedBox(height: 24),
            _buildListInput(
              context,
              controller: _conditionController,
              label: 'Chronic Conditions'.tr(),
              list: _chronicConditions,
              onAdd: () {
                if (_conditionController.text.isNotEmpty) {
                  setState(() {
                    _chronicConditions.add(_conditionController.text.trim());
                    _conditionController.clear();
                  });
                }
              },
              onRemove:
                  (index) => setState(() => _chronicConditions.removeAt(index)),
            ),

            const SizedBox(height: 24),
            _buildListInput(
              context,
              controller: _historyController,
              label: 'Medical History'.tr(),
              list: _medicalHistory,
              onAdd: () {
                if (_historyController.text.isNotEmpty) {
                  setState(() {
                    _medicalHistory.add(_historyController.text.trim());
                    _historyController.clear();
                  });
                }
              },
              onRemove:
                  (index) => setState(() => _medicalHistory.removeAt(index)),
            ),

            const SizedBox(height: 32),
            Center(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _submitForm,
                  icon: const Icon(
                    Icons.check_circle_outline,
                    color: Colors.white,
                  ),
                  label: Text(
                    'Create Profile'.tr(),
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(fontSize: 16),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListInput(
    BuildContext context, {
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
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: controller,
                decoration: _inputDecoration('add_label'.tr(args: [label])),

              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: onAdd,
              child: const Icon(Icons.add),
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(12),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: List.generate(list.length, (index) {
            return Chip(
              label: Text(list[index]),
              deleteIcon: const Icon(Icons.close),
              onDeleted: () => onRemove(index),
              backgroundColor: Theme.of(
                context,
              ).colorScheme.secondary.withOpacity(0.2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            );
          }),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Health profile created".tr())));
    }
  }
}
