import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants.dart';
import '../../providers/booking_provider.dart';
import '../../providers/service_provider.dart';
import 'tabs/admin_analytics_tab.dart';
import 'tabs/admin_bookings_tab.dart';
import 'tabs/admin_overview_tab.dart';
import 'tabs/admin_services_tab.dart';
import 'tabs/admin_settings_tab.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      Provider.of<ServiceProvider>(context, listen: false).fetchServices();
      Provider.of<BookingProvider>(context, listen: false).fetchAllBookingsAdmin();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(
        index: _currentTabIndex,
        children: [
          AdminOverviewTab(
            onNavigateToBookings: () => setState(() => _currentTabIndex = 2),
          ),
          const AdminServicesTab(),
          const AdminBookingsTab(),
          const AdminAnalyticsTab(),
          const AdminSettingsTab(),
        ],
      ),
      bottomNavigationBar: _buildAdminBottomBar(),
    );
  }

  Widget _buildAdminBottomBar() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF132B1D),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildAdminNavItem(0, Icons.grid_view_rounded, 'Overview'),
              _buildAdminNavItem(1, Icons.home_repair_service_outlined, 'Services'),
              _buildAdminNavItem(2, Icons.calendar_today_outlined, 'Bookings'),
              _buildAdminNavItem(3, Icons.analytics_outlined, 'Reports'),
              _buildAdminNavItem(4, Icons.settings_outlined, 'Settings'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAdminNavItem(int index, IconData icon, String label) {
    final isSelected = _currentTabIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentTabIndex = index),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF234B34) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected ? const Color(0xFF4ADE80) : Colors.white60,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? Colors.white : Colors.white60,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
