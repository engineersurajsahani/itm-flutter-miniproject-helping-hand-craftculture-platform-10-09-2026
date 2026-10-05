import 'package:flutter/material.dart';

/// ============================================================================
/// VIVA EXPLANATION HEADER
/// CONCEPT: Practical 9 - Themes & Custom Styling (ThemeData, Material 3)
/// LOGIC  : Defines a centralized color palette, custom fonts, button styles,
///          and card themes for the CraftCulture app.
/// VIVA TIP: Why use ThemeData? 
///          - Ensures consistent UI design across all screens.
///          - Enables dark/light mode easily and prevents hardcoded colors.
/// ============================================================================
class AppTheme {
  // Brand Color Palette representing artisanal heritage (terracotta, indigo, gold)
  static const Color primaryCraft = Color(0xFFC85A32);    // Terracotta Clay
  static const Color secondaryCraft = Color(0xFF2C5E43);  // Forest Green / Eco
  static const Color accentGold = Color(0xFFD4A373);       // Handloom Gold
  static const Color backgroundLight = Color(0xFFFAF7F2);  // Warm Cotton White
  static const Color cardBg = Color(0xFFFFFFFF);           // Clean Card Background
  static const Color textDark = Color(0xFF2D2321);         // Deep Charcoal
  static const Color textMuted = Color(0xFF756A63);        // Muted Warm Grey
  static const Color welfareFundColor = Color(0xFF3B82F6); // Welfare Blue
  static const Color materialPoolColor = Color(0xFF10B981);// Raw Material Green

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: backgroundLight,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryCraft,
        primary: primaryCraft,
        secondary: secondaryCraft,
        surface: cardBg,
      ),
      fontFamily: 'Roboto',
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryCraft,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          letterSpacing: 0.5,
        ),
      ),
      cardTheme: CardThemeData(
        color: cardBg,
        elevation: 2,
        shadowColor: primaryCraft.withOpacity(0.12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryCraft,
          foregroundColor: Colors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryCraft,
          side: const BorderSide(color: primaryCraft, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE2D9D2)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE2D9D2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryCraft, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryCraft,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
    );
  }
}
