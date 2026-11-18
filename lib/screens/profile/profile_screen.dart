import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants.dart';
import '../../providers/auth_provider.dart';
import '../../providers/booking_provider.dart';
import '../admin/admin_dashboard_screen.dart';
import '../auth/login_screen.dart';
import 'change_password_screen.dart';
import 'settings_screen.dart';
import 'widgets/profile_header_card.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _addressController;

  @override
  void initState() {
    super.initState();
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final user = auth.currentUser;
    _nameController = TextEditingController(
      text: (user?.name != null && user!.name.isNotEmpty) ? user.name : 'Shakil Ahamed',
    );
    _addressController = TextEditingController(
      text: (user?.address != null && user!.address.isNotEmpty)
          ? user.address
          : 'House 14, Road 7, Dhanmondi, Dhaka',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    super.dispose();
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
            child: const Text(
              'Logout',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _saveProfile() async {
    FocusScope.of(context).unfocus();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.updateProfile(
      name: _nameController.text.trim(),
      address: _addressController.text.trim(),
    );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Text('Personal information saved successfully!'),
          ],
        ),
        backgroundColor: const Color(0xFF1E4620),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final bookingProvider = Provider.of<BookingProvider>(context);
    final user = authProvider.currentUser;
    final isAdmin = user?.role == 'admin';
    final displayName = (user?.name != null && user!.name.isNotEmpty) ? user.name : 'Shakil Ahamed';
    final displayEmail =
        (user?.email != null && user!.email.isNotEmpty) ? user.email : 'shakil.dev@servicehub.app';
    final displayPhone =
        (user?.phone != null && user!.phone.isNotEmpty) ? user.phone : '+880 1712-345678';

    final nameParts = displayName.trim().split(' ');
    final initials = nameParts.length > 1
        ? '${nameParts.first[0]}${nameParts.last[0]}'.toUpperCase()
        : (nameParts.isNotEmpty && nameParts.first.isNotEmpty
            ? nameParts.first.substring(0, 1).toUpperCase()
            : 'SA');

    final bookingsCount = bookingProvider.bookings.length;
    final totalSpent = bookingProvider.bookings.fold<double>(
      0.0,
      (sum, b) => sum + b.totalAmount,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAF6),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 28),
          child: Column(
            children: [
              ProfileHeaderCard(
                displayName: displayName,
                displayEmail: displayEmail,
                displayPhone: displayPhone,
                initials: initials,
                bookingsCount: bookingsCount > 0 ? bookingsCount : 12,
                favoritesCount: 4,
                totalSpent: totalSpent > 0 ? totalSpent : 340.0,
              ),

              const SizedBox(height: 18),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0xFFE7EDE4)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Personal Information',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF142E18),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const SettingsScreen()),
                            );
                          },
                          child: const Text(
                            'Editable',
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF4C8C32),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildInputLabel('Full Name'),
                    const SizedBox(height: 6),
                    _buildRoundedInput(_nameController),
                    const SizedBox(height: 14),
                    _buildInputLabel('Default Address'),
                    const SizedBox(height: 6),
                    _buildRoundedInput(_addressController),
                    const SizedBox(height: 18),
                    
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _saveProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE6F1E1),
                          foregroundColor: const Color(0xFF142E18),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          'Save Changes',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF142E18),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0xFFE7EDE4)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildEmojiMenuRow(
                      emoji: '🔒',
                      title: 'Change Password & Security',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const ChangePasswordScreen()),
                        );
                      },
                    ),
                    const Divider(height: 1, color: Color(0xFFF0F4EE)),
                    _buildEmojiMenuRow(
                      emoji: '📍',
                      title: 'Saved Addresses',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const SettingsScreen()),
                        );
                      },
                    ),
                    if (isAdmin) ...[
                      const Divider(height: 1, color: Color(0xFFF0F4EE)),
                      _buildEmojiMenuRow(
                        emoji: '📊',
                        title: 'Admin Dashboard',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const AdminDashboardScreen()),
                          );
                        },
                      ),
                    ],
                    const Divider(height: 1, color: Color(0xFFF0F4EE)),
                    _buildEmojiMenuRow(
                      emoji: '🚪',
                      title: 'Logout',
                      textColor: const Color(0xFFC93B2B),
                      onTap: () => _handleLogout(context),
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

  Widget _buildInputLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 12.5,
        fontWeight: FontWeight.w600,
        color: Color(0xFF526553),
      ),
    );
  }

  Widget _buildRoundedInput(TextEditingController controller) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF3F6F1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2EAE0)),
      ),
      child: TextField(
        controller: controller,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Color(0xFF142E18),
        ),
        decoration: const InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildEmojiMenuRow({
    required String emoji,
    required String title,
    required VoidCallback onTap,
    Color? textColor,
  }) {
    final color = textColor ?? const Color(0xFF142E18);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 16)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
            ),
            Text(
              '›',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: textColor ?? const Color(0xFF526553),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
