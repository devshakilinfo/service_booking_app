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
  bool _pushNotifications = true;
  bool _bookingReminders = true;
  bool _promotionalOffers = false;
  bool _darkMode = false;

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
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 20),
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
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // NOTIFICATIONS SECTION
              _buildSectionHeader('NOTIFICATIONS'),
              const SizedBox(height: 8),
              Container(
                decoration: _cardDecoration(),
                child: Column(
                  children: [
                    _buildSwitchTile(
                      title: 'Push Notifications',
                      subtitle: 'Receive instant alerts on booking updates',
                      value: _pushNotifications,
                      onChanged: (val) => setState(() => _pushNotifications = val),
                    ),
                    const Divider(height: 1, color: AppColors.divider, indent: 16, endIndent: 16),
                    _buildSwitchTile(
                      title: 'Booking Reminders',
                      subtitle: 'Get notified 2 hours before scheduled slot',
                      value: _bookingReminders,
                      onChanged: (val) => setState(() => _bookingReminders = val),
                    ),
                    const Divider(height: 1, color: AppColors.divider, indent: 16, endIndent: 16),
                    _buildSwitchTile(
                      title: 'Promotional Offers',
                      subtitle: 'Discounts, seasonal deals and vouchers',
                      value: _promotionalOffers,
                      onChanged: (val) => setState(() => _promotionalOffers = val),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // PREFERENCES SECTION
              _buildSectionHeader('PREFERENCES'),
              const SizedBox(height: 8),
              Container(
                decoration: _cardDecoration(),
                child: Column(
                  children: [
                    _buildValueTile(
                      title: 'Language',
                      value: 'English (US)',
                      icon: Icons.language_rounded,
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Language: English (US) selected')),
                        );
                      },
                    ),
                    const Divider(height: 1, color: AppColors.divider, indent: 16, endIndent: 16),
                    _buildValueTile(
                      title: 'Currency',
                      value: 'USD (\$)',
                      icon: Icons.monetization_on_outlined,
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Currency: USD (\$) active')),
                        );
                      },
                    ),
                    const Divider(height: 1, color: AppColors.divider, indent: 16, endIndent: 16),
                    _buildSwitchTile(
                      title: 'Dark Mode',
                      subtitle: 'Switch between light and dark theme',
                      value: _darkMode,
                      onChanged: (val) {
                        setState(() => _darkMode = val);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Dark Mode will be available in next update')),
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // SECURITY & ACCOUNT SECTION
              _buildSectionHeader('SECURITY & ACCOUNT'),
              const SizedBox(height: 8),
              Container(
                decoration: _cardDecoration(),
                child: Column(
                  children: [
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                      title: const Text(
                        'Two-Factor Auth',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.statusConfirmedBg,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'Enabled',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: AppColors.statusConfirmed,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textLight),
                        ],
                      ),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Two-Factor Authentication is currently active')),
                        );
                      },
                    ),
                    const Divider(height: 1, color: AppColors.divider, indent: 16, endIndent: 16),
                    _buildValueTile(
                      title: 'Privacy Policy',
                      value: '',
                      icon: Icons.privacy_tip_outlined,
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('ServiceHub complies with GDPR & privacy safety standards')),
                        );
                      },
                    ),
                    const Divider(height: 1, color: AppColors.divider, indent: 16, endIndent: 16),
                    const ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                      title: Text(
                        'App Version',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                      ),
                      trailing: Text(
                        'v1.2.0 (Build 42)',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // Logout Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton.icon(
                  onPressed: _handleLogout,
                  icon: const Icon(Icons.logout_rounded, color: AppColors.statusCancelled, size: 20),
                  label: const Text(
                    'Logout',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.statusCancelled,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.statusCancelled.withValues(alpha: 0.3)),
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: AppColors.border),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.02),
          blurRadius: 6,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: AppColors.textLight,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      title: Text(
        title,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
      ),
      value: value,
      activeColor: AppColors.primary,
      onChanged: onChanged,
    );
  }

  Widget _buildValueTile({
    required String title,
    required String value,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      title: Text(
        title,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (value.isNotEmpty)
            Text(
              value,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textSecondary),
            ),
          const SizedBox(width: 8),
          const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textLight),
        ],
      ),
      onTap: onTap,
    );
  }
}
