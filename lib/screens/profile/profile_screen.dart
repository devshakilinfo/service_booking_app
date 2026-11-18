import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants.dart';
import '../../providers/auth_provider.dart';
import '../admin/admin_dashboard_screen.dart';
import '../auth/login_screen.dart';
import 'change_password_screen.dart';
import 'edit_profile_screen.dart';
import 'settings_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _handleLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Logout', style: TextStyle(fontWeight: FontWeight.w800)),
        content: const Text('Are you sure you want to log out of ServiceHub?'),
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
              if (context.mounted) {
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
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;
    final isAdmin = user?.role == 'admin';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: AppColors.textPrimary, size: 20),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
        ),
        title: const Text(
          'My Profile',
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
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12),
          child: Column(
            children: [
              // Screen 11: Avatar and Name (Shakil Ahamed)
              Center(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: AppColors.accent.withValues(alpha: 0.3), width: 2),
                          ),
                          child: const CircleAvatar(
                            radius: 46,
                            backgroundColor: AppColors.primaryUltraLight,
                            child: Icon(Icons.person_rounded, size: 54, color: AppColors.primary),
                          ),
                        ),
                        Positioned(
                          bottom: 2,
                          right: 2,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const EditProfileScreen()),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.camera_alt_rounded,
                                  size: 14, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      user?.name ?? 'Shakil Ahamed',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user?.email ?? 'shakil@example.com',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              // Menu Cards
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
                    // Edit Profile (Dedicated Screen)
                    _buildMenuItem(
                      icon: Icons.edit_note_rounded,
                      title: 'Edit Profile',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const EditProfileScreen()),
                        );
                      },
                    ),
                    const Divider(height: 1, color: AppColors.divider, indent: 16, endIndent: 16),
                    // Change Password (Dedicated Screen)
                    _buildMenuItem(
                      icon: Icons.lock_outline_rounded,
                      title: 'Change Password',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const ChangePasswordScreen()),
                        );
                      },
                    ),
                    const Divider(height: 1, color: AppColors.divider, indent: 16, endIndent: 16),
                    // App Settings (Dedicated Screen)
                    _buildMenuItem(
                      icon: Icons.settings_outlined,
                      title: 'App Settings',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const SettingsScreen()),
                        );
                      },
                    ),
                    // Only show Admin Dashboard if current user is an Admin
                    if (isAdmin) ...[
                      const Divider(height: 1, color: AppColors.divider, indent: 16, endIndent: 16),
                      _buildMenuItem(
                        icon: Icons.dashboard_outlined,
                        title: 'Admin Dashboard',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const AdminDashboardScreen()),
                          );
                        },
                      ),
                    ],
                    const Divider(height: 1, color: AppColors.divider, indent: 16, endIndent: 16),
                    _buildMenuItem(
                      icon: Icons.help_outline_rounded,
                      title: 'Help & Support',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Support email: support@servicehub.com')),
                        );
                      },
                    ),
                    const Divider(height: 1, color: AppColors.divider, indent: 16, endIndent: 16),
                    _buildMenuItem(
                      icon: Icons.logout_rounded,
                      title: 'Logout',
                      textColor: AppColors.statusCancelled,
                      iconColor: AppColors.statusCancelled,
                      showArrow: false,
                      onTap: () => _handleLogout(context),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? textColor,
    Color? iconColor,
    bool showArrow = true,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: iconColor ?? AppColors.primary, size: 22),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: textColor ?? AppColors.textPrimary,
        ),
      ),
      trailing: showArrow
          ? const Icon(Icons.chevron_right_rounded,
              color: AppColors.textLight, size: 20)
          : null,
    );
  }
}
