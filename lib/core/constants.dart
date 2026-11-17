import 'package:flutter/material.dart';

class AppColors {
  // Theme inspired by ServiceHub mockup
  static const Color primary = Color(0xFF2E5A27); // Deep Sage/Forest Green
  static const Color primaryLight = Color(0xFF4A7C3F);
  static const Color primaryUltraLight = Color(0xFFEBF3E8);
  static const Color accent = Color(0xFF81B271);
  static const Color background = Color(0xFFF9FAF8);
  static const Color surface = Colors.white;

  // Text Colors
  static const Color textPrimary = Color(0xFF1E281D);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textLight = Color(0xFF9CA3AF);

  // Status Colors
  static const Color success = Color(0xFF2E7D32);
  static const Color successBg = Color(0xFFE8F5E9);
  static const Color warning = Color(0xFFED6C02);
  static const Color warningBg = Color(0xFFFFF3E0);
  static const Color error = Color(0xFFD32F2F);
  static const Color errorBg = Color(0xFFFFEBEE);

  // Borders & Dividers
  static const Color border = Color(0xFFE5E7EB);
  static const Color divider = Color(0xFFF3F4F6);
}

class AppConstants {
  static const String appName = 'ServiceHub';
  static const String appTagline = 'Book • Manage • Live Better';

  // API Config:
  // For Android Emulator use: http://10.0.2.2:5000/api
  // For Real Device use your PC Local IP: http://192.168.x.x:5000/api
  // For iOS Simulator use: http://localhost:5000/api
  static const String defaultBaseUrl = 'http://10.0.2.2:5000/api';

  // Storage Keys
  static const String tokenKey = 'servicehub_jwt_token';
  static const String userKey = 'servicehub_user_profile';
  static const String onboardingSeenKey = 'servicehub_onboarding_seen';
}
