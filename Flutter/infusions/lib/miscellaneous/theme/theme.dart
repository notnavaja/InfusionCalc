import 'package:flutter/material.dart';

// Light theme
ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  fontFamily: 'Inter',
  primaryColor: Colors.blue.shade700,
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.blue.shade800,
    elevation: 0,
    titleTextStyle: const TextStyle(
      color: Colors.white,
      fontSize: 22,
      fontWeight: FontWeight.w600,
    ),
    iconTheme: const IconThemeData(color: Colors.white),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.blue.shade700,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    hintStyle: TextStyle(
      color: Colors.grey
    ),
    fillColor: Colors.grey.shade50,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: BorderSide(color: Colors.grey.shade300),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: BorderSide(color: Colors.grey.shade300),
    ),
    labelStyle: TextStyle(color: Colors.grey.shade700),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.blue.shade700, width: 2),
      borderRadius: BorderRadius.circular(12.0),
    ),
  ),
  textTheme: ThemeData.light().textTheme.copyWith(
    bodyLarge: TextStyle(color: Colors.grey.shade900),
    bodyMedium: TextStyle(color: Colors.grey.shade800),
    titleLarge: TextStyle(color: Colors.grey.shade900),
    titleMedium: TextStyle(color: Colors.grey.shade800),
    headlineSmall: TextStyle(color: Colors.blue.shade900, fontWeight: FontWeight.bold),
    bodySmall: TextStyle(color: Colors.grey.shade600, fontSize: 12),
  ),
  colorScheme: ColorScheme.light(
    primary: Colors.blue.shade700,
    secondary: Colors.blue.shade500,
    surface: Colors.white,
    error: Colors.red.shade700,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: Colors.grey.shade900,
    onError: Colors.white,
    brightness: Brightness.light,
  ),
  iconTheme: IconThemeData(color: Colors.blue.shade700),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Colors.blue.shade700,
    foregroundColor: Colors.white,
    elevation: 4,
  ),
  cardColor: Colors.white,
  dividerColor: Colors.grey.shade200,
  listTileTheme: ListTileThemeData(
    tileColor: Colors.white,
    titleTextStyle: TextStyle(color: Colors.grey.shade900, fontWeight: FontWeight.w500),
    subtitleTextStyle: TextStyle(color: Colors.grey.shade600),
    iconColor: Colors.blue.shade700,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0),
      side: BorderSide(color: Colors.grey.shade100),
    ),
    selectedColor: Colors.blue.shade700,
    selectedTileColor: Colors.blue.shade50,
  ),
);

// Dark theme
ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  fontFamily: 'Inter', 
  primaryColor: Colors.blue.shade900,
  scaffoldBackgroundColor: const Color(0xFF121212),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF1E1E1E),
    elevation: 0,
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 22,
      fontWeight: FontWeight.w600,
    ),
    iconTheme: IconThemeData(color: Colors.white),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.blue.shade700,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    hintStyle: TextStyle(
      color: Colors.grey
    ),
    fillColor: const Color(0xFF1E1E1E),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: BorderSide(color: Colors.grey.shade800),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: BorderSide(color: Colors.grey.shade800),
    ),
    labelStyle: const TextStyle(color: Colors.white70),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.blue.shade500, width: 2),
      borderRadius: BorderRadius.circular(12.0),
    ),
  ),
  textTheme: ThemeData.dark().textTheme.copyWith(
    bodyLarge: const TextStyle(color: Colors.white),
    bodyMedium: const TextStyle(color: Colors.white70),
    headlineSmall: TextStyle(color: Colors.blue.shade300, fontWeight: FontWeight.bold),
    bodySmall: TextStyle(color: Colors.grey.shade400, fontSize: 12),
  ),
  colorScheme: ColorScheme.dark(
    primary: Colors.blue.shade500,
    secondary: Colors.blue.shade700,
    surface: const Color(0xFF1E1E1E),
    error: Colors.redAccent.shade400,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: Colors.white,
    onError: Colors.black,
    brightness: Brightness.dark,
  ),
  iconTheme: const IconThemeData(color: Colors.white70),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Colors.blue.shade600,
    foregroundColor: Colors.white,
  ),
  cardColor: const Color(0xFF1E1E1E),
  dividerColor: Colors.grey.shade800,
  listTileTheme: ListTileThemeData(
    tileColor: const Color(0xFF1E1E1E),
    titleTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
    subtitleTextStyle: TextStyle(color: Colors.grey.shade400),
    iconColor: Colors.blue.shade400,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0),
      side: BorderSide(color: Colors.grey.shade800),
    ),
    selectedColor: Colors.blue.shade300,
    selectedTileColor: Colors.blue.shade900.withAlpha(80),
  ),
);