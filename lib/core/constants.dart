import 'package:flutter/material.dart';

class AppColors {
  
  static const Color primary = Color(0xFF2D4F38); 
  static const Color primaryDark = Color(0xFF1B3828); 
  static const Color primaryLight = Color(0xFF4A7256);
  static const Color primaryUltraLight = Color(0xFFEBF2EC); 
  static const Color accent = Color(0xFF5D916C);

  static const Color background = Color(0xFFF7F8F4); 
  static const Color surface = Colors.white;
  static const Color surfaceCard = Colors.white;

  static const Color textPrimary = Color(0xFF1F2F25); 
  static const Color textSecondary = Color(0xFF6E7E73); 
  static const Color textLight = Color(0xFF9EABA2);

  static const Color statusConfirmed = Color(0xFF2D7D46);
  static const Color statusConfirmedBg = Color(0xFFE6F5EC);
  static const Color statusPending = Color(0xFFD97706);
  static const Color statusPendingBg = Color(0xFFFEF3C7);
  static const Color statusCompleted = Color(0xFF4B5563);
  static const Color statusCompletedBg = Color(0xFFF3F4F6);
  static const Color statusCancelled = Color(0xFFDC2626);
  static const Color statusCancelledBg = Color(0xFFFEE2E2);

  static const Color success = statusConfirmed;
  static const Color successBg = statusConfirmedBg;
  static const Color warning = statusPending;
  static const Color warningBg = statusPendingBg;
  static const Color error = statusCancelled;
  static const Color errorBg = statusCancelledBg;

  static const Color border = Color(0xFFE8ECE5);
  static const Color divider = Color(0xFFEEF2EC);
}

class AppConstants {
  static const String appName = 'ServiceHub';
  static const String appTagline = 'Book • Manage • Live Better';

  static const String defaultBaseUrl = 'https://service-booking-backend-es6d.onrender.com/api';

  static const String tokenKey = 'servicehub_jwt_token';
  static const String userKey = 'servicehub_user_profile';
  static const String onboardingSeenKey = 'servicehub_onboarding_seen';
}
