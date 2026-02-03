import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primaryBlue = Color(0xFF1E88E5);
  static const Color darkBlue = Color(0xFF1565C0);
  static const Color lightBlue = Color(0xFF42A5F5);
  
  // Background Colors
  static const Color darkBackground = Color(0xFF0D1B2A);
  static const Color darkBackgroundSecondary = Color(0xFF1B263B);
  
  // Text Colors
  static const Color textWhite = Color(0xFFFFFFFF);
  static const Color textGrey = Color(0xFF9E9E9E);
  static const Color textDark = Color(0xFF212121);
  
  // Accent Colors
  static const Color accentOrange = Color(0xFFFF6B35);
  static const Color accentGreen = Color(0xFF4CAF50);
  static const Color accentRed = Color(0xFFF44336);
  
  // Gradient Colors
  static const LinearGradient darkGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF1B3A5F),
      Color(0xFF0D1B2A),
    ],
  );
  
  // Category Colors
  static const Color categoryWork = Color(0xFF2196F3);
  static const Color categoryPersonal = Color(0xFF9C27B0);
  static const Color categoryStudy = Color(0xFFFF9800);
}
