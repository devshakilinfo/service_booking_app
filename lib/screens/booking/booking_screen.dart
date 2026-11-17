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
  String? _selectedTimeSlot;
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
      _selectedTimeSlot = null;
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
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bookingProvider = Provider.of<BookingProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF6FAF3),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Book Appointment',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
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
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              widget.service.image,
                              height: 60,
                              width: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(
                                height: 60,
                                width: 60,
                                color: AppColors.primaryUltraLight,
                                child: const Icon(Icons.cleaning_services, color: AppColors.primary),
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
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '\$${widget.service.price.toStringAsFixed(0)} • ${widget.service.duration}',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: AppColors.textSecondary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Select Date',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
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
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: isSelected ? AppColors.primary : AppColors.border,
                                ),
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
                                  const SizedBox(height: 6),
                                  Text(
                                    DateFormat('d').format(date),
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w700,
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
                    const Text(
                      'Available Slots',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
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
                        spacing: 10,
                        runSpacing: 10,
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
                              width: (MediaQuery.of(context).size.width - 60) / 3,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.primary
                                    : (isAvailable ? Colors.white : const Color(0xFFF0F0F0)),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.primary
                                      : (isAvailable ? AppColors.border : Colors.transparent),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  slot,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
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
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _notesController,
                      maxLines: 2,
                      decoration: InputDecoration(
                        hintText: 'e.g. Please bring eco-friendly cleaning detergents',
                        hintStyle: const TextStyle(color: AppColors.textLight, fontSize: 13),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.border),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.border),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
