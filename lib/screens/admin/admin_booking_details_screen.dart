import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../models/booking_model.dart';

class AdminBookingDetailsScreen extends StatefulWidget {
  final BookingModel booking;

  const AdminBookingDetailsScreen({super.key, required this.booking});

  @override
  State<AdminBookingDetailsScreen> createState() => _AdminBookingDetailsScreenState();
}

class _AdminBookingDetailsScreenState extends State<AdminBookingDetailsScreen> {
  late String _currentStatus;

  @override
  void initState() {
    super.initState();
    _currentStatus = widget.booking.status;
  }

  void _updateStatus(String newStatus) {
    setState(() {
      _currentStatus = newStatus;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Booking status updated to "$newStatus"'),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isPending = _currentStatus.toLowerCase() == 'pending';
    final isCompleted = _currentStatus.toLowerCase() == 'completed';
    final isCancelled = _currentStatus.toLowerCase() == 'cancelled';

    Color statusColor = AppColors.statusConfirmed;
    Color statusBg = AppColors.statusConfirmedBg;
    if (isPending) {
      statusColor = AppColors.statusPending;
      statusBg = AppColors.statusPendingBg;
    } else if (isCancelled) {
      statusColor = AppColors.statusCancelled;
      statusBg = AppColors.statusCancelledBg;
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Booking #${widget.booking.id.length > 8 ? widget.booking.id.substring(0, 8).toUpperCase() : widget.booking.id}',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: statusBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: statusColor.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    Icon(
                      isCancelled
                          ? Icons.cancel_outlined
                          : isPending
                              ? Icons.hourglass_top_rounded
                              : Icons.check_circle_rounded,
                      color: statusColor,
                      size: 22,
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Current Order Status',
                          style: TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          _currentStatus.toUpperCase(),
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: statusColor,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'ID: #${widget.booking.id.length > 7 ? widget.booking.id.substring(0, 7) : widget.booking.id}',
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              _buildSectionCard(
                title: 'Customer Information',
                icon: Icons.person_outline_rounded,
                children: [
                  _buildDetailRow('Customer Name', widget.booking.customerName),
                  const Divider(height: 20, color: AppColors.divider),
                  _buildDetailRow('Phone Number', widget.booking.customerPhone),
                  const Divider(height: 20, color: AppColors.divider),
                  _buildDetailRow('Service Address', widget.booking.address.isNotEmpty ? widget.booking.address : 'House 14, Road 7, Dhanmondi, Dhaka'),
                ],
              ),

              const SizedBox(height: 16),

              _buildSectionCard(
                title: 'Service & Schedule',
                icon: Icons.cleaning_services_outlined,
                children: [
                  _buildDetailRow('Service Name', widget.booking.serviceName),
                  const Divider(height: 20, color: AppColors.divider),
                  _buildDetailRow('Date & Time', '${widget.booking.date} • ${widget.booking.time}'),
                  const Divider(height: 20, color: AppColors.divider),
                  _buildDetailRow('Assigned Specialist', 'GreenClean Pro (Team Leader: Kabir)'),
                ],
              ),

              const SizedBox(height: 16),

              _buildSectionCard(
                title: 'Payment Details',
                icon: Icons.receipt_long_outlined,
                children: [
                  _buildDetailRow('Total Amount', '\$${widget.booking.totalPrice.toStringAsFixed(2)}', isBold: true),
                  const Divider(height: 20, color: AppColors.divider),
                  _buildDetailRow('Payment Method', 'Pay After Service (Cash / Digital)'),
                  const Divider(height: 20, color: AppColors.divider),
                  _buildDetailRow('Payment Status', isCompleted ? 'Paid' : 'Pending Clearance'),
                ],
              ),

              const SizedBox(height: 24),

              if (!isCompleted && !isCancelled) ...[
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () => _updateStatus('Completed'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Mark as Completed ✓',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                if (isPending)
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton(
                      onPressed: () => _updateStatus('Confirmed'),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.primary),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: const Text(
                        'Confirm Booking',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.primary),
                      ),
                    ),
                  ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: TextButton(
                    onPressed: () => _updateStatus('Cancelled'),
                    child: const Text(
                      'Cancel Booking',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.statusCancelled),
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
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
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...children,
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
              color: isBold ? AppColors.primary : AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
