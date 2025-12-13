import 'package:flutter/material.dart';

/// App color palette - Blue & Orange (matching icon) with peaceful, soft tones
class AppColors {
  AppColors._();

  // Light Mode Colors
  static const lightBackground = Color(0xFFFAFAF9);
  static const lightSurface = Colors.white;
  static const lightSurfaceVariant = Color(0xFFF4F4F5);
  static const lightText = Color(0xFF374151);
  static const lightTextSecondary = Color(0xFF6B7280);
  static const lightBorder = Color(0xFFE5E7EB);

  // Dark Mode Colors - calm and easy on eyes
  static const darkBackground = Color(0xFF111827);
  static const darkSurface = Color(0xFF1F2937);
  static const darkSurfaceVariant = Color(0xFF374151);
  static const darkText = Color(0xFFF3F4F6);
  static const darkTextSecondary = Color(0xFF9CA3AF);
  static const darkBorder = Color(0xFF4B5563);

  // Focus Colors (Peaceful Blue - calm, focused)
  static const focusLight = Color(0xFF4B8BD4);     // Soft sky blue
  static const focusLightSoft = Color(0xFF93C5FD);
  static const focusLightBg = Color(0xFFE0EFFF);
  static const focusDark = Color(0xFF60A5FA);      // Gentle blue
  static const focusDarkSoft = Color(0xFF93C5FD);
  static const focusDarkBg = Color(0xFF1E3A5F);

  // Play Colors (Peaceful Orange - warm, gentle)
  static const playLight = Color(0xFFE07B4C);      // Soft coral/terracotta
  static const playLightSoft = Color(0xFFFDB38A);
  static const playLightBg = Color(0xFFFFF4ED);
  static const playDark = Color(0xFFFB923C);       // Warm amber
  static const playDarkSoft = Color(0xFFFDBA74);
  static const playDarkBg = Color(0xFF5C3D2E);

  // Accent Colors
  static const accentTeal = Color(0xFF5EAAA8);
  static const accentAmber = Color(0xFFDEB779);
  static const accentPink = Color(0xFFD4A5A5);
  static const accentBlue = Color(0xFF6B9BD2);

  // Status Colors (softer)
  static const success = Color(0xFF5CB85C);
  static const warning = Color(0xFFDEB779);
  static const error = Color(0xFFD66B6B);
  static const info = Color(0xFF6B9BD2);

  // Semantic colors that change based on theme
  static Color focus(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? focusDark
        : focusLight;
  }

  static Color focusSoft(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? focusDarkSoft
        : focusLightSoft;
  }

  static Color focusBg(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? focusDarkBg
        : focusLightBg;
  }

  static Color play(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? playDark
        : playLight;
  }

  static Color playSoft(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? playDarkSoft
        : playLightSoft;
  }

  static Color playBg(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? playDarkBg
        : playLightBg;
  }
}
