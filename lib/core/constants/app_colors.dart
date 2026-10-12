import 'package:flutter/material.dart';

/// NekoTomo color palette - Kawaii Japanese × Cozy Pet × Japanese Stationery
class AppColors {
  AppColors._();

  // Primary - Orange (Main Theme)
  static const Color primary = Color(0xFFF6A45B);
  static const Color primaryLight = Color(0xFFFFCC99); // Adjusted lighter shade
  static const Color primaryDark = Color(0xFFD98242);

  // Secondary - Yellow
  static const Color secondary = Color(0xFFFFD98A);
  static const Color secondaryLight = Color(0xFFFFF2CC);

  // Accent - Sakura Pink & Green
  static const Color sakura = Color(0xFFF4A6A6);
  static const Color matcha = Color(0xFFA8CFA8);
  static const Color accent = sakura;

  // Background
  static const Color background = Color(0xFFFFF8EE); // Main background
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFFFF2E6);

  // Text
  static const Color textPrimary = Color(0xFF6B3E32); // Dark Brown
  static const Color textSecondary = Color(0xFF8F6355);
  static const Color textHint = Color(0xFFC4A499);

  // Status
  static const Color success = matcha;
  static const Color warning = secondary;
  static const Color error = Color(0xFFFF6B6B);
  static const Color info = Color(0xFF74B9FF);

  // Pet stats
  static const Color hunger = primary;
  static const Color happiness = sakura;
  static const Color xp = secondary;
  static const Color energy = info;

  // Card shadows
  static const Color shadow = Color(0x1A6B3E32); // Soft brown shadow
}
