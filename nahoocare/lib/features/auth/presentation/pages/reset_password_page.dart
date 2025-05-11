import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/custom_button.dart';

import '../../../../core/widgets/custom_textfield.dart';
import '../blocs/auth_bloc.dart';
import '../widgets/auth_form.dart';
import '../widgets/password_field.dart';
import '../widgets/phone_number_field.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _secretAnswerController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? _secretQuestion;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reset Password'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            } else if (state is SecretQuestionLoaded) {
              setState(() {
                _secretQuestion = state.question;
              });
            } else if (state is PasswordResetSuccess) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
              Future.delayed(const Duration(seconds: 2), () {
                Navigator.pushNamed(context, '/login');
              });
            }
          },
          builder: (context, state) {
            return AuthForm(
              formKey: _formKey,
              submitButton: Column(
                children: [
                  if (_secretQuestion == null)
                    CustomButton(
                      text: 'Get Secret Question',
                      onPressed: () {
                        if (_phoneController.text.isNotEmpty) {
                          context.read<AuthBloc>().add(
                            GetSecretQuestionEvent(
                              phoneNumber: _phoneController.text,
                            ),
                          );
                        }
                      },
                    ),
                  if (_secretQuestion != null) ...[
                    const SizedBox(height: 16),
                    CustomButton(
                      text: 'Reset Password',
                      isLoading: state is AuthLoading,
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          context.read<AuthBloc>().add(
                            ResetPasswordEvent(
                              phoneNumber: _phoneController.text,
                              secretAnswer: _secretAnswerController.text,
                              newPassword: _newPasswordController.text,
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ],
              ),
              children: [
                PhoneNumberField(controller: _phoneController),
                if (_secretQuestion != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Secret Question:',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  Text(
                    _secretQuestion!,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _secretAnswerController,
                    labelText: 'Secret Answer',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your secret answer';
                      }
                      return null;
                    },
                  ),
                ],
                PasswordField(
                  controller: _newPasswordController,
                  labelText: 'New Password',
                  showStrengthIndicator: true,
                ),
                PasswordField(
                  controller: _confirmPasswordController,
                  labelText: 'Confirm New Password',
                  validator: (value) {
                    if (value != _newPasswordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _secretAnswerController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
