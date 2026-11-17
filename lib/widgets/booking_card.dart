import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../core/constants.dart';
import '../models/booking_model.dart';

class BookingCard extends StatelessWidget {
  final BookingModel booking;
  final VoidCallback? onCancel;

  const BookingCard({
    super.key,
    required this.booking,
    this.onCancel,
  });

  Color _getStatusBgColor(String status) {
    switch (status) {
      case 'Confirmed':
        return AppColors.statusConfirmedBg;
      case 'Pending':
        return AppColors.statusPendingBg;
      case 'Cancelled':
        return AppColors.statusCancelledBg;
      case 'Completed':
      default:
        return AppColors.statusCompletedBg;
    }
  }

  Color _getStatusTextColor(String status) {
    switch (status) {
      case 'Confirmed':
        return AppColors.statusConfirmed;
      case 'Pending':
        return AppColors.statusPending;
      case 'Cancelled':
        return AppColors.statusCancelled;
      case 'Completed':
      default:
        return AppColors.statusCompleted;
    }
  }

  @override
  Widget build(BuildContext context) {
    final service = booking.service;
    final isCancellable = (booking.status == 'Pending' || booking.status == 'Confirmed');

    // Format date nicely like "Wed, 19 Nov, 10:00 AM"
    String dateDisplay = '${booking.date}, ${booking.timeSlot}';
    try {
      final parsed = DateTime.parse(booking.date);
      dateDisplay = '${DateFormat('EEE, d MMM').format(parsed)}, ${booking.timeSlot}';
    } catch (_) {}

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.network(
              service?.image ?? 'https://images.unsplash.com/photo-1581578731548-c64695cc6952?w=800',
              height: 72,
              width: 72,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 72,
                width: 72,
                color: AppColors.primaryUltraLight,
                child: const Icon(Icons.cleaning_services_rounded, color: AppColors.primary),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  service?.name ?? 'Home Service',
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  dateDisplay,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusBgColor(booking.status),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    booking.status,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: _getStatusTextColor(booking.status),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (isCancellable && onCancel != null)
            GestureDetector(
              onTap: onCancel,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
