import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String? Function(String?)? validator;
  final bool showStrengthIndicator;
  final ValueChanged<String>? onChanged;

  const PasswordField({
    super.key,
    required this.controller,
    this.labelText = 'Password',
    this.validator,
    this.showStrengthIndicator = false,
    this.onChanged,
  });

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;
  double _passwordStrength = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: widget.controller,
          obscureText: _obscureText,
          decoration: InputDecoration(
            labelText: widget.labelText,
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _obscureText ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
            ),
          ),
          validator: widget.validator ?? _defaultValidator,
          onChanged: (value) {
            setState(() {
              _passwordStrength = _calculatePasswordStrength(value);
            });
            if (widget.onChanged != null) {
              widget.onChanged!(value);
            }
          },
        ),
        if (widget.showStrengthIndicator && widget.controller.text.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LinearProgressIndicator(
                  value: _passwordStrength,
                  backgroundColor: Colors.grey[200],
                  color: _getStrengthColor(),
                  minHeight: 4,
                ),
                const SizedBox(height: 4),
                Text(
                  _getStrengthText(),
                  style: TextStyle(fontSize: 12, color: _getStrengthColor()),
                ),
              ],
            ),
          ),
      ],
    );
  }

  String? _defaultValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    return null;
  }

  double _calculatePasswordStrength(String password) {
    double strength = 0;
    if (password.length >= 8) strength += 0.3;
    if (password.contains(RegExp(r'[A-Z]'))) strength += 0.2;
    if (password.contains(RegExp(r'[0-9]'))) strength += 0.2;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) strength += 0.3;
    return strength.clamp(0, 1);
  }

  Color _getStrengthColor() {
    if (_passwordStrength < 0.4) return Colors.red;
    if (_passwordStrength < 0.7) return Colors.orange;
    return Colors.green;
  }

  String _getStrengthText() {
    if (_passwordStrength < 0.4) return 'Weak';
    if (_passwordStrength < 0.7) return 'Medium';
    return 'Strong';
  }
}
