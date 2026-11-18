import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants.dart';
import '../../models/booking_model.dart';
import '../../models/service_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/service_provider.dart';
import '../../widgets/app_illustrations.dart';
import 'admin_add_service_screen.dart';
import 'admin_booking_details_screen.dart';
import 'admin_edit_service_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _currentTabIndex = 0;

  // Search and filter states
  String _serviceSearch = '';
  String _bookingSearch = '';
  int _selectedBookingFilterIndex = 0;
  final List<String> _bookingFilters = ['All', 'Pending', 'Confirmed', 'Completed', 'Cancelled'];

  // Admin Settings states
  bool _autoConfirmBookings = true;
  final _platformNameCtrl = TextEditingController(text: 'ServiceHub');
  final _commissionRateCtrl = TextEditingController(text: '15%');
  final _supportEmailCtrl = TextEditingController(text: 'support@servicehub.app');
  final _slotBufferCtrl = TextEditingController(text: '30 mins');
  final _cancellationWindowCtrl = TextEditingController(text: '2 hours before');

  // Fallback demo bookings for Admin view
  final List<BookingModel> _demoAdminBookings = [
    BookingModel(
      id: 'SH-8492',
      service: ServiceModel(
        id: '1',
        name: 'Deep Home Cleaning',
        description: 'Eco-friendly residential cleaning',
        price: 25.0,
        duration: '2 Hours',
        category: 'Cleaning',
        rating: 4.8,
        reviewsCount: 2540,
        image: 'https://images.unsplash.com/photo-1581578731548-c64695cc6952?w=800',
      ),
      date: 'Thu, 19 Nov 2026',
      timeSlot: '11:30 AM',
      status: 'Confirmed',
      totalPrice: 25.0,
      notes: 'Please bring eco-friendly cleaning supplies',
    ),
    BookingModel(
      id: 'SH-8493',
      service: ServiceModel(
        id: '2',
        name: 'AC Repair & Diagnostics',
        description: 'Compressor check and gas refill',
        price: 40.0,
        duration: '1.5 hrs',
        category: 'Repair',
        rating: 4.6,
        reviewsCount: 1020,
        image: 'https://images.unsplash.com/photo-1621905251189-08b45d6a269e?w=800',
      ),
      date: 'Fri, 21 Nov 2026',
      timeSlot: '02:00 PM',
      status: 'Pending',
      totalPrice: 40.0,
    ),
    BookingModel(
      id: 'SH-8490',
      service: ServiceModel(
        id: '3',
        name: 'Plumbing Service',
        description: 'Pipe leakage and water faucet fix',
        price: 30.0,
        duration: '1 hr',
        category: 'Repair',
        rating: 4.7,
        reviewsCount: 1200,
        image: 'https://images.unsplash.com/photo-1607472586893-edb57bdc0e39?w=800',
      ),
      date: 'Mon, 24 Nov 2026',
      timeSlot: '11:00 AM',
      status: 'Completed',
      totalPrice: 30.0,
    ),
    BookingModel(
      id: 'SH-8488',
      service: ServiceModel(
        id: '4',
        name: 'Beauty & Parlour Facial',
        description: 'Relaxing facial massage and skin therapy',
        price: 35.0,
        duration: '1.5 hrs',
        category: 'Beauty',
        rating: 4.7,
        reviewsCount: 856,
        image: 'https://images.unsplash.com/photo-1560750588-73207b1ef5b8?w=800',
      ),
      date: 'Wed, 12 Nov 2026',
      timeSlot: '04:00 PM',
      status: 'Cancelled',
      totalPrice: 35.0,
    ),
  ];

  @override
  void dispose() {
    _platformNameCtrl.dispose();
    _commissionRateCtrl.dispose();
    _supportEmailCtrl.dispose();
    _slotBufferCtrl.dispose();
    _cancellationWindowCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(
        index: _currentTabIndex,
        children: [
          _buildOverviewTab(),
          _buildServicesTab(),
          _buildBookingsTab(),
          _buildAnalyticsTab(),
          _buildAdminSettingsTab(),
        ],
      ),
      bottomNavigationBar: _buildAdminBottomBar(),
    );
  }

  // Dark Green Custom Admin Bottom Bar (matches media_1794987721709_7c9dc661 & media_1794987721751_4327c882)
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

  // -------------------------------------------------------------
  // TAB 0: OVERVIEW (matches media_1794987683685_3cb1c6b0)
  // -------------------------------------------------------------
  Widget _buildOverviewTab() {
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.currentUser;

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
          'Admin Dashboard',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: const Color(0xFF1E3827),
              child: Text(
                user?.name.isNotEmpty == true ? user!.name[0].toUpperCase() : 'A',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 14),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 4 Stat Cards in 2x2 Grid
              Row(
                children: [
                  Expanded(
                    child: _buildMetricCard(
                      icon: Icons.people_alt_rounded,
                      iconBg: const Color(0xFFE0E7FF),
                      iconColor: const Color(0xFF4F46E5),
                      title: 'Total Users',
                      value: '1,250',
                      trend: '+12% this week',
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _buildMetricCard(
                      icon: Icons.calendar_today_rounded,
                      iconBg: const Color(0xFFFEF3C7),
                      iconColor: const Color(0xFFD97706),
                      title: 'Total Bookings',
                      value: '3,420',
                      trend: '+8% this week',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: _buildMetricCard(
                      icon: Icons.home_repair_service_rounded,
                      iconBg: const Color(0xFFE6F5EC),
                      iconColor: AppColors.statusConfirmed,
                      title: 'Total Services',
                      value: '24',
                      trend: '22 Active',
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _buildMetricCard(
                      icon: Icons.attach_money_rounded,
                      iconBg: const Color(0xFFFFFBEB),
                      iconColor: const Color(0xFFB45309),
                      title: 'Revenue',
                      value: '\$12,540',
                      trend: '+15.2% growth',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 22),

              // Weekly Revenue Bar Chart Card
              Container(
                padding: const EdgeInsets.all(18),
                decoration: _whiteCardDecoration(),
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

              // Recent Bookings Header
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
                    onTap: () => setState(() => _currentTabIndex = 2),
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

              ..._demoAdminBookings.take(3).map((b) => _buildBookingCard(b)),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // -------------------------------------------------------------
  // TAB 1: SERVICES (matches media_1794987683720_5b9f5634)
  // -------------------------------------------------------------
  Widget _buildServicesTab() {
    final serviceProvider = Provider.of<ServiceProvider>(context);
    final allServices = serviceProvider.services;

    final filteredServices = allServices.where((s) {
      if (_serviceSearch.isEmpty) return true;
      return s.name.toLowerCase().contains(_serviceSearch.toLowerCase()) ||
          s.category.toLowerCase().contains(_serviceSearch.toLowerCase());
    }).toList();

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
          'Manage Services',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 14.0),
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AdminAddServiceScreen()),
                );
              },
              icon: const Icon(Icons.add_rounded, size: 16, color: Colors.white),
              label: const Text('Add New', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 6, 20, 12),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.border),
                ),
                child: TextField(
                  onChanged: (val) => setState(() => _serviceSearch = val),
                  decoration: const InputDecoration(
                    hintText: 'Search service name, category...',
                    hintStyle: TextStyle(fontSize: 13, color: AppColors.textLight),
                    prefixIcon: Icon(Icons.search_rounded, color: AppColors.textSecondary, size: 20),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                itemCount: filteredServices.length,
                itemBuilder: (ctx, idx) {
                  final service = filteredServices[idx];
                  return _buildAdminServiceTile(service);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminServiceTile(ServiceModel service) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: _whiteCardDecoration(),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              service.image,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 60,
                height: 60,
                color: AppColors.primaryUltraLight,
                child: const Icon(Icons.home_repair_service_rounded, color: AppColors.primary),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  service.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  service.category,
                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${service.price.toStringAsFixed(0)} • ${service.duration}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit_outlined, size: 20, color: AppColors.primary),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AdminEditServiceScreen(service: service),
                        ),
                      );
                    },
                    tooltip: 'Edit Service',
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline_rounded, size: 20, color: AppColors.statusCancelled),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Service "${service.name}" deleted')),
                      );
                    },
                    tooltip: 'Delete Service',
                  ),
                ],
              ),
              Transform.scale(
                scale: 0.8,
                child: Switch(
                  value: true,
                  activeColor: AppColors.primary,
                  onChanged: (val) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Service visibility toggled')),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------------------
  // TAB 2: ALL BOOKINGS (matches media_1794987683670_f215391a)
  // -------------------------------------------------------------
  Widget _buildBookingsTab() {
    final filtered = _demoAdminBookings.where((b) {
      final statusMatch = _selectedBookingFilterIndex == 0 ||
          b.status.toLowerCase() == _bookingFilters[_selectedBookingFilterIndex].toLowerCase();
      final textMatch = _bookingSearch.isEmpty ||
          b.id.toLowerCase().contains(_bookingSearch.toLowerCase()) ||
          b.serviceName.toLowerCase().contains(_bookingSearch.toLowerCase()) ||
          b.customerName.toLowerCase().contains(_bookingSearch.toLowerCase());
      return statusMatch && textMatch;
    }).toList();

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
          'All Bookings',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search Input
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.border),
                ),
                child: TextField(
                  onChanged: (val) => setState(() => _bookingSearch = val),
                  decoration: const InputDecoration(
                    hintText: 'Search by #SH-ID, customer, service...',
                    hintStyle: TextStyle(fontSize: 13, color: AppColors.textLight),
                    prefixIcon: Icon(Icons.search_rounded, color: AppColors.textSecondary, size: 20),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ),

            // Status Filter Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                children: List.generate(_bookingFilters.length, (index) {
                  final isSelected = _selectedBookingFilterIndex == index;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(_bookingFilters[index]),
                      selected: isSelected,
                      selectedColor: AppColors.primary,
                      backgroundColor: Colors.white,
                      labelStyle: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: isSelected ? Colors.white : AppColors.textSecondary,
                      ),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      side: BorderSide(
                        color: isSelected ? AppColors.primary : AppColors.border,
                      ),
                      onSelected: (val) {
                        setState(() => _selectedBookingFilterIndex = index);
                      },
                    ),
                  );
                }),
              ),
            ),

            // Bookings List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                itemCount: filtered.length,
                itemBuilder: (ctx, idx) => _buildBookingCard(filtered[idx]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingCard(BookingModel booking) {
    Color statusColor = AppColors.statusConfirmed;
    Color statusBg = AppColors.statusConfirmedBg;
    if (booking.status.toLowerCase() == 'pending') {
      statusColor = AppColors.statusPending;
      statusBg = AppColors.statusPendingBg;
    } else if (booking.status.toLowerCase() == 'cancelled') {
      statusColor = AppColors.statusCancelled;
      statusBg = AppColors.statusCancelledBg;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: _whiteCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '#${booking.id}',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  booking.status,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            booking.serviceName,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.person_outline_rounded, size: 14, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              Text(
                booking.customerName,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
              ),
              const SizedBox(width: 12),
              const Icon(Icons.calendar_today_rounded, size: 13, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              Text(
                '${booking.date} • ${booking.time}',
                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '\$${booking.totalPrice.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AdminBookingDetailsScreen(booking: booking),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryUltraLight,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                ),
                child: const Text(
                  'Manage →',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------------------
  // TAB 3: REPORTS & ANALYTICS (matches media_1794987721709_7c9dc661)
  // -------------------------------------------------------------
  Widget _buildAnalyticsTab() {
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
          'Reports & Analytics',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: const Row(
              children: [
                Text(
                  'This Month',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                ),
                Icon(Icons.keyboard_arrow_down_rounded, size: 16, color: AppColors.textSecondary),
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dark Green Total Net Earnings Banner Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E3827),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF1E3827).withValues(alpha: 0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Total Net Earnings',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '\$38,450.00',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF4ADE80),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            '+18.5%',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF132B1D),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    const Divider(color: Colors.white24, height: 1),
                    const SizedBox(height: 12),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Completion Rate: 94.2%', style: TextStyle(fontSize: 12, color: Colors.white70, fontWeight: FontWeight.w600)),
                        Text('Avg Order: \$29.95', style: TextStyle(fontSize: 12, color: Colors.white70, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Monthly Revenue Growth Line Chart Card
              Container(
                padding: const EdgeInsets.all(18),
                decoration: _whiteCardDecoration(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Monthly Revenue Growth',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          'Jul – Nov',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      height: 140,
                      width: double.infinity,
                      child: CustomPaint(
                        painter: AdminMonthlyLineChartPainter(),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Jul', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                        Text('Aug', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                        Text('Sep', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                        Text('Oct', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                        Text('Nov', style: TextStyle(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.w800)),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Top Performing Services
              Container(
                padding: const EdgeInsets.all(18),
                decoration: _whiteCardDecoration(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Top Performing Services',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildServiceProgressRow('Home Cleaning', '\$16,149 (42%)', 0.42),
                    const SizedBox(height: 12),
                    _buildServiceProgressRow('AC Repair & Gas', '\$10,766 (28%)', 0.28),
                    const SizedBox(height: 12),
                    _buildServiceProgressRow('Plumbing Service', '\$6,921 (18%)', 0.18),
                    const SizedBox(height: 12),
                    _buildServiceProgressRow('Beauty Parlour', '\$4,614 (12%)', 0.12),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              // Export CSV / PDF Report Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Exporting report as CSV & PDF...')),
                    );
                  },
                  icon: const Icon(Icons.arrow_downward_rounded, color: Colors.white, size: 20),
                  label: const Text(
                    'Export CSV / PDF Report',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildServiceProgressRow(String title, String amount, double progress) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
            Text(amount, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: const Color(0xFFE8F5E9),
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
            minHeight: 7,
          ),
        ),
      ],
    );
  }

  // -------------------------------------------------------------
  // TAB 4: ADMIN SETTINGS (matches media_1794987721751_4327c882)
  // -------------------------------------------------------------
  Widget _buildAdminSettingsTab() {
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
          'Admin Settings',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primaryUltraLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'System v1.0',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.primary),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Business & Platform Config
              _buildSettingsCard(
                title: 'Business & Platform Config',
                children: [
                  Row(
                    children: [
                      Expanded(child: _buildSettingInput('Platform Name', _platformNameCtrl)),
                      const SizedBox(width: 12),
                      Expanded(child: _buildSettingInput('Commission Rate', _commissionRateCtrl)),
                    ],
                  ),
                  const SizedBox(height: 14),
                  _buildSettingInput('Support Email', _supportEmailCtrl),
                ],
              ),

              const SizedBox(height: 18),

              // Booking Rules
              _buildSettingsCard(
                title: 'Booking Rules',
                children: [
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Auto-Confirm New Bookings',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                    value: _autoConfirmBookings,
                    activeColor: AppColors.primary,
                    onChanged: (val) => setState(() => _autoConfirmBookings = val),
                  ),
                  const Divider(height: 1, color: AppColors.divider),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Slot Buffer Time', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                      Text(_slotBufferCtrl.text, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Free Cancellation Window', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                      Text(_cancellationWindowCtrl.text, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 18),

              // Backend & AI Integrations
              _buildSettingsCard(
                title: 'Backend & AI Integrations',
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Gemini AI Assistant API', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.statusConfirmedBg,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text('• Connected', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.statusConfirmed)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('JWT Authentication & RBAC', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.statusConfirmedBg,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text('• Active', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.statusConfirmed)),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Configuration saved successfully!')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Save Configuration',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white),
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsCard({required String title, required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _whiteCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
          const SizedBox(height: 14),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSettingInput(String label, TextEditingController ctrl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAF8),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: TextField(
            controller: ctrl,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
            decoration: const InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }

  // -------------------------------------------------------------
  // Helpers
  // -------------------------------------------------------------
  BoxDecoration _whiteCardDecoration() {
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

  Widget _buildMetricCard({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String value,
    required String trend,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _whiteCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              Text(
                trend,
                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.primary),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
