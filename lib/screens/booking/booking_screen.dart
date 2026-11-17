import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/constants.dart';
import '../../models/service_model.dart';
import '../../providers/booking_provider.dart';
import '../../providers/service_provider.dart';
import '../../widgets/custom_button.dart';
import 'booking_confirmed_screen.dart';

class BookingScreen extends StatefulWidget {
  final ServiceModel service;

  const BookingScreen({super.key, required this.service});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  late DateTime _selectedDate;
  String? _selectedTimeSlot = '10:00 AM'; // Default to 10:00 AM matching Screen 8 mockup
  final TextEditingController _notesController = TextEditingController();
  List<Map<String, dynamic>> _slotAvailability = [];
  bool _isLoadingSlots = false;

  final List<DateTime> _dates = List.generate(
    14,
    (index) => DateTime.now().add(Duration(days: index)),
  );

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _fetchSlotsForDate(_selectedDate);
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _fetchSlotsForDate(DateTime date) async {
    setState(() {
      _isLoadingSlots = true;
    });

    final formattedDate = DateFormat('yyyy-MM-dd').format(date);
    final serviceProvider = Provider.of<ServiceProvider>(context, listen: false);
    final slots = await serviceProvider.fetchAvailability(widget.service.id, formattedDate);

    if (mounted) {
      setState(() {
        _slotAvailability = slots.isNotEmpty
            ? slots
            : widget.service.availableSlots.map((s) => {'time': s, 'isAvailable': true}).toList();
        _isLoadingSlots = false;
      });
    }
  }

  void _confirmBooking() async {
    if (_selectedTimeSlot == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an available time slot')),
      );
      return;
    }

    final formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate);
    final bookingProvider = Provider.of<BookingProvider>(context, listen: false);

    final success = await bookingProvider.createBooking(
      serviceId: widget.service.id,
      date: formattedDate,
      timeSlot: _selectedTimeSlot!,
      notes: _notesController.text.trim(),
    );

    if (!mounted) return;

    if (success && bookingProvider.lastCreatedBooking != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => BookingConfirmedScreen(
            booking: bookingProvider.lastCreatedBooking!,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(bookingProvider.errorMessage ?? 'Booking failed. Slot may already be taken.'),
          backgroundColor: AppColors.statusCancelled,
        ),
      );
    }
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
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Book Appointment',
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
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Screen 8 Service summary mini-card
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: AppColors.border),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.02),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              widget.service.image,
                              height: 60,
                              width: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(
                                height: 60,
                                width: 60,
                                color: AppColors.primaryUltraLight,
                                child: const Icon(Icons.cleaning_services_rounded,
                                    color: AppColors.primary),
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.service.name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '\$${widget.service.price.toStringAsFixed(0)} • ${widget.service.duration}',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: AppColors.textSecondary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Screen 8 Section: Select Date
                    const Text(
                      'Select Date',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 80,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _dates.length,
                        itemBuilder: (context, index) {
                          final date = _dates[index];
                          final isSelected = DateFormat('yyyy-MM-dd').format(date) ==
                              DateFormat('yyyy-MM-dd').format(_selectedDate);

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedDate = date;
                              });
                              _fetchSlotsForDate(date);
                            },
                            child: Container(
                              width: 58,
                              margin: const EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                color: isSelected ? AppColors.primary : Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: isSelected ? AppColors.primary : AppColors.border,
                                ),
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color: AppColors.primary.withValues(alpha: 0.25),
                                          blurRadius: 8,
                                          offset: const Offset(0, 3),
                                        ),
                                      ]
                                    : [],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    DateFormat('EEE').format(date),
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: isSelected ? Colors.white70 : AppColors.textSecondary,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    DateFormat('d').format(date),
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w800,
                                      color: isSelected ? Colors.white : AppColors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Screen 8 Section: Available Slots
                    const Text(
                      'Available Slots',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (_isLoadingSlots)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                          ),
                        ),
                      )
                    else
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: _slotAvailability.map((slotData) {
                          final slot = slotData['time'] as String;
                          final isAvailable = slotData['isAvailable'] as bool;
                          final isSelected = _selectedTimeSlot == slot;

                          return GestureDetector(
                            onTap: isAvailable
                                ? () {
                                    setState(() {
                                      _selectedTimeSlot = slot;
                                    });
                                  }
                                : null,
                            child: Container(
                              width: (MediaQuery.of(context).size.width - 64) / 3,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.primary
                                    : (isAvailable ? Colors.white : const Color(0xFFF3F4F1)),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.primary
                                      : (isAvailable ? AppColors.border : Colors.transparent),
                                ),
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color: AppColors.primary.withValues(alpha: 0.25),
                                          blurRadius: 8,
                                          offset: const Offset(0, 3),
                                        ),
                                      ]
                                    : [],
                              ),
                              child: Center(
                                child: Text(
                                  slot,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: isSelected
                                        ? Colors.white
                                        : (isAvailable
                                            ? AppColors.textPrimary
                                            : AppColors.textLight),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    const SizedBox(height: 24),
                    const Text(
                      'Special Instructions (Optional)',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: TextField(
                        controller: _notesController,
                        maxLines: 2,
                        decoration: const InputDecoration(
                          hintText: 'e.g. Please bring eco-friendly cleaning supplies',
                          hintStyle: TextStyle(color: AppColors.textLight, fontSize: 13),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(14),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Screen 8 Bottom Button: Confirm Booking
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: AppColors.border)),
              ),
              child: CustomButton(
                text: 'Confirm Booking',
                isLoading: bookingProvider.isLoading,
                onPressed: _confirmBooking,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
