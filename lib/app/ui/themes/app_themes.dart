/// \[AppThemes\] is a utility class that provides predefined light and dark themes
/// for the application. These themes include configurations for colors, text styles,
/// and other visual properties to ensure consistent UI design.

import 'package:bethel_farm/core/app_colors/app_colors.dart';
import 'package:flutter/material.dart';

class AppThemes {
  static ThemeData light = lightTheme;
  static ThemeData dark = darkTheme;
}

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: AppColors.colorPrimary,
  primarySwatch: AppColors.colorPrimarySwatch,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  textTheme: const TextTheme(
    labelLarge: TextStyle(
      color: Colors.white,
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
    ),
  ),
  fontFamily: 'Roboto',
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: AppColors.colorPrimarySwatch,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  scaffoldBackgroundColor: Colors.black,
  primaryColor: AppColors.colorPrimary,
  textTheme: const TextTheme(
    labelLarge: TextStyle(
      color: Colors.white,
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
    ),
  ),
  fontFamily: 'Roboto',
);
