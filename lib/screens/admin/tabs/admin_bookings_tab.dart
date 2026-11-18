import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants.dart';
import '../../../providers/booking_provider.dart';
import '../widgets/admin_booking_card.dart';

class AdminBookingsTab extends StatefulWidget {
  const AdminBookingsTab({super.key});

  @override
  State<AdminBookingsTab> createState() => _AdminBookingsTabState();
}

class _AdminBookingsTabState extends State<AdminBookingsTab> {
  String _bookingSearch = '';
  int _selectedBookingFilterIndex = 0;
  final List<String> _bookingFilters = ['All', 'Pending', 'Confirmed', 'Completed', 'Cancelled'];

  @override
  Widget build(BuildContext context) {
    final bookingProvider = Provider.of<BookingProvider>(context);
    final bookingsSource = bookingProvider.adminBookings;

    final filtered = bookingsSource.where((b) {
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
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                children: List.generate(_bookingFilters.length, (index) {
                  final isSelected = _selectedBookingFilterIndex == index;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(
                        _bookingFilters[index],
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isSelected ? Colors.white : AppColors.textPrimary,
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: AppColors.primary,
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
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
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => bookingProvider.fetchAllBookingsAdmin(),
                child: filtered.isEmpty
                    ? ListView(
                        children: const [
                          SizedBox(height: 100),
                          Center(
                            child: Text(
                              'No bookings found for selected filter.',
                              style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                            ),
                          ),
                        ],
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                        itemCount: filtered.length,
                        itemBuilder: (ctx, idx) => AdminBookingCard(booking: filtered[idx]),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
