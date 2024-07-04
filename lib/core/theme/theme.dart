import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/core/theme/app_pallete.dart';

class AppTheme {
  static final lightTheme = ThemeData.light().copyWith(
      colorScheme: ColorScheme.fromSeed(
          seedColor: AppPallete.primaryColor,
          secondary: AppPallete.secondaryColor),
      brightness: Brightness.light,
      primaryColor: AppPallete.primaryColor,
      scaffoldBackgroundColor: Colors.white,
      textTheme: GoogleFonts.montserratTextTheme().apply(
        bodyColor: Colors.black,
        displayColor: Colors.black,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ));

  static ThemeData darkTheme = ThemeData.dark().copyWith(
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppPallete.primaryColor,
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: AppPallete.darkBackGroundColor,
      textTheme: GoogleFonts.montserratTextTheme().apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ));
}
