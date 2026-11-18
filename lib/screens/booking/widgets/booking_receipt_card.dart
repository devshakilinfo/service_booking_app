import 'package:flutter/material.dart';
import '../../../core/constants.dart';
import '../../../models/booking_model.dart';

class BookingAppointmentInfoCard extends StatelessWidget {
  final BookingModel booking;
  final String address;
  final String notes;
  final bool isCancelled;

  const BookingAppointmentInfoCard({
    super.key,
    required this.booking,
    required this.address,
    required this.notes,
    required this.isCancelled,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          _buildInfoRow(Icons.calendar_today_rounded, 'Date', booking.date),
          const Divider(height: 22, color: AppColors.border),
          _buildInfoRow(Icons.access_time_rounded, 'Time Slot', booking.timeSlot),
          const Divider(height: 22, color: AppColors.border),
          _buildInfoRow(Icons.location_on_outlined, 'Service Address', address),
          if (notes.isNotEmpty) ...[
            const Divider(height: 22, color: AppColors.border),
            _buildInfoRow(Icons.edit_note_rounded, 'Special Notes', notes),
          ],
          if (isCancelled && booking.cancellationReason.isNotEmpty) ...[
            const Divider(height: 22, color: AppColors.border),
            _buildInfoRow(Icons.info_outline_rounded, 'Cancellation Reason', booking.cancellationReason, isAlert: true),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, {bool isAlert = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: isAlert ? AppColors.statusCancelled : AppColors.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: isAlert ? AppColors.statusCancelled : AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class BookingPaymentSummaryCard extends StatelessWidget {
  final double totalPrice;

  const BookingPaymentSummaryCard({super.key, required this.totalPrice});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          _buildPaymentRow('Service Rate', '\$${totalPrice.toStringAsFixed(2)}'),
          const SizedBox(height: 8),
          _buildPaymentRow('Convenience & Booking Fee', 'FREE', isGreen: true),
          const SizedBox(height: 8),
          _buildPaymentRow('Payment Method', 'Pay After Service'),
          const Divider(height: 22, color: AppColors.border),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Payable',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                '\$${totalPrice.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentRow(String label, String value, {bool isGreen = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: isGreen ? AppColors.statusConfirmed : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
