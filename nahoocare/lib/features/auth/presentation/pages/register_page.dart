import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart'; // Add this import

import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_textfield.dart';
import '../blocs/register_blocs/registration_flow_bloc.dart';
import '../widgets/password_field.dart';
import 'ProfilePhotoScreen.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _secretQuestionController = TextEditingController();
  final _secretAnswerController = TextEditingController();
  String? _completePhoneNumber;

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
        title: const Text('Register'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: BlocConsumer<RegistrationFlowBloc, RegistrationFlowState>(
          listener: (context, state) {
            if (state is RegistrationError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            } else if (state is ProfilePhotoRequired) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => ProfilePhotoScreen(
                        phoneNumber: _completePhoneNumber!,
                      ),
                ),
              );
            }
          },
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 16),
                const Center(
                  child: Icon(
                    Icons.app_registration,
                    size: 72,
                    color: Colors.blueAccent,
                  ),
                ),
                const SizedBox(height: 12),
                const Center(
                  child: Text(
                    'Create your account',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
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
                          CustomTextField(
                            controller: _nameController,
                            labelText: 'Full Name',
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter your full name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
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
                            validator: (phone) {
                              if (phone == null ||
                                  phone.completeNumber.isEmpty) {
                                return 'Please enter a phone number';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          PasswordField(
                            controller: _passwordController,
                            showStrengthIndicator: true,
                          ),
                          const SizedBox(height: 16),
                          PasswordField(
                            controller: _confirmPasswordController,
                            labelText: 'Confirm Password',
                            validator: (value) {
                              if (value != _passwordController.text) {
                                return 'Passwords do not match';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          CustomTextField(
                            controller: _secretQuestionController,
                            labelText: 'Secret Question',
                            maxLines: 2,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter a secret question';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          CustomTextField(
                            controller: _secretAnswerController,
                            labelText: 'Secret Answer',
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter a secret answer';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed:
                                  (state is RegistrationLoading)
                                      ? null
                                      : () {
                                        if (!(_formKey.currentState
                                                ?.validate() ??
                                            false)) {
                                          return;
                                        }
                                        _formKey.currentState?.save();
                                        if (_completePhoneNumber == null) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Please enter a phone number',
                                              ),
                                            ),
                                          );
                                          return;
                                        }
                                        context
                                            .read<RegistrationFlowBloc>()
                                            .add(
                                              SubmitBasicInfoEvent(
                                                fullName: _nameController.text,
                                                phoneNumber:
                                                    _completePhoneNumber!,
                                                password:
                                                    _passwordController.text,
                                                secretQuestion:
                                                    _secretQuestionController
                                                        .text,
                                                secretAnswer:
                                                    _secretAnswerController
                                                        .text,
                                              ),
                                            );
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
                                  (state is RegistrationLoading)
                                      ? LoadingAnimationWidget.dotsTriangle(
                                        color: Colors.white,
                                        size: 30,
                                      )
                                      : const Text(
                                        'Continue',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Already have an account?'),
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Login'),
                              ),
                            ],
                          ),
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
    _nameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _secretQuestionController.dispose();
    _secretAnswerController.dispose();
    super.dispose();
  }
}
