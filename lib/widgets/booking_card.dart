import 'package:flutter/material.dart';
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
        return AppColors.successBg;
      case 'Pending':
        return AppColors.warningBg;
      case 'Cancelled':
        return AppColors.errorBg;
      case 'Completed':
      default:
        return const Color(0xFFF3F4F6);
    }
  }

  Color _getStatusTextColor(String status) {
    switch (status) {
      case 'Confirmed':
        return AppColors.success;
      case 'Pending':
        return AppColors.warning;
      case 'Cancelled':
        return AppColors.error;
      case 'Completed':
      default:
        return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final service = booking.service;
    final isCancellable = (booking.status == 'Pending' || booking.status == 'Confirmed');

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              service?.image ?? 'https://images.unsplash.com/photo-1581578731548-c64695cc6952?w=800',
              height: 70,
              width: 70,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 70,
                width: 70,
                color: AppColors.primaryUltraLight,
                child: const Icon(Icons.home_repair_service, color: AppColors.primary),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  service?.name ?? 'Home Service',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${booking.date}, ${booking.timeSlot}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: _getStatusBgColor(booking.status),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    booking.status,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: _getStatusTextColor(booking.status),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (isCancellable && onCancel != null)
            TextButton(
              onPressed: onCancel,
              style: TextButton.styleFrom(
                foregroundColor: AppColors.error,
                padding: const EdgeInsets.symmetric(horizontal: 8),
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
            ),
        ],
      ),
    );
  }
}
