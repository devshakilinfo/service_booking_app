import 'package:flutter/material.dart';
import '../../../core/constants.dart';
import '../../../models/booking_model.dart';
import '../admin_booking_details_screen.dart';
import 'admin_metric_card.dart';

class AdminBookingCard extends StatelessWidget {
  final BookingModel booking;

  const AdminBookingCard({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
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
      decoration: adminWhiteCardDecoration(),
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
}
