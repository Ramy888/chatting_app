import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: const Color(0xFF075E54),
    scaffoldBackgroundColor: const Color(0xFF121B22),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1F2C34),
      elevation: 0,
    ),
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF00A884),
      secondary: Color(0xFF00A884),
      surface: Color(0xFF1F2C34),
      background: Color(0xFF121B22),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFF00A884),
    ),
  );
}