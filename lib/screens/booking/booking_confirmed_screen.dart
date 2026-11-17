import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/constants.dart';
import '../../models/booking_model.dart';
import '../../widgets/app_illustrations.dart';
import '../../widgets/custom_button.dart';
import '../main_navigation_screen.dart';

class BookingConfirmedScreen extends StatelessWidget {
  final BookingModel booking;

  const BookingConfirmedScreen({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    // Format date nicely like "Wed, 19 Nov 2026"
    String formattedDate = booking.date;
    try {
      final parsed = DateTime.parse(booking.date);
      formattedDate = DateFormat('EEE, d MMM yyyy').format(parsed);
    } catch (_) {}

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              // Screen 9: Big green circle with checkmark
              Container(
                height: 92,
                width: 92,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(Icons.check_rounded, size: 52, color: Colors.white),
              ),
              const SizedBox(height: 22),
              const Text(
                'Booking Confirmed!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Your appointment has been\nsuccessfully booked.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 28),
              // Mini booking summary card
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.border),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
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
                        booking.service?.image ??
                            'https://images.unsplash.com/photo-1581578731548-c64695cc6952?w=800',
                        height: 56,
                        width: 56,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 56,
                          width: 56,
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
                            booking.service?.name ?? 'Home Cleaning',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            formattedDate,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            booking.timeSlot,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Screen 9: Cute Village House with trees illustration
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: HouseWithGardenIllustration(height: 120),
              ),
              const Spacer(flex: 2),
              // Back to Home Button
              CustomButton(
                text: 'Back to Home',
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const MainNavigationScreen()),
                    (route) => false,
                  );
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
