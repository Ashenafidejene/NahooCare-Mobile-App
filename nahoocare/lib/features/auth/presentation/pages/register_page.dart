import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nahoocare/features/auth/presentation/blocs/auth_bloc.dart';
import '../../../../core/widgets/custom_button.dart';

import '../../../../core/widgets/custom_textfield.dart';
import '../widgets/auth_form.dart';
import '../widgets/password_field.dart';
import '../widgets/phone_number_field.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _secretQuestionController = TextEditingController();
  final _secretAnswerController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            } else if (state is RegisterSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Registration successful! Please login.'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
              Future.delayed(const Duration(seconds: 2), () {
                Navigator.pushNamed(context, '/login');
              });
            }
          },
          builder: (context, state) {
            return AuthForm(
              formKey: _formKey,
              submitButton: CustomButton(
                text: 'Register',
                isLoading: state is AuthLoading,
                onPressed: () {
                  final isValid = _formKey.currentState?.validate() ?? false;
                  final password = _passwordController.text;
                  final confirmPassword = _confirmPasswordController.text;

                  if (!isValid) return;

                  if (password != confirmPassword) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Passwords do not match'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                    return;
                  }
                  context.read<AuthBloc>().add(
                    RegisterEvent(
                      fullName: _nameController.text,
                      phoneNumber: _phoneController.text,
                      password: password,
                      secretQuestion: _secretQuestionController.text,
                      secretAnswer: _secretAnswerController.text,
                    ),
                  );
                },
              ),
              footer: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Already have an account?'),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Login'),
                  ),
                ],
              ),
              children: [
                CustomTextField(
                  controller: _nameController,
                  labelText: 'Full Name',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your full name';
                    }
                    return null;
                  },
                ),
                PhoneNumberField(controller: _phoneController),
                PasswordField(
                  controller: _passwordController,
                  showStrengthIndicator: true,
                ),
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
                CustomTextField(
                  controller: _secretQuestionController,
                  labelText: 'Secret Question',
                  maxLines: 2,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a secret question';
                    }
                    return null;
                  },
                ),
                CustomTextField(
                  controller: _secretAnswerController,
                  labelText: 'Secret Answer',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a secret answer';
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
    _nameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _secretQuestionController.dispose();
    _secretAnswerController.dispose();
    super.dispose();
  }
}
