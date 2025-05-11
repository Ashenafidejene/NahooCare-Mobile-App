import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/utils/input_validator.dart';
import '../../../../core/widgets/custom_textfield.dart';

class PhoneNumberField extends StatelessWidget {
  final TextEditingController controller;

  const PhoneNumberField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: controller,
      labelText: 'Phone Number',
      keyboardType: TextInputType.phone,
      validator: InputValidation.validatePhoneNumber,
      suffixIcon: const Icon(Icons.phone),
    );
  }
}
