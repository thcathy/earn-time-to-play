import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

class AppTheme {
  AppTheme._();

  static final _baseTextTheme = GoogleFonts.interTextTheme();

  /// Light theme - warm, clean, peaceful
  static ThemeData light = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      background: AppColors.lightBackground,
      surface: AppColors.lightSurface,
      surfaceVariant: AppColors.lightSurfaceVariant,
      primary: AppColors.focusLight,
      secondary: AppColors.playLight,
      onBackground: AppColors.lightText,
      onSurface: AppColors.lightText,
      outline: AppColors.lightBorder,
    ),
    scaffoldBackgroundColor: AppColors.lightBackground,
    textTheme: _baseTextTheme.copyWith(
      displayLarge: _baseTextTheme.displayLarge?.copyWith(
        color: AppColors.lightText,
        fontWeight: FontWeight.w600,
      ),
      displayMedium: _baseTextTheme.displayMedium?.copyWith(
        color: AppColors.lightText,
        fontWeight: FontWeight.w600,
      ),
      displaySmall: _baseTextTheme.displaySmall?.copyWith(
        color: AppColors.lightText,
        fontWeight: FontWeight.w600,
      ),
      headlineLarge: _baseTextTheme.headlineLarge?.copyWith(
        color: AppColors.lightText,
        fontWeight: FontWeight.w600,
      ),
      headlineMedium: _baseTextTheme.headlineMedium?.copyWith(
        color: AppColors.lightText,
        fontWeight: FontWeight.w600,
      ),
      headlineSmall: _baseTextTheme.headlineSmall?.copyWith(
        color: AppColors.lightText,
        fontWeight: FontWeight.w500,
      ),
      titleLarge: _baseTextTheme.titleLarge?.copyWith(
        color: AppColors.lightText,
        fontWeight: FontWeight.w500,
      ),
      titleMedium: _baseTextTheme.titleMedium?.copyWith(
        color: AppColors.lightText,
        fontWeight: FontWeight.w500,
      ),
      titleSmall: _baseTextTheme.titleSmall?.copyWith(
        color: AppColors.lightTextSecondary,
        fontWeight: FontWeight.w500,
      ),
      bodyLarge: _baseTextTheme.bodyLarge?.copyWith(
        color: AppColors.lightText,
      ),
      bodyMedium: _baseTextTheme.bodyMedium?.copyWith(
        color: AppColors.lightText,
      ),
      bodySmall: _baseTextTheme.bodySmall?.copyWith(
        color: AppColors.lightTextSecondary,
      ),
      labelLarge: _baseTextTheme.labelLarge?.copyWith(
        color: AppColors.lightText,
        fontWeight: FontWeight.w500,
      ),
      labelMedium: _baseTextTheme.labelMedium?.copyWith(
        color: AppColors.lightTextSecondary,
      ),
      labelSmall: _baseTextTheme.labelSmall?.copyWith(
        color: AppColors.lightTextSecondary,
      ),
    ),
    cardTheme: CardThemeData(
      color: AppColors.lightSurface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppColors.lightBorder.withValues(alpha: 0.5)),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        side: BorderSide(color: AppColors.lightBorder),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.lightSurfaceVariant,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.focusLight, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.lightSurface,
      selectedItemColor: AppColors.focusLight,
      unselectedItemColor: AppColors.lightTextSecondary,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.lightBackground,
      foregroundColor: AppColors.lightText,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: _baseTextTheme.titleLarge?.copyWith(
        color: AppColors.lightText,
        fontWeight: FontWeight.w600,
      ),
    ),
    dividerTheme: DividerThemeData(
      color: AppColors.lightBorder,
      thickness: 1,
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.focusLight;
        }
        return AppColors.lightTextSecondary;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.focusLightSoft;
        }
        return AppColors.lightBorder;
      }),
    ),
  );

  /// Dark theme - calm, focused, easy on eyes
  static ThemeData dark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      background: AppColors.darkBackground,
      surface: AppColors.darkSurface,
      surfaceVariant: AppColors.darkSurfaceVariant,
      primary: AppColors.focusDark,
      secondary: AppColors.playDark,
      onBackground: AppColors.darkText,
      onSurface: AppColors.darkText,
      outline: AppColors.darkBorder,
    ),
    scaffoldBackgroundColor: AppColors.darkBackground,
    textTheme: _baseTextTheme.copyWith(
      displayLarge: _baseTextTheme.displayLarge?.copyWith(
        color: AppColors.darkText,
        fontWeight: FontWeight.w600,
      ),
      displayMedium: _baseTextTheme.displayMedium?.copyWith(
        color: AppColors.darkText,
        fontWeight: FontWeight.w600,
      ),
      displaySmall: _baseTextTheme.displaySmall?.copyWith(
        color: AppColors.darkText,
        fontWeight: FontWeight.w600,
      ),
      headlineLarge: _baseTextTheme.headlineLarge?.copyWith(
        color: AppColors.darkText,
        fontWeight: FontWeight.w600,
      ),
      headlineMedium: _baseTextTheme.headlineMedium?.copyWith(
        color: AppColors.darkText,
        fontWeight: FontWeight.w600,
      ),
      headlineSmall: _baseTextTheme.headlineSmall?.copyWith(
        color: AppColors.darkText,
        fontWeight: FontWeight.w500,
      ),
      titleLarge: _baseTextTheme.titleLarge?.copyWith(
        color: AppColors.darkText,
        fontWeight: FontWeight.w500,
      ),
      titleMedium: _baseTextTheme.titleMedium?.copyWith(
        color: AppColors.darkText,
        fontWeight: FontWeight.w500,
      ),
      titleSmall: _baseTextTheme.titleSmall?.copyWith(
        color: AppColors.darkTextSecondary,
        fontWeight: FontWeight.w500,
      ),
      bodyLarge: _baseTextTheme.bodyLarge?.copyWith(
        color: AppColors.darkText,
      ),
      bodyMedium: _baseTextTheme.bodyMedium?.copyWith(
        color: AppColors.darkText,
      ),
      bodySmall: _baseTextTheme.bodySmall?.copyWith(
        color: AppColors.darkTextSecondary,
      ),
      labelLarge: _baseTextTheme.labelLarge?.copyWith(
        color: AppColors.darkText,
        fontWeight: FontWeight.w500,
      ),
      labelMedium: _baseTextTheme.labelMedium?.copyWith(
        color: AppColors.darkTextSecondary,
      ),
      labelSmall: _baseTextTheme.labelSmall?.copyWith(
        color: AppColors.darkTextSecondary,
      ),
    ),
    cardTheme: CardThemeData(
      color: AppColors.darkSurface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppColors.darkBorder.withValues(alpha: 0.5)),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        side: BorderSide(color: AppColors.darkBorder),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.darkSurfaceVariant,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.focusDark, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.darkSurface,
      selectedItemColor: AppColors.focusDark,
      unselectedItemColor: AppColors.darkTextSecondary,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.darkBackground,
      foregroundColor: AppColors.darkText,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: _baseTextTheme.titleLarge?.copyWith(
        color: AppColors.darkText,
        fontWeight: FontWeight.w600,
      ),
    ),
    dividerTheme: DividerThemeData(
      color: AppColors.darkBorder,
      thickness: 1,
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.focusDark;
        }
        return AppColors.darkTextSecondary;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.focusDarkSoft.withValues(alpha: 0.5);
        }
        return AppColors.darkBorder;
      }),
    ),
  );
}

