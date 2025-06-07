import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart'; // Add this import
import 'package:nahoocare/core/widgets/custom_button.dart';
import 'package:nahoocare/core/widgets/custom_textfield.dart';
import 'package:nahoocare/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:nahoocare/features/auth/presentation/widgets/password_field.dart';
import 'package:nahoocare/core/widgets/language_switcher.dart';
import 'package:easy_localization/easy_localization.dart';

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
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.chevron_left,
            size: 30,
            color: Colors.blueAccent,
          ), // Larger back icon
          onPressed: () => Navigator.maybePop(context), // Safer pop
        ),
        title: Text('Reset Password'.tr()),
        centerTitle: true,
        actions: const [LanguageSwitcher()],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message.tr())));
            } else if (state is SecretQuestionLoaded) {
              setState(() {
                _secretQuestion = state.question;
              });
            } else if (state is PasswordResetSuccess) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message.tr())));
              Future.delayed(const Duration(seconds: 2), () {
                Navigator.pushNamed(context, '/login');
              });
            }
          },
          builder: (context, state) {
            return Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  const Center(
                    child: Icon(
                      Icons.lock_reset,
                      size: 72,
                      color: Colors.blueAccent,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Text(
                      'Reset Your Password'.tr(),
                      style: const TextStyle(
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
                      child: Column(
                        children: [
                          IntlPhoneField(
                            decoration: InputDecoration(
                              labelText: 'phone_number'.tr(),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 2,
                                ),
                              ),
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
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed:
                                    (state is AuthLoading)
                                        ? null
                                        : () {
                                          if (_completePhoneNumber
                                                  ?.isNotEmpty ??
                                              false) {
                                            context.read<AuthBloc>().add(
                                              GetSecretQuestionEvent(
                                                phoneNumber:
                                                    _completePhoneNumber!,
                                              ),
                                            );
                                          } else {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  'Please enter a valid phone number'
                                                      .tr(),
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueAccent,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  disabledBackgroundColor: Colors.blueAccent
                                      .withOpacity(0.7),
                                ),
                                child:
                                    (state is AuthLoading &&
                                            state is! SecretQuestionLoaded)
                                        ? LoadingAnimationWidget.dotsTriangle(
                                          color: Colors.white,
                                          size: 30,
                                        )
                                        : Text(
                                          'Get Secret Question'.tr(),
                                          style: const TextStyle(fontSize: 16),
                                        ),
                              ),
                            ),
                          if (_secretQuestion != null) ...[
                            const SizedBox(height: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Secret Question:'.tr(),
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
                                    _secretQuestion!.tr(),
                                    style: Theme.of(context).textTheme.bodyLarge
                                        ?.copyWith(fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            CustomTextField(
                              controller: _secretAnswerController,
                              labelText: 'Secret Answer'.tr(),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your secret answer'.tr();
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            PasswordField(
                              controller: _newPasswordController,
                              labelText: 'New Password'.tr(),
                              showStrengthIndicator: true,
                            ),
                            const SizedBox(height: 16),
                            PasswordField(
                              controller: _confirmPasswordController,
                              labelText: 'Confirm New Password'.tr(),
                              validator: (value) {
                                if (value != _newPasswordController.text) {
                                  return 'Passwords do not match'.tr();
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed:
                                    (state is AuthLoading)
                                        ? null
                                        : () {
                                          if (_formKey.currentState
                                                  ?.validate() ??
                                              false) {
                                            _formKey.currentState?.save();

                                            if (_completePhoneNumber == null) {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    'Please enter your phone number'
                                                        .tr(),
                                                  ),
                                                ),
                                              );
                                              return;
                                            }

                                            context.read<AuthBloc>().add(
                                              ResetPasswordEvent(
                                                phoneNumber:
                                                    _completePhoneNumber!,
                                                secretAnswer:
                                                    _secretAnswerController
                                                        .text,
                                                newPassword:
                                                    _newPasswordController.text,
                                              ),
                                            );
                                          }
                                        },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueAccent,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  disabledBackgroundColor: Colors.blueAccent
                                      .withOpacity(0.7),
                                ),
                                child:
                                    (state is AuthLoading)
                                        ? LoadingAnimationWidget.dotsTriangle(
                                          color: Colors.white,
                                          size: 30,
                                        )
                                        : Text(
                                          'Reset Password'.tr(),
                                          style: const TextStyle(fontSize: 16),
                                        ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
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
