import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:easy_localization/easy_localization.dart';

class PhoneNumberField extends StatelessWidget {
  final TextEditingController controller;

  const PhoneNumberField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return IntlPhoneField(
      controller: controller,
      decoration: InputDecoration(
        labelText: 'Phone Number'.tr(),
        border: OutlineInputBorder(),
      ),
      initialCountryCode: 'ET', // Change to your preferred default country
      onChanged: (phone) {
        print('Phone number changed: ${phone.completeNumber}'.tr());
      },
      onCountryChanged: (country) {
        print('Country changed to: ${country.name}'.tr());
      },
    );
  }
}
