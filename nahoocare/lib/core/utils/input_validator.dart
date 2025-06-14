import 'package:easy_localization/easy_localization.dart';

class InputValidation {
  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required'.tr();
    }

    // Basic international phone number validation
    final phoneRegex = RegExp(r'^\+?[0-9]{8,15}$');
    if (!phoneRegex.hasMatch(value)) {
      return 'Enter a valid phone number'.tr();
    }

    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required'.tr();
    }

    if (value.length < 8) {
      return 'Password must be at least 8 characters'.tr();
    }

    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required'.tr();
    }

    if (value.length < 3) {
      return 'Name must be at least 3 characters'.tr();
    }

    return null;
  }

  static String? validateSecretAnswer(String? value) {
    if (value == null || value.isEmpty) {
      return 'Secret answer is required'.tr();
    }

    if (value.length < 3) {
      return 'Answer must be at least 3 characters'.tr();
    }

    return null;
  }

  static String? validateSecretQuestion(String? value) {
    if (value == null || value.isEmpty) {
      return 'Secret question is required'.tr();
    }

    if (value.length < 10) {
      return 'Question must be at least 10 characters'.tr();
    }

    return null;
  }
}
