import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_textfield.dart';
import '../blocs/auth_bloc.dart';
import '../widgets/password_field.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _secretAnswerController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String? _completePhoneNumber;
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
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                const Center(
                  child: Icon(
                    Icons.lock_reset,
                    size: 72,
                    color: Colors.deepPurple,
                  ),
                ),
                const SizedBox(height: 16),
                const Center(
                  child: Text(
                    'Reset Your Password',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          IntlPhoneField(
                            decoration: const InputDecoration(
                              labelText: 'Phone Number',
                              border: OutlineInputBorder(),
                            ),
                            initialCountryCode: 'ET',
                            onChanged: (phone) {
                              _completePhoneNumber = phone.completeNumber;
                            },
                            onSaved: (phone) {
                              _completePhoneNumber = phone?.completeNumber;
                            },
                          ),
                          const SizedBox(height: 16),
                          if (_secretQuestion == null)
                            CustomButton(
                              text: 'Get Secret Question',
                              onPressed: () {
                                if (_completePhoneNumber != null &&
                                    _completePhoneNumber!.isNotEmpty) {
                                  context.read<AuthBloc>().add(
                                    GetSecretQuestionEvent(
                                      phoneNumber: _completePhoneNumber!,
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Please enter a valid phone number',
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                          if (_secretQuestion != null) ...[
                            const SizedBox(height: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Secret Question:',
                                  style: Theme.of(context).textTheme.labelLarge
                                      ?.copyWith(fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    _secretQuestion!,
                                    style: Theme.of(context).textTheme.bodyLarge
                                        ?.copyWith(fontSize: 16),
                                  ),
                                ),
                              ],
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
                            const SizedBox(height: 16),
                            PasswordField(
                              controller: _newPasswordController,
                              labelText: 'New Password',
                              showStrengthIndicator: true,
                            ),
                            const SizedBox(height: 16),
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
                            const SizedBox(height: 20),
                            CustomButton(
                              text: 'Reset Password',
                              isLoading: state is AuthLoading,
                              onPressed: () {
                                if (_formKey.currentState?.validate() ??
                                    false) {
                                  _formKey.currentState?.save();

                                  if (_completePhoneNumber == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Please enter your phone number',
                                        ),
                                      ),
                                    );
                                    return;
                                  }

                                  context.read<AuthBloc>().add(
                                    ResetPasswordEvent(
                                      phoneNumber: _completePhoneNumber!,
                                      secretAnswer:
                                          _secretAnswerController.text,
                                      newPassword: _newPasswordController.text,
                                    ),
                                  );
                                }
                              },
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
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
    _secretAnswerController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
