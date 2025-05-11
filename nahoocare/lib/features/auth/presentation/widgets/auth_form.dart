import 'package:flutter/material.dart';

class AuthForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final List<Widget> children;
  final Widget submitButton;
  final Widget? footer;

  const AuthForm({
    super.key,
    required this.formKey,
    required this.children,
    required this.submitButton,
    this.footer,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          const SizedBox(height: 24),
          ...children.map(
            (child) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: child,
            ),
          ),
          const SizedBox(height: 24),
          submitButton,
          if (footer != null) ...[const SizedBox(height: 16), footer!],
        ],
      ),
    );
  }
}
