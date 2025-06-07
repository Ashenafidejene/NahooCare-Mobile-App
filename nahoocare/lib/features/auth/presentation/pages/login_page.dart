import 'package:flutter/material.dart';
import 'package:nahoocare/core/widgets/language_switcher.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../../../core/widgets/custom_button.dart';
import '../blocs/auth_bloc.dart';
import '../widgets/password_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String? _completePhoneNumber;
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('login'.tr()),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: LanguageSwitcher(),
          ),
          TextButton(
            onPressed: () => Navigator.pushNamed(context, '/landing'),
            child: Text(
              'skip'.tr(),
              style: const TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
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
                SnackBar(
                  content: Text('login_success'.tr()),
                  behavior: SnackBarBehavior.floating,
                ),
              );
              Future.delayed(const Duration(seconds: 3), () {
                Navigator.pushNamed(context, '/landing');
              });
            }
          },
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 30),
                Center(
                  child: Image.asset('assets/images/logo (2).png', height: 250),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    'welcome'.tr(),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
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
                          PasswordField(
                            controller: _passwordController,
                            labelText: 'password'.tr(),
                          ),
                          const SizedBox(height: 16),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed:
                                  () => Navigator.pushNamed(
                                    context,
                                    '/reset-password',
                                  ),
                              child: Text('forgot_password'.tr()),
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed:
                                  (state is AuthLoading)
                                      ? null
                                      : () {
                                        if (_formKey.currentState?.validate() ??
                                            false) {
                                          _formKey.currentState?.save();
                                          if (_completePhoneNumber != null) {
                                            context.read<AuthBloc>().add(
                                              LoginEvent(
                                                phoneNumber:
                                                    _completePhoneNumber!,
                                                password:
                                                    _passwordController.text,
                                              ),
                                            );
                                          } else {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  'please_enter_phone'.tr(),
                                                ),
                                              ),
                                            );
                                          }
                                        }
                                      },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Colors
                                        .blueAccent, // Set button color to blueAccent
                                foregroundColor:
                                    Colors.white, // Set text color to white
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                disabledBackgroundColor: Colors.blueAccent
                                    .withOpacity(0.7), // Disabled state color
                              ),
                              child:
                                  (state is AuthLoading)
                                      ? LoadingAnimationWidget.dotsTriangle(
                                        color: Colors.white,
                                        size: 30,
                                      )
                                      : Text(
                                        'login'.tr(),
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color:
                                              Colors
                                                  .white, // Ensure text is white
                                        ),
                                      ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("dont_have_account".tr()),
                              TextButton(
                                onPressed:
                                    () => Navigator.pushNamed(
                                      context,
                                      '/register',
                                    ),
                                child: Text('sign_up'.tr()),
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
    _passwordController.dispose();
    super.dispose();
  }
}
