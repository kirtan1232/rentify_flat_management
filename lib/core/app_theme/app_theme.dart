// lib/core/app_theme/app_theme.dart
import 'package:flutter/material.dart';

class AppThemes {
  static ThemeData getLightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      primarySwatch: Colors.orange,
      scaffoldBackgroundColor: Colors.grey[200],
      fontFamily: 'Montserrat Regular',
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          textStyle: const TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontFamily: 'Montserrat Bold',
          ),
          backgroundColor: Colors.green,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
        ),
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        color: Color.fromARGB(255, 77, 187, 117),
        elevation: 4,
        titleTextStyle: TextStyle(
          fontSize: 16,
          color: Color(0xff00FF00),
          fontWeight: FontWeight.bold,
        ),
      ),
      textTheme: const TextTheme(
        bodyMedium: TextStyle(color: Colors.black87),
        headlineSmall: TextStyle(color: Colors.black87),
      ),
      cardTheme: const CardTheme(
        color: Colors.white,
        elevation: 2,
      ),
      iconTheme: const IconThemeData(color: Colors.black54),
      inputDecorationTheme: const InputDecorationTheme(
        labelStyle: TextStyle(color: Colors.black87),
        hintStyle: TextStyle(color: Colors.grey),
      ),
    );
  }

  static ThemeData getDarkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.orange,
      scaffoldBackgroundColor: Colors.grey[900],
      fontFamily: 'Montserrat Regular',
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          textStyle: const TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontFamily: 'Montserrat Bold',
          ),
          backgroundColor: Colors.green,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
        ),
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        color: Colors.black,
        elevation: 4,
        titleTextStyle: TextStyle(
          fontSize: 16,
          color: Color(0xff00FF00),
          fontWeight: FontWeight.bold,
        ),
      ),
      textTheme: const TextTheme(
        bodyMedium: TextStyle(color: Colors.white),
        headlineSmall: TextStyle(color: Colors.white),
      ),
      cardTheme: CardTheme(
        color: Colors.grey[800],
        elevation: 2,
      ),
      iconTheme: const IconThemeData(color: Colors.white),
      inputDecorationTheme: const InputDecorationTheme(
        labelStyle: TextStyle(color: Colors.white),
        hintStyle: TextStyle(color: Colors.grey),
      ),
    );
  }
}
