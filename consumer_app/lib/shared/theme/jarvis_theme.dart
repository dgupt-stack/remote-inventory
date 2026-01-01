import 'package:flutter/material.dart';

class JarvisTheme {
  // JARVIS Color Palette
  static const Color primaryCyan = Color(0xFF00D9FF);
  static const Color darkBackground = Color(0xFF0A0E27);
  static const Color surfaceColor = Color(0xFF1A1F3A);
  static const Color accentBlue = Color(0xFF0080FF);
  static const Color warningRed = Color(0xFFFF0040);
  static const Color successGreen = Color(0xFF00FF88);

  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: primaryCyan,
        secondary: accentBlue,
        surface: surfaceColor,
        background: darkBackground,
        error: warningRed,
        onPrimary: darkBackground,
        onSecondary: Colors.white,
        onSurface: Colors.white,
        onBackground: Colors.white,
      ),
      scaffoldBackgroundColor: darkBackground,
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: primaryCyan,
          shadows: [
            Shadow(color: primaryCyan.withOpacity(0.5), blurRadius: 10),
          ],
        ),
        headlineMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: Colors.white.withOpacity(0.9),
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: Colors.white.withOpacity(0.7),
        ),
      ),
      cardTheme: CardThemeData(
        color: surfaceColor.withOpacity(0.6),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: primaryCyan.withOpacity(0.3), width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryCyan,
          foregroundColor: darkBackground,
          elevation: 8,
          shadowColor: primaryCyan.withOpacity(0.5),
          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryCyan.withOpacity(0.5)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryCyan.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryCyan, width: 2),
        ),
      ),
    );
  }

  // Glassmorphism effect
  static BoxDecoration glassEffect({Color? color}) {
    return BoxDecoration(
      color: (color ?? surfaceColor).withOpacity(0.15),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: primaryCyan.withOpacity(0.2), width: 1),
      boxShadow: [
        BoxShadow(
          color: primaryCyan.withOpacity(0.1),
          blurRadius: 20,
          spreadRadius: 2,
        ),
      ],
    );
  }

  // Neon glow effect
  static List<BoxShadow> neonGlow({Color? color}) {
    final glowColor = color ?? primaryCyan;
    return [
      BoxShadow(
        color: glowColor.withOpacity(0.6),
        blurRadius: 20,
        spreadRadius: 2,
      ),
      BoxShadow(
        color: glowColor.withOpacity(0.3),
        blurRadius: 40,
        spreadRadius: 4,
      ),
    ];
  }
}
