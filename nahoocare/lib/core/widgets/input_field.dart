import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final String label;
  final String? initialValue;
  final bool obscureText;
  final bool readOnly;
  final String? errorText;
  final ValueChanged<String>? onChanged;

  const InputField({
    super.key,
    required this.label,
    this.initialValue,
    this.obscureText = false,
    this.readOnly = false,
    this.errorText,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      obscureText: obscureText,
      readOnly: readOnly,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        errorText: errorText,
      ),
      onChanged: onChanged,
    );
  }
}
