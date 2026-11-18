import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/booking_provider.dart';
import '../../../providers/service_provider.dart';
import '../../../widgets/app_illustrations.dart';
import '../../auth/login_screen.dart';
import '../../main_navigation_screen.dart';
import '../widgets/admin_booking_card.dart';
import '../widgets/admin_metric_card.dart';

class AdminOverviewTab extends StatelessWidget {
  final VoidCallback onNavigateToBookings;

  const AdminOverviewTab({super.key, required this.onNavigateToBookings});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.currentUser;
    final bookingProvider = Provider.of<BookingProvider>(context);
    final serviceProvider = Provider.of<ServiceProvider>(context);

    final recentBookings = bookingProvider.adminBookings;
    final totalBookingsStr = '${bookingProvider.adminBookings.length}';
    final totalServicesStr = '${serviceProvider.services.length}';
    final activeServicesCount = serviceProvider.services.where((s) => s.isActive).length;
    final totalRevenueVal = bookingProvider.adminBookings
        .where((b) => b.status.toLowerCase() != 'cancelled')
        .fold(0.0, (acc, b) => acc + b.totalPrice);
    final totalRevenueStr = '\$${totalRevenueVal.toStringAsFixed(0)}';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 20),
                onPressed: () => Navigator.pop(context),
              )
            : IconButton(
                icon: const Icon(Icons.storefront_outlined, color: AppColors.primary, size: 22),
                tooltip: 'Customer App View',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
                  );
                },
              ),
        title: const Text(
          'Admin Dashboard',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: AppColors.error, size: 22),
            tooltip: 'Logout',
            onPressed: () async {
              await auth.logout();
              if (!context.mounted) return;
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.only(right: 14.0),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: const Color(0xFF1E3827),
              child: Text(
                user?.name.isNotEmpty == true ? user!.name[0].toUpperCase() : 'A',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 13),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await Future.wait([
              bookingProvider.fetchAllBookingsAdmin(),
              serviceProvider.fetchServices(),
            ]);
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: AdminMetricCard(
                        icon: Icons.people_alt_rounded,
                        iconBg: Color(0xFFE0E7FF),
                        iconColor: Color(0xFF4F46E5),
                        title: 'Total Users',
                        value: '6',
                        trend: 'Active',
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: AdminMetricCard(
                        icon: Icons.calendar_today_rounded,
                        iconBg: const Color(0xFFFEF3C7),
                        iconColor: const Color(0xFFD97706),
                        title: 'Total Bookings',
                        value: totalBookingsStr,
                        trend: '+8% this week',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: AdminMetricCard(
                        icon: Icons.home_repair_service_rounded,
                        iconBg: const Color(0xFFE6F5EC),
                        iconColor: AppColors.statusConfirmed,
                        title: 'Total Services',
                        value: totalServicesStr,
                        trend: '$activeServicesCount Active',
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: AdminMetricCard(
                        icon: Icons.attach_money_rounded,
                        iconBg: const Color(0xFFFFFBEB),
                        iconColor: const Color(0xFFB45309),
                        title: 'Revenue',
                        value: totalRevenueStr,
                        trend: 'Gross Sales',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: adminWhiteCardDecoration(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Weekly Revenue',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.primaryUltraLight,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'Nov 14 - Nov 20',
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      SizedBox(
                        height: 130,
                        width: double.infinity,
                        child: CustomPaint(
                          painter: AdminWeeklyBarChartPainter(),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Mon', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                          Text('Tue', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                          Text('Wed', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                          Text('Thu', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                          Text('Fri', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                          Text('Sat', style: TextStyle(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.w800)),
                          Text('Sun', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Recent Bookings',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    GestureDetector(
                      onTap: onNavigateToBookings,
                      child: const Text(
                        'See All →',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (recentBookings.isEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    alignment: Alignment.center,
                    child: const Text(
                      'No recent bookings found',
                      style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                    ),
                  )
                else
                  ...recentBookings.take(3).map((b) => AdminBookingCard(booking: b)),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
