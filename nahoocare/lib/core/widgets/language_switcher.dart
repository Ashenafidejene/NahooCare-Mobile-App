import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class LanguageSwitcher extends StatelessWidget {
  const LanguageSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.language),
      tooltip: 'Switch Language',
      onPressed: () {
        final currentLocale = context.locale;
        final newLocale =
            currentLocale.languageCode == 'en'
                ? const Locale('am')
                : const Locale('en');

        context.setLocale(newLocale);
      },
    );
  }
}
