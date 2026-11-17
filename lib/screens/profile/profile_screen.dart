import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_text_field.dart';
import '../admin/admin_dashboard_screen.dart';
import '../auth/login_screen.dart';
import 'settings_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _showEditProfileDialog(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.currentUser;
    final nameController = TextEditingController(text: user?.name ?? 'Shakil Ahamed');
    final phoneController = TextEditingController(text: user?.phone ?? '');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Edit Profile', style: TextStyle(fontWeight: FontWeight.w800)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextField(
              controller: nameController,
              hint: 'Full Name',
              prefixIcon: Icons.person_outline,
            ),
            const SizedBox(height: 12),
            CustomTextField(
              controller: phoneController,
              hint: 'Phone Number',
              prefixIcon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            onPressed: () async {
              Navigator.pop(ctx);
              final success = await authProvider.updateProfile(
                name: nameController.text.trim(),
                phone: phoneController.text.trim(),
              );
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(success ? 'Profile updated successfully' : 'Failed to update profile'),
                    backgroundColor: success ? AppColors.statusConfirmed : AppColors.statusCancelled,
                  ),
                );
              }
            },
            child: const Text('Save Changes', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Change Password', style: TextStyle(fontWeight: FontWeight.w800)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextField(
              controller: currentPasswordController,
              hint: 'Current Password',
              prefixIcon: Icons.lock_outline,
              isPassword: true,
            ),
            const SizedBox(height: 12),
            CustomTextField(
              controller: newPasswordController,
              hint: 'New Password (min 6 chars)',
              prefixIcon: Icons.lock_reset_outlined,
              isPassword: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            onPressed: () async {
              if (newPasswordController.text.length < 6) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('New password must be at least 6 characters')),
                );
                return;
              }
              Navigator.pop(ctx);
              final success = await authProvider.updateProfile(
                currentPassword: currentPasswordController.text,
                newPassword: newPasswordController.text,
              );
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(success
                        ? 'Password updated successfully'
                        : (authProvider.errorMessage ?? 'Update failed')),
                    backgroundColor: success ? AppColors.statusConfirmed : AppColors.statusCancelled,
                  ),
                );
              }
            },
            child: const Text('Update', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

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
                            border: Border.all(color: AppColors.accent.withValues(alpha: 0.3), width: 2),
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
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.camera_alt_rounded, size: 14, color: Colors.white),
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
                    _buildMenuItem(
                      icon: Icons.edit_note_rounded,
                      title: 'Edit Profile',
                      onTap: () => _showEditProfileDialog(context),
                    ),
                    const Divider(height: 1, color: AppColors.divider, indent: 16, endIndent: 16),
                    _buildMenuItem(
                      icon: Icons.lock_outline_rounded,
                      title: 'Change Password',
                      onTap: () => _showChangePasswordDialog(context),
                    ),
                    const Divider(height: 1, color: AppColors.divider, indent: 16, endIndent: 16),
                    _buildMenuItem(
                      icon: Icons.settings_outlined,
                      title: 'App Settings',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const SettingsScreen()),
                        );
                      },
                    ),
                    const Divider(height: 1, color: AppColors.divider, indent: 16, endIndent: 16),
                    _buildMenuItem(
                      icon: Icons.dashboard_outlined,
                      title: 'Admin Dashboard',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const AdminDashboardScreen()),
                        );
                      },
                    ),
                    const Divider(height: 1, color: AppColors.divider, indent: 16, endIndent: 16),
                    _buildMenuItem(
                      icon: Icons.help_outline_rounded,
                      title: 'Help & Support',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Support email: support@servicehub.com')),
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
      leading: Icon(icon, color: iconColor ?? AppColors.textPrimary, size: 22),
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
