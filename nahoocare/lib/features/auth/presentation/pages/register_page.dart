import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

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
          ),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: Text('register'.tr()),
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
                Center(
                  child: Text(
                    'create_account'.tr(),
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
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
                          CustomTextField(
                            controller: _nameController,
                            labelText: 'full_name'.tr(),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'enter_full_name'.tr();
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
                                return 'enter_phone_number'.tr();
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
                            labelText: 'confirm_password'.tr(),
                            validator: (value) {
                              if (value != _passwordController.text) {
                                return 'password_mismatch'.tr();
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          CustomTextField(
                            controller: _secretQuestionController,
                            labelText: 'secret_question'.tr(),
                            maxLines: 2,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'enter_secret_question'.tr();
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          CustomTextField(
                            controller: _secretAnswerController,
                            labelText: 'secret_answer'.tr(),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'enter_secret_answer'.tr();
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
                                            false))
                                          return;
                                        _formKey.currentState?.save();
                                        if (_completePhoneNumber == null) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'enter_phone_number'.tr(),
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
                                      : Text(
                                        'continue'.tr(),
                                        style: const TextStyle(
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
                              Text('already_have_account'.tr()),
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text('login'.tr()),
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
