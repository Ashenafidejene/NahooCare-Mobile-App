// Ensure this file contains the definition of ThemeState
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(InitialThemeState());
}

// Define ThemeState and its subclasses if missing
abstract class ThemeState {
  ThemeData get themeData;
}

class InitialThemeState extends ThemeState {
  @override
  ThemeData get themeData => ThemeData.light();
}
