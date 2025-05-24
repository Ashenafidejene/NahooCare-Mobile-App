import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/custom_button.dart';

import '../blocs/auth_bloc.dart';
import '../widgets/auth_form.dart';
import '../widgets/password_field.dart';
import '../widgets/phone_number_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            } else if (state is LoginSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Registration successful! Please login.'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
              Future.delayed(const Duration(seconds: 2), () {
                Navigator.pushNamed(context, '/landing');
              });
            }
          },
          builder: (context, state) {
            return AuthForm(
              formKey: _formKey,
              submitButton: CustomButton(
                text: 'Login',
                isLoading: state is AuthLoading,
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    context.read<AuthBloc>().add(
                      LoginEvent(
                        phoneNumber: _phoneController.text,
                        password: _passwordController.text,
                      ),
                    );
                  }
                },
              ),
              footer: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account?"),
                  TextButton(
                    onPressed: () => Navigator.pushNamed(context, '/register'),
                    child: const Text('Sign Up'),
                  ),
                ],
              ),
              children: [
                PhoneNumberField(controller: _phoneController),
                PasswordField(controller: _passwordController),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed:
                        () => Navigator.pushNamed(context, '/reset-password'),
                    child: const Text('Forgot Password?'),
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
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
