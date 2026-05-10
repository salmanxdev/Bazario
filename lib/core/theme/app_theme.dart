import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF6C63FF); // Deep Purple
  static const Color accentColor = Color(0xFFFF6B6B); // Coral/Red
  static const Color blueColor = Color(0xFF4A90E2); // Blue for Buyer/links
  static const Color backgroundColor = Colors.white;
  static const Color scaffoldBackgroundColor = Color(0xFFF8F9FA);
  static const Color textPrimaryColor = Color(0xFF1F2937);
  static const Color textSecondaryColor = Color(0xFF6B7280);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        primary: primaryColor,
        secondary: accentColor,
        surface: backgroundColor,
      ),
      scaffoldBackgroundColor: scaffoldBackgroundColor,
      textTheme: GoogleFonts.poppinsTextTheme().copyWith(
        displayLarge: GoogleFonts.poppins(color: textPrimaryColor, fontWeight: FontWeight.bold),
        displayMedium: GoogleFonts.poppins(color: textPrimaryColor, fontWeight: FontWeight.bold),
        displaySmall: GoogleFonts.poppins(color: textPrimaryColor, fontWeight: FontWeight.bold),
        headlineLarge: GoogleFonts.poppins(color: textPrimaryColor, fontWeight: FontWeight.w700),
        headlineMedium: GoogleFonts.poppins(color: textPrimaryColor, fontWeight: FontWeight.w700),
        headlineSmall: GoogleFonts.poppins(color: textPrimaryColor, fontWeight: FontWeight.w600),
        titleLarge: GoogleFonts.poppins(color: textPrimaryColor, fontWeight: FontWeight.w600),
        titleMedium: GoogleFonts.poppins(color: textPrimaryColor, fontWeight: FontWeight.w500),
        titleSmall: GoogleFonts.poppins(color: textPrimaryColor, fontWeight: FontWeight.w500),
        bodyLarge: GoogleFonts.poppins(color: textPrimaryColor),
        bodyMedium: GoogleFonts.poppins(color: textSecondaryColor),
        bodySmall: GoogleFonts.poppins(color: textSecondaryColor),
        labelLarge: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        hintStyle: TextStyle(color: Colors.grey.shade400),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 2,
        shadowColor: Colors.black.withAlpha(13), // 0.05 * 255 = ~13
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
