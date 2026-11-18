import 'package:flutter/material.dart';
import '../../../core/constants.dart';

class BookingSlotGrid extends StatelessWidget {
  final List<Map<String, dynamic>> slots;
  final String selectedTimeSlot;
  final ValueChanged<String> onSelectSlot;

  const BookingSlotGrid({
    super.key,
    required this.slots,
    required this.selectedTimeSlot,
    required this.onSelectSlot,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2.3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: slots.length,
      itemBuilder: (context, index) {
        final slot = slots[index];
        final time = slot['time'] as String;
        final status = slot['status'] as String;
        final isAvailable = status == 'available';
        final isSelected = selectedTimeSlot == time && isAvailable;

        return GestureDetector(
          onTap: isAvailable ? () => onSelectSlot(time) : null,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary
                  : (isAvailable ? Colors.white : const Color(0xFFF1F3EE)),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected
                    ? AppColors.primary
                    : (isAvailable ? AppColors.border : Colors.transparent),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: isSelected
                        ? Colors.white
                        : (isAvailable ? AppColors.textPrimary : AppColors.textLight),
                  ),
                ),
                const SizedBox(height: 3),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (isAvailable) ...[
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: Color(0xFF22C55E),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Available',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: isSelected ? const Color(0xFFDCFCE7) : const Color(0xFF16A34A),
                        ),
                      ),
                    ] else ...[
                      Text(
                        status == 'booked' ? '🔒 BOOKED' : '🔒 UNAVAILABLE',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFFDC2626),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
