import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants.dart';
import '../../providers/booking_provider.dart';
import '../../widgets/booking_card.dart';

class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BookingProvider>(context, listen: false).fetchMyBookings();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showCancelDialog(String bookingId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Cancel Appointment?',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
        ),
        content: const Text(
          'Are you sure you want to cancel this booking? This slot will become available for others.',
          style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('No, Keep It', style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.statusCancelled,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            onPressed: () async {
              Navigator.pop(ctx);
              final provider = Provider.of<BookingProvider>(context, listen: false);
              final success = await provider.cancelBooking(bookingId);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(success ? 'Booking cancelled' : (provider.errorMessage ?? 'Failed to cancel')),
                    backgroundColor: success ? AppColors.statusConfirmed : AppColors.statusCancelled,
                  ),
                );
              }
            },
            child: const Text('Yes, Cancel', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bookingProvider = Provider.of<BookingProvider>(context);

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
          'My Bookings',
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
            // Screen 10 Segmented Control: "Upcoming" | "Past"
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.border),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: AppColors.primary,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.25),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                labelColor: Colors.white,
                unselectedLabelColor: AppColors.textSecondary,
                labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                tabs: const [
                  Tab(text: 'Upcoming'),
                  Tab(text: 'Past'),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Upcoming Bookings List
                  RefreshIndicator(
                    color: AppColors.primary,
                    onRefresh: () => bookingProvider.fetchMyBookings(),
                    child: bookingProvider.isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                            ),
                          )
                        : bookingProvider.upcomingBookings.isEmpty
                            ? _buildEmptyState('No upcoming appointments', 'Book a new service from the Home tab!')
                            : ListView.builder(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                itemCount: bookingProvider.upcomingBookings.length,
                                itemBuilder: (context, index) {
                                  final booking = bookingProvider.upcomingBookings[index];
                                  return BookingCard(
                                    booking: booking,
                                    onCancel: () => _showCancelDialog(booking.id),
                                  );
                                },
                              ),
                  ),
                  // Past Bookings List
                  RefreshIndicator(
                    color: AppColors.primary,
                    onRefresh: () => bookingProvider.fetchMyBookings(),
                    child: bookingProvider.isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                            ),
                          )
                        : bookingProvider.pastBookings.isEmpty
                            ? _buildEmptyState('No past bookings', 'Your completed and cancelled history will appear here.')
                            : ListView.builder(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                itemCount: bookingProvider.pastBookings.length,
                                itemBuilder: (context, index) {
                                  final booking = bookingProvider.pastBookings[index];
                                  return BookingCard(booking: booking);
                                },
                              ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(String title, String subtitle) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.calendar_today_outlined, size: 58, color: AppColors.textLight),
            const SizedBox(height: 14),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
