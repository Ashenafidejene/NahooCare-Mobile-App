import 'package:flutter/material.dart';
import 'app_colors.dart';

final ThemeData appTheme = ThemeData.dark().copyWith(
  scaffoldBackgroundColor: AppColors.backgroundColor,
  primaryColor: AppColors.buttonColor,
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.white),
    titleMedium: TextStyle(color: Colors.white),
  ),
);
