import 'package:flutter/material.dart';

import '../../../../core/utils/input_validator.dart';
import '../../../../core/widgets/custom_textfield.dart';

class PasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final bool showStrengthIndicator;
  final String? Function(String?)? validator; // Added validator parameter
  const PasswordField({
    super.key,
    required this.controller,
    this.labelText = 'Password',
    this.showStrengthIndicator = false,
    this.validator,
  });

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          controller: widget.controller,
          labelText: widget.labelText,
          obscureText: _obscureText,
          validator: InputValidation.validatePassword,
          suffixIcon: IconButton(
            icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
            onPressed: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
          ),
        ),
        if (widget.showStrengthIndicator && widget.controller.text.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: LinearProgressIndicator(
              value: _calculatePasswordStrength(widget.controller.text),
              backgroundColor: Colors.grey[200],
              color: _getStrengthColor(widget.controller.text),
              minHeight: 4,
            ),
          ),
      ],
    );
  }

  double _calculatePasswordStrength(String password) {
    double strength = 0;
    if (password.length >= 8) strength += 0.3;
    if (password.contains(RegExp(r'[A-Z]'))) strength += 0.2;
    if (password.contains(RegExp(r'[0-9]'))) strength += 0.2;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) strength += 0.3;
    return strength.clamp(0, 1);
  }

  Color _getStrengthColor(String password) {
    final strength = _calculatePasswordStrength(password);
    if (strength < 0.4) return Colors.red;
    if (strength < 0.7) return Colors.orange;
    return Colors.green;
  }
}
