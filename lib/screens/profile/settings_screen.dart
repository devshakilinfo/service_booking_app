import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants.dart';
import '../../providers/auth_provider.dart';
import '../auth/login_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Logout', style: TextStyle(fontWeight: FontWeight.w800)),
        content: const Text('Are you sure you want to log out of your account?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.statusCancelled,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            onPressed: () async {
              Navigator.pop(ctx);
              await Provider.of<AuthProvider>(context, listen: false).logout();
              if (mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              }
            },
            child: const Text('Logout', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: AppColors.textPrimary, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Settings',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Notifications Switch
                    ListTile(
                      leading: const Icon(Icons.notifications_none_rounded,
                          color: AppColors.textPrimary, size: 22),
                      title: const Text(
                        'Notifications',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      trailing: Switch(
                        value: _notificationsEnabled,
                        activeColor: AppColors.primary,
                        onChanged: (val) {
                          setState(() {
                            _notificationsEnabled = val;
                          });
                        },
                      ),
                    ),
                    const Divider(height: 1, color: AppColors.divider, indent: 16, endIndent: 16),
                    // Dark Mode Switch
                    ListTile(
                      leading: const Icon(Icons.nightlight_outlined,
                          color: AppColors.textPrimary, size: 22),
                      title: const Text(
                        'Dark Mode',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      trailing: Switch(
                        value: _darkModeEnabled,
                        activeColor: AppColors.primary,
                        onChanged: (val) {
                          setState(() {
                            _darkModeEnabled = val;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Dark Mode will be available in the next release.')),
                          );
                        },
                      ),
                    ),
                    const Divider(height: 1, color: AppColors.divider, indent: 16, endIndent: 16),
                    // Language
                    ListTile(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Selected language: English')),
                        );
                      },
                      leading: const Icon(Icons.language_rounded,
                          color: AppColors.textPrimary, size: 22),
                      title: const Text(
                        'Language',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      trailing: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'English',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(width: 4),
                          Icon(Icons.chevron_right_rounded,
                              color: AppColors.textLight, size: 20),
                        ],
                      ),
                    ),
                    const Divider(height: 1, color: AppColors.divider, indent: 16, endIndent: 16),
                    // Privacy & Security
                    ListTile(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Privacy Policy & Security standards: 256-bit encryption.')),
                        );
                      },
                      leading: const Icon(Icons.shield_outlined,
                          color: AppColors.textPrimary, size: 22),
                      title: const Text(
                        'Privacy & Security',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      trailing: const Icon(Icons.chevron_right_rounded,
                          color: AppColors.textLight, size: 20),
                    ),
                    const Divider(height: 1, color: AppColors.divider, indent: 16, endIndent: 16),
                    // About App
                    ListTile(
                      onTap: () {
                        showAboutDialog(
                          context: context,
                          applicationName: 'ServiceHub',
                          applicationVersion: '1.0.0',
                          applicationLegalese: '© 2026 ServiceHub Inc. All rights reserved.',
                        );
                      },
                      leading: const Icon(Icons.info_outline_rounded,
                          color: AppColors.textPrimary, size: 22),
                      title: const Text(
                        'About App',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      trailing: const Icon(Icons.chevron_right_rounded,
                          color: AppColors.textLight, size: 20),
                    ),
                    const Divider(height: 1, color: AppColors.divider, indent: 16, endIndent: 16),
                    // Logout
                    ListTile(
                      onTap: _handleLogout,
                      leading: const Icon(Icons.logout_rounded,
                          color: AppColors.statusCancelled, size: 22),
                      title: const Text(
                        'Logout',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.statusCancelled,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
